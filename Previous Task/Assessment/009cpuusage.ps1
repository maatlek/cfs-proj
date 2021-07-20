#.(CPU HIGH ANALYSIS)

$JobTriggerMaster = New-JobTrigger -Once -At "12:00 AM" -RepetitionInterval (New-TimeSpan -Minutes 15) -RepeatIndefinitely
New-Item -ItemType Directory -Name cpulog -path "$HOME"

Register-ScheduledJob -Name CPUHighLog -Trigger $JobTriggerMaster -ScriptBlock `
{ `
    Set-Location "$HOME/cpulog" `
    $datetime = @{Label="`t`t Date and Time"; Expression= {Get-Date}} `
    $cpuf = @{Label="CPU High(%)`t"; Expression = {"{0:P}" -f ($_.Average/100)}} `
        
    $CPUUsage = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average -OutVariable cpuavg | Select-Object -Property $cpuf,$datetime `
    
    if ($cpuavg.Average -gt 70) `
    { `
        if (!(Get-Content "./cpuhigh-usage.txt" -ErrorAction SilentlyContinue)) `
        { `
            $CPUUsage | Out-File "./cpuhigh-usage.txt" -Append `
        } `
        else `
        { `
            $CPUUsage | Format-Table -HideTableHeaders | Out-File "./cpuhigh-usage.txt" -Append `
        } `
    } `
}