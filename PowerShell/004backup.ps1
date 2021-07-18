# Creating a Backup for SEA WebServer

## Registering the resource provider

Register-AzResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"


## Setting Variables

$BackupName = "sea-web-bckp"
$WorkLoadType = "AzureVM"

$BackupRetentionInDays = "30"
$CurrentDate = Get-Date
$BackupScheduleRunTimes = (Get-Date -Year $CurrentDate.Year -Month $CurrentDate.Month -Day $CurrentDate.Day `
-Hour $CurrentDate.Hour -Minute 0 -Second 0 -Millisecond 0).ToUniversalTime()

$BackupScheduleTime = "06:00:00"


## Creating a Recovery Service Vault

$sea_bckpvault =  New-AzRecoveryServicesVault -ResourceGroupName $RG[0] -Name $BackupName -Location $location[0]


### Creating a Backup Policy

$BackupPolicy = Get-AzRecoveryServicesBackupSchedulePolicyObject -WorkloadType $WorkLoadType

$BackupPolicy.ScheduleRunTimes.Clear()
$BackupPolicy.ScheduleRunTimes.Add($BackupScheduleRunTimes)
$BackupPolicy.ScheduleRunDays = $BackupScheduleRetentionInDays


### Creating a Retention Policy

$RetentionPolicy = Get-AzRecoveryServicesBackupRetentionPolicyObject -WorkloadType $WorkLoadType

$RetentionPolicy.DailySchedule.DurationCountInDays = $BackupRetentionInDays
$RetentionPolicy.DailySchedule.RetentionTimes = $BackupScheduleTime


### Disabling other Retention Policy Settings

$RetentionPolicy.IsWeeklyScheduleEnabled = $False
$RetentionPolicy.IsMonthlyScheduleEnabled = $False
$RetentionPolicy.IsYearlyScheduleEnabled = $False


## Creating a BackupProtectionPolicy object based on the above schedule and retention policy

$BackupPolicy = New-AzRecoveryServicesBackupProtectionPolicy -Name 'web-bckp' -WorkloadType $WorkLoadType `
-RetentionPolicy $RetentionPolicy -SchedulePolicy $BackupPolicy -VaultId $sea_bckpvault.ID


## Adding Virtual Machines to Backup

Enable-AzRecoveryServicesBackupProtection -ResourceGroupName $RG[0] -Name $VMs[0].vmname -Policy $BackupPolicy -VaultId $sea_bckpvault.ID
Enable-AzRecoveryServicesBackupProtection -ResourceGroupName $RG[0] -Name $VMs[1].vmname -Policy $BackupPolicy -VaultId $sea_bckpvault.ID