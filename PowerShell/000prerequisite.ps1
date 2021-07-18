# Initial Setup

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Set-ExecutionPolicy Unrestricted

Update-Module

Install-Module az

Connect-AzAccount


# Verification

Get-AzTenant

Get-AzContext


# Creating a Resource Group

$RG = "Nilavembu_SEA","Nilavembu_EUS"
$location = "Australia East","Canada Central"

New-AzResourceGroup -Name $RG[0] -Tag @{Business = "Nilavembu"} -Location $location[0]

New-AzResourceGroup -Name $RG[1] -Tag @{Business = "Nilavembu"} -Location $location[1]