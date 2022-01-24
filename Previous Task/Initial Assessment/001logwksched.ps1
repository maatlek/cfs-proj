#.(SCHEDULED JOB WEEKLY LOG)

#Job Trigger
$JobTrigger = New-JobTrigger -weekly -DaysOfWeek Tuesday -At "12:30 AM"

#Register
#Run only in Powershell 5.1
Register-ScheduledJob -Name WeeklyLogCon -Trigger $JobTrigger -ScriptBlock {
    Get-Date -OutVariable date
    $weekno = get-date -UFormat %V
    $Count = 0
        
    while($Count -eq 7)
    {    
        [string]$dd = "{0:dd-mm-yyyy}" -f $date
        Get-ChildItem -Path "$HOME\logs" |Sort-Object LastWriteTime -Descending | ForEach-Object {
            if($_.Name -eq "log-$($dd).log") 
            {
                Get-Content "log-$($dd).log" | Out-File -filepath "$HOME\weeklylog\log-week-$weekno.log" -Append
            }
    
            $date = $date.AddDays(-1)
            $Count++
        }
    }
}

Start-Job -DefinitionName WeeklyLogCon