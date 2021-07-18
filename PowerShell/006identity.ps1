# Creating User Account

Connect-AzureAD

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "CfsPassword@123"

## For managing VMs in Subscription

New-AzureADUser -DisplayName "VM Admin" `
    -PasswordProfile $PasswordProfile `
    -UserPrincipalName "vm_admin@mkfsd123.onmicrosoft.com" `
    -AccountEnabled $true `
    -MailNickName "vmadmin"

New-AzRoleAssignment -SignInName "vm_admin@mkfsd123.onmicrosoft.com" `
    -RoleDefinitionName "Virtual Machine Contributor" `
    -Scope "/subscriptions/7e970a5a-ab04-4b97-bc65-0b1e079a1ad9/"

## For Managing backups in EUS Region

New-AzureADUser -DisplayName "Backup Admin" `
    -PasswordProfile $PasswordProfile `
    -UserPrincipalName "backup_admin@mkfsd123.onmicrosoft.com" `
    -AccountEnabled $true `
    -MailNickName "backupadmin"

New-AzRoleAssignment -SignInName "backup_admin@mkfsd123.onmicrosoft.com" `
    -RoleDefinitionName "Backup Contributor" `
    -Scope "/subscriptions/7e970a5a-ab04-4b97-bc65-0b1e079a1ad9/resourceGroups/Nilavembu_EUS/providers/Microsoft.Compute/virtualMachines/server11"