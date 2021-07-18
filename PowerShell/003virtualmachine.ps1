# Creating a Virtual Machine

# Creating a credential for all the VMs

$credential = New-Object System.Management.Automation.PsCredential('mkadmin', ('Password@123' | ConvertTo-SecureString -AsPlainText))


## Creating a Availability Set

$set = @{
    Name = 'sea-availabilityset'
    ResourceGroupName = $RG[0]
    Location = $location[0]
    Sku = 'Aligned'
    PlatformFaultDomainCount = '2'
    PlatformUpdateDomainCount =  '1'
}
$sea_avs = New-AzAvailabilitySet @set


## Creating a Network Interface

### For SEA Web Server
$snic1 = @{
    Name = "sea_webnic1"
    ResourceGroupName = $RG[0]
    Location = $location[0]
    Subnet = $sea_vnet.Subnets[0]
    NetworkSecurityGroup = $sea_nsg
    LoadBalancerBackendAddressPool = $bepool
}
$sea_webnic1 = New-AzNetworkInterface @snic1

$snic2 = @{
    Name = "sea_webnic2"
    ResourceGroupName = $RG[0]
    Location = $location[0]
    Subnet = $sea_vnet.Subnets[0]
    NetworkSecurityGroup = $sea_nsg
    LoadBalancerBackendAddressPool = $bepool
}
$sea_webnic2 = New-AzNetworkInterface @snic2


### For SEA Jump Server

$seapip = New-AzPublicIpAddress -Name jump-pubip -ResourceGroupName $RG[0] -AllocationMethod Dynamic -Location $location[0]

$snic3 = @{
    Name = "sea_jumpnic"
    ResourceGroupName = $RG[0]
    Location = $location[0]
    Subnet = $sea_vnet.Subnets[1]
    NetworkSecurityGroup = $sea_nsg
}

$sea_jumpnic = New-AzNetworkInterface @snic3 | Set-AzNetworkInterfaceIpConfig -Name jumpipconfig -PublicIPAddress $seapip -Subnet $sea_vnet.Subnets[1]


### For EUS Server11

$euspip = New-AzPublicIpAddress -Name server11-pubip -ResourceGroupName $RG[1] -AllocationMethod Dynamic -Location $location[1]

$enic = @{
    Name = "myNicVM$i"
    ResourceGroupName = $RG[1]
    Location = $location[1]
    Subnet = $eus_vnet.Subnets[0]
    NetworkSecurityGroup = $eus_nsg
}
$eus_webnic = New-AzNetworkInterface @enic | Set-AzNetworkInterfaceIpConfig -Name server11ipconfig -PublicIPAddress $euspip -Subnet $eus_vnet.Subnets[0]


## Creating a Virtual Machine configuration

### Creating a array set of Virtual Machines

$VMs = @(
    [PSCustomObject]@{
        vmname = 'webserver01'
        nic = $sea_webnic1
        rg = $RG[0]
        location = $location[0]
    }
    [PSCustomObject]@{
        vmname = 'webserver11'
        nic = $sea_webnic2
        rg = $RG[0]
        location = $location[0]
    }
    [PSCustomObject]@{
        vmname = 'jumpserver'
        nic = $sea_jumpnic
        rg = $RG[0]
        location = $location[0]
    }
    [PSCustomObject]@{
        vmname = 'server11'
        nic = $eus_webnic
        rg = $RG[0]
        location = $location[1]
    }

)


### Running commands on the array created

$i = 1

foreach ($VM in $VMs) {

    $vmsz = @{}
    
    if ($i -le 2) {
        $vmsz = @{
            VMName = $VM.vmname
            VMSize = 'Standard_DS1_v2'
            AvailabilitySetId = $sea_avs.Id   
        }
    } else {
        $vmsz = @{
            VMName = $VM.vmname
            VMSize = 'Standard_DS1_v2' 
        }
    }
    
    $vmos = @{
        ComputerName = $VM.vmname
        Credential = $credential
    }

    $vmimage = @{
        PublisherName = 'MicrosoftWindowsServer'
        Offer = 'WindowsServer'
        Skus = '2019-Datacenter'
        Version = 'latest'    
    }

    $vmConfig = New-AzVMConfig @vmsz `
        | Set-AzVMOperatingSystem @vmos -Windows `
        | Set-AzVMSourceImage @vmimage `
        | Add-AzVMNetworkInterface -Id $VM.nic.Id `
        | Set-AzVMBootDiagnostic -Disable

    if ($i -le 3) {
        $vm = @{
            ResourceGroupName = $RG[0]
            Location = $location[0]
            VM = $vmConfig
        }
    } else {
        $vm = @{
            ResourceGroupName = $RG[1]
            Location = $location[1]
            VM = $vmConfig
        }
    }
    New-AzVM @vm 

    $i++
}

## Creating Alerts

$SMS = New-AzActionGroupReceiver -Name "SMS for CPU" -SmsReceiver -CountryCode '91' -PhoneNumber '5555555555'
$act = Set-AzActionGroup -Name "Act_CPUHigh" -ResourceGroup $RG[0] -Receiver $SMS -ShortName "cpuh"

$VMid1 = (Get-AzureRmVM -ResourceGroupName $RG[0] -Name $VMs[0].vmname).Id
$VMid2 = (Get-AzureRmVM -ResourceGroupName $RG[0] -Name $VMs[1].vmname).Id
Get-AzMetricDefinition -ResourceId $VMid1

$criteria = New-AzMetricAlertRuleV2Criteria -MetricName "Percentage CPU" `
    -MetricNameSpace "Microsoft.Compute/virtualMachines" `
    -TimeAggregation Average `
    -Operator GreaterThan `
    -Threshold 80


Add-AzMetricAlertRuleV2 -Name vmcpu_gt_80 `
    -ResourceGroup $RG[0] `
    -TargetResourceScope $VMid1, $VMid2 `
    -TargetResourceType "Microsoft.Compute/virtualMachines" `
    -TargetResourceRegion $location[0] `
    -WindowSize 00:05:00 `
    -Frequency 0:5 `
    -Description "alert on CPU > 80%" `
    -Severity 4 `
    -ActionGroupId $act.Id `
    -Condition $criteria



## Enabling FTP Login

Enable-AzVMPSRemoting -Name $VMs[0].vmname -ResourceGroupName $RG[0] -Protocol https -OsType Windows
Enable-AzVMPSRemoting -Name $VMs[1].vmname -ResourceGroupName $RG[0] -Protocol https -OsType Windows

Enable-AzVMPSRemoting -Name $VMs[3].vmname -ResourceGroupName $RG[1] -Protocol https -OsType Windows

Invoke-AzVMCommand -Name $VMs[0].vmname -ResourceGroupName $RG[0] -CommandId 'RunPowerShellScript' -ScriptPath '003xftp.ps1'