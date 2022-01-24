#.(FTP CREATION)

# 1. Installing Windows Feature
Install-WindowsFeature Web-FTP-Server -IncludeAllSubFeature
Install-WindowsFeature Web-Server -IncludeAllSubFeature -IncludeManagementTools



# 2. Creating FTP Site'
$RootDir = "C:\FTPMLM"
New-Item -ItemType Directory $RootDir

$FTPSiteName = "MLM Common Files"
New-WebFtpSite -Name $FTPSiteName -Port 21 -PhysicalPath $RootDir


# 3. Creating the local Windows group
$FTPUserGroupName = "FTP Users"
if (!(Get-LocalGroup $FTPUserGroupName  -ErrorAction SilentlyContinue)) 
{ 
    New-LocalGroup -Name $FTPUserGroupName
}


# 4. Creating an FTP user
$FTPUserName = "User 1"
$FTPPassword = ConvertTo-SecureString "Password@123" -AsPlainText -Force
if (!(Get-LocalUser $FTPUserName -ErrorAction SilentlyContinue)) 
{
    New-LocalUser -Name $FTPUserName -Password $FTPPassword 
}


# 5. Adding the users into the group
Add-LocalGroupMember -Name $FTPUserGroupName -Member $FTPUserName


# 6. Basic Authentication setting on the Site
$FTPSitePath = "IIS:\Sites\$FTPSiteName"
$BasicAuth = 'ftpServer.security.authentication.basicAuthentication.enabled'
Set-ItemProperty -Path $FTPSitePath -Name $BasicAuth -Value $True


# 7. Authorization Rule for Users on the FTP Site
$Param = @{
    Filter   = "/system.ftpServer/security/authorization"
    Value    = @{
        accessType  = "Allow"
        roles       = "$FTPUserGroupName"
        permissions = 1
    }
    PSPath   = 'IIS:\'
    Location = $FTPSiteName
}
Add-WebConfiguration @param


# 8. SSL policy change for control and data connection path
'ftpServer.security.ssl.controlChannelPolicy', 'ftpServer.security.ssl.dataChannelPolicy' |
ForEach-Object {
          Set-ItemProperty -Path $FTPSitePath -Name $_ -Value $false
}


# 9. NTFS Permission though ACL for Users for files in the Root Directory (Locally)
$ACLObject = Get-Acl -Path $RootDir
$ACLObject.SetAccessRule(
   ( # Access rule object
      New-Object System.Security.AccessControl.FileSystemAccessRule(
          $FTPUserGroupName,
          'ReadAndExecute',
          'ContainerInherit,ObjectInherit',
          'None',
          'Allow'
      )
   )
)

Set-Acl -Path $RootDir -AclObject $ACLObject


# 10. Restarting the Web FTP Server
Restart-WebItem "$FTPSitePath"


# 11. Testing the FTP Connection
Test-NetConnection -ComputerName localhost -Port 21
ftp localhost

