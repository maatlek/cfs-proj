#.(GROUP_USER GPO CREATION)

# 1. Create Group
"Java Group","DotNet Group","Python Group","DB Group" | ForEach-Object -Process { New-LocalGroup -Name $_}


# 2. Create Users
$Password = ConvertTo-SecureString "Password@123" -AsPlainText -Force
$User = "Python User","Java User","DotNet User" | ForEach-Object -Process { `
 New-LocalUser -Name $_ -Password $Password }

# 3. Add Users to the Group
$User | ForEach-Object { Add-LocalGroupMember -Group "DB Group" -Member $_}
Add-LocalGroupMember -Group "Java Group" -Member "Java User"
Add-LocalGroupMember -Group "Python Group" -Member "Python User"
Add-LocalGroupMember -Group "DotNet Group" -Member "DotNet User"

# 4. Software Installation on Remote Computers
Install-PackageProvider chocolateyGet
$Software = "jdk8","python3","dotnet","mysql"
Install-Package -name $Software -force
# or use choco install <package name>


# 5. GPO for Each Groups for different software restrictions
Set-ExecutionPolicy Unrestricted -Scope Process

Import-Module GroupPolicy
Function Set-GPOBlock {
    param(
        [Parameter(Mandatory)]
        [string]$Groupblock,
        [Parameter(Mandatory)]
        [string[]]$swblock
    )
    $keypath = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies"
    New-GPO -Name "Software Restriction for $($GroupBlock)" | Set-GPPermissions -TargetName "$($GroupBlock)" -TargetType Group -PermissionLevel GpoEditDeleteModifySecurity -Replace
    New-Item -Path "HKCU:$($keypath)" -Name "Explorer" -Force 
    New-Item -Path "HKCU:$($keypath)\Explorer" -Name "DisAllowRun" -Force
    Set-GPRegistryValue -Name "Software Restriction for $($GroupBlock)" -Key "HKCU$($keypath)\Explorer" -ValueName "DisAllowRun" -Value 1 -Type DWord
    Set-GPRegistryValue -Name "Software Restriction for $($GroupBlock)" -Key "HKCU$($keypath)\Explorer\DisAllowRun" -ValueName "1" -Value $($swblock) -Type String
}

Set-GPOBlock -Groupblock "DotNet Group" -swblock "jdk8.exe","python3.exe"
Set-GPOBlock -Groupblock "Java Group" -swblock "dotnet.exe","python3.exe"
Set-GPOBlock -Groupblock "Python Group" -swblock "jdk8.exe","dotnet.exe"
