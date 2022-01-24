Function New-AzVMwithDisk {
    
    [CmdletBinding()]
    param (
        [String] $ResourceGroup = "",

        [Parameter(ValueFromPipeline=$true)]
        [String[]] $VirtualMachine,

        [Parameter(ValueFromPipeline=$true)]
        [String] $Location,

        [Switch] $DefaultCred,

        [ValidateRange(0,14)]
        [Int32] $DiskCount
    )

    <#
        .SYNOPSIS
        Creates a VM along with Disks on Azure Platform

        .DESCRIPTION
        Create a VM and mention the number of disks within a range from 0..14. \
        If a valid ResourceGroup is not provided a default random generated ResourceGroup name is used for creating a VM under it. \

        .PARAMETER ResourceGroup
        Provide the Name of the Resource Group. Parameter is not mandatory, if not provided it'll take the default randomly generated value.

        .PARAMETER VirtualMachine
        Provide the Name of the Virtual Machine needed to be created

        .PARAMETER Location
        Provide the Location to create the VM and it's resource

        .PARAMETER DefaultCred
        A switch that enabled default credentials to be enabled

        .PARAMETER DiskCount
        Provide the number of disks to create. Defaulted to the range 0..14

        .LINK
        The Function involves other cmdlets used, as specifed:
            - Write-Verbose
            - New-AzResourceGroup
            - New-AzVM
            - Get-AzVM
            - Add-AzVMDataDisk
            - New-Object
            - ConverTo-SecureString
            - Update-AzVM
            - Write-Host
            - Select-Object
    #>


    BEGIN {
    # Create a ResourceGroup if not provided
        if (!$VirtualMachine) {
            $VirtualMachine = $(Write-Host 'Provide a name for the Virtual Machine'  -NoNewline; Write-Host " [>>>] " -ForegroundColor Yellow -NoNewline ; Read-Host)
        }

        if (!$Location) {
            $Location = $(Write-Host 'Enter the location for the Virtual Machine' -NoNewline; Write-Host " [>>>] " -ForegroundColor Yellow -NoNewline ; Read-Host)
        }

        if ($ResourceGroup -eq $null -or $ResourceGroup -eq "" -or !(Get-AzResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue)) {
            Write-Host "The Resource Group doesn't exist or is null." -ForegroundColor Yellow
            Write-Host "Creating a new Resource Group with the Default Randomly generated Name" -ForegroundColor Yellow
            
            $ResourceGroup = 'DefaultRG' + (-join ((65..90) + (97..122) | Get-Random | ForEach-Object {[char]$_})) + (Get-Random)
            New-AzResourceGroup -Name $ResourceGroup -Location $Location -ErrorAction Stop
        }
    }

    PROCESS {
    # Create a new Virtual Machine in the resourcegroup
        Write-Host "Creating a new VM named $VirtualMachine on the Resource Group $ResourceGroup on $Location" -ForegroundColor Yellow
        
        $credential = ''
       
        # For User Input on credential or execute a default
        if (!$DefaultCred) {
            Write-Host "Provide a common username" -NoNewline
            Write-Host " [>>>] " -ForegroundColor Yellow -NoNewline
            $username = Read-Host

            Write-Host "Provide a common password" -NoNewline
            Write-Host " [>>>] " -ForegroundColor Yellow -NoNewline
            $password = Read-Host -AsSecureString

            $credential = New-Object System.Management.Automation.PsCredential($username, $password)
        } else {
            $credential = New-Object System.Management.Automation.PsCredential('vmadmin', ('Password@123' | ConvertTo-SecureString -AsPlainText))
        }

        foreach ($VMName in $VirtualMachine) {
            $VM = New-AzVMConfig -VMName $VMName -VMSize Standard_B2ms
            $VM = Set-AzVMOperatingSystem -VM $VM -Windows -ComputerName $VMName -Credential $credential -ProvisionVMAgent -EnableAutoUpdate
            New-AzVM -VM $VM -ResourceGroupName $ResourceGroup -Location $Location
        }

    # Create a new Disk in the VM
        if ($DiskCount -ne $null -or $DiskCount -ne 0) {
            foreach ($VMName in $VirtualMachine) {
                $GetVM = Get-AzVM -ResourceGroupName $ResourceGroup -Name $VMName
                for ($count = 1; $count -le $DiskCount; $count++) {
                    Add-AzVMDataDisk -VM $GetVM -Name ($VMName + '_DataDisk' + $count) -DiskSizeInGB 20 -Lun $count -CreateOption Empty
                }
                Update-AzVM -ResourceGroupName $ResourceGroup -VM $GetVM
            } 
        }
    }

    END {
    # Providing the details on the VM created along with its disks
        $vmdatadisk = @{Label = 'Data Disk'; Expression = $VMName.StorageProfile.dataDisks}
        $vmosdisk = @{Label = 'OS Disk'; Expression = $VMName.StorageProfile.osdisk}
        
        foreach ($VMName in $VirtualMachine) {
            Write-Host "Properties of the Virtual Machine $VMName" -ForegroundColor Yellow
            Get-AzVM -ResourceGroupName $ResourceGroup -Name $VMName | Select-Object -Property ResourceGroupName, Name, Location, $vmosdisk, $vmdatadisk | Format-Table
        }

        Write-Host "Operation Successful" -ForegroundColor Yellow
    }
}    
