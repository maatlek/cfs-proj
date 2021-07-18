# Creating a Storage Account

$storagename = 'nilsestorage01','nileustorage01'
$shareName = 'sales'


## Creating for SEA Region

$seastrg =  New-AzStorageAccount -ResourceGroupName $RG[0] `
    -Name $storagename[0] `
    -Location $location[0] `
    -SkuName Standard_ZRS `
    -EnableLargeFileShare

$sctx = $seastrg.Context

### Creating a Container

$seacontr = New-AzStorageContainer -Name $storagename[0] -Context $sctx -Permission Container 


### Creating a File Share

New-AzStorageShare -Context $sctx -Name  $shareName


## Creating for EUS Region

$eusstrg = New-AzStorageAccount -ResourceGroupName $RG[1] `
    -Name $storagename[1] `
    -Location $location[1] `
    -SkuName Standard_GRS
    -EnableLargeFileShare

$ectx = $eusstrg.Context

### Creating a Container

$euscontr = New-AzStorageContainer -Name $storagename[1] -Context $ectx -Permission Container 


### Creating a File Share

New-AzStorageShare -Context $ectx -Name  $shareName


## Generating SAS Token for users for created container

$sastokensea = New-AzStorageContainerSASToken -Context $sctx `
    -Name $seacontr`
    -Permission rwdl

$sastokeneus = New-AzStorageContainerSASToken -Context $ectx `
    -Name $euscontr`
    -Permission rwdl

### Sending SAS Token to the User
$From = "admin@protonmail.com"
$To = "vm_admin@protonmail.com”
$Subject = "Azure SAS Key Generation"
$Body = "The SAS Token is $sastokensea for SEA"
$Body += “The SAS Token is $sastokeneus for SEA”
$SMTPServer = "smtp-mail.outlook.com"
$SMTPPort = "587"
Send-MailMessage -From $From -to $To  -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential (Get-Credential) -Attachments $Attachment
