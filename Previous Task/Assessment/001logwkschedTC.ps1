#Q1 Test Case
New-Item -Path "$HOME" -Name "logs" -ItemType Directory
Set-Location "$HOME\logs"
Get-Date -OutVariable date
$Count = 0

while($Count -le 10)
    {   
        [string]$dd = "{0:dd-mm-yyyy}" -f $date
        Write-Output "$Count" | Out-File ".\log-$($dd).log"
    
            $date = $date.AddDays(-1)
            $Count++
        
    }