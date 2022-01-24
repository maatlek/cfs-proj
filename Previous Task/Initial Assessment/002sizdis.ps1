#.(SIZE DISTRIBUTION)

$bookdir = "$HOME\largebooks","$HOME\minibooks","$HOME\smallbooks"
New-Item -ItemType Directory $bookdir


Get-ChildItem -Path "$HOME\uploads" | ForEach-Object {  `
        if($($_.Length) -gt 10MB)  `
        {   `
            Move-Item -Path "$($_.FullName)" -Destination "$HOME\largebooks" `
        }   `
        ElseIf (($($_.Length) -le 10MB) -or ($($_.Length) -gt 2MB)) `
        { `
            Move-Item -Path "$($_.FullName)" -Destination "$HOME\smallbooks" `
        } `
        ElseIf($($_.Length) -ge 2MB)
        { `
            Move-Item -Path "$($_.FullName)" -Destination "$HOME\minibooks" `
        } `
    }
