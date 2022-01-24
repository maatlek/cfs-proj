#.(SEGREAGATE FILES)

$video = ".mp4",".avi"
$image = ".png",".gif",".jpg"
$document = ".pptx",".docx",".xlsx",".docx"

$Folders = "videos","images","documents","miscellaneous"

New-Item -ItemType Directory $Folders

Get-ChildItem -Path "$HOME\extension" -Recurse | ForEach-Object {
    if($video.Contains($($_.Extension)))
    {
        Move-Item -Path "$($_.FullName)" -Destination "$HOME\videos"
    }
    ElseIf ($image.Contains($($_.Extension)))
    {
        Move-Item -Path "$($_.FullName)" -Destination "$HOME\images"
    }
    ElseIf ($document.Contains($($_.Extension)))
    {
        Move-Item -Path "$($_.FullName)" -Destination "$HOME\documents"
    }
    Else 
    {
        Move-Item -Path "$($_.FullName)" -Destination "$HOME\miscellaneous"
    }
}