$strname = "datalakestorage"
$strkey = "storageaccountkey"
$filesystemName = "test" #filesystem = container 
$dirname = "abc"  #dirname = folder in container 
$entity = "xxxxx" #guid of user or group
$ctx = New-AzStorageContext -StorageAccountName $strname -StorageAccountKey $strkey
#Get-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName
#$dir = Get-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Path $dirname


$acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType User -EntityId "xxxxxxxxxxxxxxxxxxxxxxxx" -Permission rw-
Update-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName  -Acl $acl -Verbose #-Path $dirname
#(Get-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName).ACL #-Path $dirname
