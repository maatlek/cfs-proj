#Q2 Test Case

Set-Location $HOME
New-Item -Name "uploads" -ItemType Directory

$Count = 0
while ($Count -le 20) {
    $r = Get-Random -Maximum 11048576 -Minimum 948576
    fsutil file createnew ".\$($Count).test" $($r)
    $Count++
}