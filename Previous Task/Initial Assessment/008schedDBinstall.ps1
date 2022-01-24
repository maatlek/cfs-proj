#.(DB TIME)

#ForeNoon
$JobTriggerFore = New-JobTrigger -Daily -At "9:00 AM"
$JobTriggerForeEnd = New-JobTrigger -Daily -At "12:00 PM"

Register-ScheduledJob -Name Fore -Trigger $JobTriggerFore -ScriptBlock {
        Start-Service -Name "mysql","postgresql"
    }

Register-ScheduledJob -Name ForeEnd -Trigger $JobTriggerForeEnd -ScriptBlock {
        Stop-Service -Name "mysql","postgresql"
    }

#AfterNoon
$JobTriggerAfter = New-JobTrigger -Daily -At "2:00 PM"
$JobTriggerAfterEnd = New-JobTrigger -Daily -At "6:00 PM"

Register-ScheduledJob -Name After -Trigger $JobTriggerAfter -ScriptBlock {
        Start-Service -Name "sqlserver"
    }

Register-ScheduledJob -Name AfterEnd -Trigger $JobTriggerAfterEnd -ScriptBlock {
        Stop-Service -Name "sqlserver"
    }

#Evening
$JobTriggerN = New-JobTrigger -Daily -At "6:00 PM"
$JobTriggerNEnd = New-JobTrigger -Daily -At "10:00 PM"

Register-ScheduledJob -Name N  -Trigger $JobTriggerN -ScriptBlock {
        Start-Service -Name "monogdb"
    }

Register-ScheduledJob -Name NEnd -Trigger $JobTriggerNEnd -ScriptBlock {
        Stop-Service -Name "mongodb"
    }