#.(SCHEDULE JOB INSTALLATION & UNINSTALLATION)


$JobTriggerMaster = New-JobTrigger -Daily -At "12:00 AM"
$JobTrigger = New-JobTrigger -Once -At "12:05 AM"
$Software = "openjdk","mysql"

Register-ScheduledJob -Name MonthlyInstall -Trigger $JobTrigger -ScriptBlock `
        {Find-Package -Provider chocolatey -name $Software -Force | Install-Package }

Register-ScheduledJob -Name MonthlyUninstall -Trigger $JobTrigger -ScriptBlock `
        {Find-Package -Provider chocolatey -name $Software -Force | Uninstall-Package}


Register-ScheduledJob -Name Master -Trigger $JobTriggerMaster -ScriptBlock {
    $datestart = Get-Date -UFormat %d

    If ($datestart -eq 1) 
    {
        Start-Job -DefinitionName MonthlyInstall
    } 
    ElseIf ($datestart -eq 10) 
    {
        Start-Job -DefinitionName MonthlyUninstall
    }
    
}

Start-Job -DefinitionName "Master"