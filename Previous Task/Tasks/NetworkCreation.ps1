# Creating a new Resource Group for the task
New-AzResourceGroup -Name MKrgT01 -Tag @{RgOwn = "MK"} -Location "Australia East"

# Creating a vnet and its subnet along with its NSG
## Web Subnet
$Rule_804433389 = New-AzNetworkSecurityRuleConfig -Name "Allow-RDP_HTTP_HTTPS" -Direction Inbound -Access Allow -Protocol Tcp -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix "10.100.1.0/24" -DestinationPortRange 80,443,3389 -Priority 1000

$webNSG = New-AzNetworkSecurityGroup -Name "WEB-NSG" -Location australiaeast -ResourceGroupName MKrgT01 -SecurityRules $Rule_804433389 -Tag @{NSGGroup = "Web"}

$webSubnet = New-AzVirtualNetworkSubnetConfig -Name websubnet01 -NetworkSecurityGroup $webNSG -AddressPrefix "10.100.1.0/24"

## DB Subnet
$Rule_33061433 = New-AzNetworkSecurityRuleConfig -Name "Allow-MSSQL_MYSQL" -Direction Inbound -Access Allow -Protocol Tcp -SourceAddressPrefix "10.100.1.0/24" -SourcePortRange * -DestinationAddressPrefix "10.100.2.0/24" -DestinationPortRange 3306,1433 -Priority 1000

$dbNSG = New-AzNetworkSecurityGroup -Name "DB-NSG" -Location australiaeast  -ResourceGroupName MKrgT01 -SecurityRules $Rule_33061433 -Tag @{NSGGroup = "DB"}

$dbSubnet = New-AzVirtualNetworkSubnetConfig -Name dbsubnet01 -NetworkSecurityGroup $dbNSG -AddressPrefix "10.100.2.0/24"

## Subnet 3
$Subnet3 = New-AzVirtualNetworkSubnetConfig -Name subnet03 -AddressPrefix "10.100.100.0/24"

## Creating a vnet
$vnett01 = New-AzVirtualNetwork -Name "vnetT01" -ResourceGroupName MKrgT01 -AddressPrefix "10.100.0.0/16" -Location australiaeast -Subnet $webSubnet,$dbSubnet,$Subnet3

# Creating VMs
##Public IPs
$webpubip = New-AzPublicIpAddress -Name "Webpub" -ResourceGroupName MKrgT01 -Sku "Standard" -Allocation "Static" -Location 'Australia East' -DomainNameLabel "webdomaint01"
$sub03pubip = New-AzPublicIpAddress -Name "Sub03pub" -ResourceGroupName MKrgT01 -Sku "Standard" -Allocation "Static" -Location 'Australia East' -DomainNameLabel "sub03domaint01"

## Credentials
$user = "vmadmin"
$password = ConvertTo-SecureString Password@123 -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential -ArgumentList ($user, $password)

## WebVM in websubnet
$webNIC = New-AzNetworkInterface -Name "webNIC" -ResourceGroupName MKrgT01 -Location 'Australia East' -SubnetId $vnett01.Subnets[0].Id -PublicIpAddressId $webpubip.Id

$WebVM = New-AzVMConfig -VMName "WebVMT01" -VMSize Standard_B1s
$WebVM = Set-AzVMOperatingSystem -VM $WebVM -Windows -ComputerName "Web001" -Credential $credentials
$WebVM = Add-AzVMNetworkInterface -VM $WebVM -Id $webNIC.Id
$WebVM = Set-AzVMSourceImage -VM $WebVM -PublisherName 'microsoftwindowsserver' -Offer 'windowsserver' -Skus '2019-Datacenter' -Version latest
$WebVM = Set-AzVMBootDiagnostic -VM $WebVM -Disable

New-AzVM -ResourceGroupName MKrgT01 -Location 'Australia East' -VM $WebVM

## Sub03VM in subnet03
$sub03NIC = New-AzNetworkInterface -Name "sub03NIC" -ResourceGroupName MKrgT01 -Location 'Australia East' -SubnetId $vnett01.SubNets[2].Id -PublicIpAddressId $sub03pubip.Id

$Sub03VM = New-AzVMConfig -VMName "Sub03VMT01" -VMSize Standard_B1s
$Sub03VM = Set-AzVMOperatingSystem -VM $Sub03VM -Windows -ComputerName "Sub03001" -Credential $credentials
$Sub03VM = Add-AzVMNetworkInterface -VM $Sub03VM -Id $sub03NIC.Id
$Sub03VM = Set-AzVMSourceImage -VM $Sub03VM -PublisherName 'microsoftwindowsserver' -Offer 'windowsserver' -Skus '2019-Datacenter' -Version latest
$Sub03VM = Set-AzVMBootDiagnostic -VM $Sub03VM -Disable

New-AzVM -ResourceGroupName MKrgT01 -Location 'Australia East' -VM $Sub03VM

# Allow RDP on both WebVM & Subnet03VM
## Creating Application Security Groups
$appsg = New-AzApplicationSecurityGroup -ResourceGroupName MKrgT01 -Name "RDP Connectors" -Location 'Australia East' -Tag @{AppSG = "RDPOnly"}

### Adding ASGs to VMs
$nic1 = Get-AzNetworkInterface -ResourceId $WebVM.NetworkProfile.NetworkInterfaces.id
$nic2 = Get-AzNetworkInterface -ResourceId $Sub03VM.NetworkProfile.NetworkInterfaces.id

$nic1.IpConfigurations[0].ApplicationSecurityGroups = $appsg
$nic2.IpConfigurations[0].ApplicationSecurityGroups = $appsg

$nic1 | Set-AzNetworkInterface
$nic2 | Set-AzNetworkInterface

## Creating Rules associating the destination as the application security group
$Rule_3389 = New-AzNetworkSecurityRuleConfig -Name "Allow-RDP" -Direction Inbound -Access Allow -Protocol Tcp -SourceAddressPrefix * -SourcePortRange * -DestinationApplicationSecurityGroup $appsg -DestinationPortRange 3389 -Priority 1000

New-AzNetworkSecurityGroup -Name "Allow_RDP-Only" -ResourceGroupName MKrgT01 -Location 'Australia East' -SecurityRules $Rule_3389


# Removing the Resource Group along with its Resources
Remove-AzResourceGroup -Name MKrgT01 -Force
