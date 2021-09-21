<#
Author : - Gourav Kumar
Draft One submitted by : - Ankit Kotnala
Vesrion : - 2.0.0

How to run for access on container
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -userorgroup <user|group> -guid 'guid for user' -permission rw-

How to run for access on directory
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -datalakecontainerdir 'directory name' -userorgroup <user|group> -guid 'guid for user' -permission rw-


If we want create Global permission scope we have to add -scope parameter flag while running

How to run for global access on container
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -userorgroup <user|group> -guid 'guid for user' -permission rw- -scope global

How to run for global access on directory
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -datalakecontainerdir 'directory name' -userorgroup <user|group> -guid 'guid for user' -permission rw- -scope global
#>


[CmdletBinding()]
Param(
    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the Datalake storage account name")]
    [Alias('DataLake')]
    [ValidateNotNullOrEmpty()]
    [string]$datalakestr,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the Datalake storage account key")]
    [Alias('DataLake Key')]
    [ValidateNotNullOrEmpty()]
    [string]$datalakestrkey,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the Datalake storage container")]
    [Alias('DataLake Container')]
    [ValidateNotNullOrEmpty()]
    [string]$datalakecontainer,

    [parameter (Mandatory = $false, ValueFromPipeLine = $True, HelpMessage = "Provide the Datalake storage container directory")]
    [Alias('DataLake Container Directory Name')]
    [string]$datalakecontainerdir,

    [parameter (Mandatory = $false, ValueFromPipeLine = $True, HelpMessage = "Provide the level of permission scope either global or access")]
    [Alias('Access or Global permission')]
    [ValidateNotNullOrEmpty()]
    [string]$scope = "access",

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the entity name either user or group, by default it is user")]
    [Alias('Want to run for User or Group')]
    [ValidateNotNullOrEmpty()]
    [string]$userorgroup = "User",

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the GUID or user or a group for access")]
    [Alias('User or Group GUID')]
    [ValidateNotNullOrEmpty()]
    [string]$guid,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the level of permission")]
    [Alias('r--, -w-, rw-, --x')]
    [ValidateNotNullOrEmpty()]
    [string]$permission

)

$adsc = New-AzStorageContext -StorageAccountName $datalakestr -StorageAccountKey $datalakestrkey

if ($scope -eq "global") {

   if ($null -match $datalakecontainerdir) {

       $acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityId $guid -Permission $permission -DefaultScope
       Update-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Acl $acl
       
   } else {
       $acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityId $guid -Permission $permission -DefaultScope
       Update-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Acl $acl -Path $datalakecontainerdir
   }
}
else {

    if ($null -match $datalakecontainerdir) {

        $acl = (Get-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer).ACL
        $acl = set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityID $guid -Permission $permission -InputObject $acl 
        Update-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Acl $acl
    
    }
    else {
    
        $acl = (Get-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Path $datalakecontainerdir).ACL
        $acl = set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityID $guid -Permission $permission -InputObject $acl 
        Update-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Path $datalakecontainerdir -Acl $acl
    
    }
}