
New-Item -Path $HOME -ItemType Directory -Name "extension" | Set-Location

$i = 0


".pptx",".docx",".xlsx",".docx",".png",".gif",".jpg",".mp4",".avi" | ForEach-Object {
    New-Item "./$($i)$($_)"
    $i++
}