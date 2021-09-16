<#
Author : - Gourav Kumar
Draft One submitted by : - Ankit Kotnala

How to run for access on container
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -userorgroup <user|group> -guid 'guid for user'

How to run for access on directory
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -datalakecontainerdir 'directory name' -userorgroup <user|group> -guid 'guid for user'

#>

Param(
[parameter (Mandatory=$True, ValueFromPipeLine=$True, HelpMessage= "Provide the Datalake storage account name")]
[Alias('DataLake')]
[ValidateNotNullOrEmpty()]
[string]$datalakestr,

[parameter (Mandatory=$True, ValueFromPipeLine=$True, HelpMessage= "Provide the Datalake storage account key")]
[Alias('DataLake Key')]
[ValidateNotNullOrEmpty()]
[string]$datalakestrkey,

[parameter (Mandatory=$True, ValueFromPipeLine=$True, HelpMessage= "Provide the Datalake storage container")]
[Alias('DataLake Container')]
[ValidateNotNullOrEmpty()]
[string]$datalakecontainer,

[parameter (Mandatory=$false, ValueFromPipeLine=$True, HelpMessage= "Provide the Datalake storage container directory")]
[Alias('DataLake Container Directory Name')]
[string]$datalakecontainerdir,

[parameter (Mandatory=$True, ValueFromPipeLine=$True, HelpMessage= "Provide the entity name either user or group, by default it is user")]
[Alias('Want to run for User or Group')]
[ValidateNotNullOrEmpty()]
[string]$userorgroup = "User",

[parameter (Mandatory=$True, ValueFromPipeLine=$True, HelpMessage= "Provide the GUID or user or a group for access")]
[Alias('User or Group GUID')]
[ValidateNotNullOrEmpty()]
[string]$guid

)

$adsc = New-AzStorageContext -StorageAccountName $datalakestr -StorageAccountKey $datalakestrkey
$datalakecontainerdir = $file
if ($null -eq $file) {

    $filesystemName = $datalakecontainer
    $dirname = $datalakecontainerdir
    $acl = (Get-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer).ACL
    $acl = set-AzDataLakeGen2ItemAclObject -AccessControlType user -EntityID $guid -Permission rw- -InputObject $acl 
    Update-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Acl $acl 
} else {
    $filesystemName = $datalakecontainer
    $dirname = $datalakecontainerdir
    $acl = (Get-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Path $dirname).ACL
    $acl = set-AzDataLakeGen2ItemAclObject -AccessControlType user -EntityID $guid -Permission rw- -InputObject $acl 
    Update-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Path $dirname -Acl $acl
}








#    This block is used to add user under Default permission, will modify this script later or both of these option
#    if ($null -ne $datalakecontainerdir) {

#        $acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType User -EntityId $guid -Permission rw- -DefaultScope
#        Update-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Acl $acl -Verbose
       
#    } else {
#        $acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityId $guid -Permission rw- -DefaultScope
#        Update-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Acl $acl -Path $datalakecontainerdir -Verbose
#    }