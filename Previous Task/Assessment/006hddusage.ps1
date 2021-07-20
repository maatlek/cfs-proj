#.(HARD DISK ANALYSIS)
$JobTriggerMaster = New-JobTrigger -Daily -At "12:00 AM"
$JobTrigger = New-JobTrigger -Once -At "12:05 AM" -RepetitionInterval (New-TimeSpan -Minutes 15) -RepetitionDuration (New-TimeSpan -Days 10)

New-Item -Path "$HOME" -Name "hddlogs" -ItemType Directory
Set-Location -path "$HOME/hddlogs"

Register-ScheduledJob -Name DiskHighLog -Trigger $JobTrigger -ScriptBlock {

        $datetime = @{n="`t`tDateandTime"; e= {"`t" + $(Get-Date)}}
        $hdduse = @{n="`tUsed (GB %)";e={"{0:P}" -f ($_.used/(1GB*100)) + "`n`n"}}

        $HDD = Get-PSDrive -Name C | Select-Object name,$hdduse,$datetime
        
        if (!(Get-Content "./disk-usage.txt"))
        {
            $HDD | Out-File "./disk-usage.txt" -Append
        }
        else
        {
            $HDD | Format-Table -HideTableHeaders | Out-File "./disk-usage.txt" -Append
        }
}

Register-ScheduledJob -Name DiskHighLogMaster -Trigger $JobTriggerMaster -ScriptBlock { Start-Job -Name DiskHighLog }