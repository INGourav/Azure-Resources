<#
Author : - Gourav Kumar
Draft One submitted by : - Ankit Kotnala
Vesrion : - 2.0.1

------------- addition of access ---------------

How to run to add access on container
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -userorgroup <user|group> -guid 'guid for user' -permission rw-

How to run to add access on directory
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -datalakecontainerdir 'directory name' -userorgroup <user|group> -guid 'guid for user' -permission rw-


If we want create Global permission scope we have to add -scope parameter flag while running

How to run to add global access on container
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -userorgroup <user|group> -guid 'guid for user' -permission rw- -scope global

How to run to add global access on directory
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -datalakecontainerdir 'directory name' -userorgroup <user|group> -guid 'guid for user' -permission rw- -scope global

------------- reamoval of access ---------------

How to run to remove access on container
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -userorgroup <user|group> -guid 'guid for user' -permission rw- -mode remove

How to run to remove access on directory
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -datalakecontainerdir 'directory name' -userorgroup <user|group> -guid 'guid for user' -permission rw- -mode remove


How to run to remove global access on container
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -userorgroup <user|group> -guid 'guid for user' -permission rw- -scope global -mode remove

How to run to remove global access on directory
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -datalakecontainerdir 'directory name' -userorgroup <user|group> -guid 'guid for user' -permission rw- -scope global -mode remove
#>


[CmdletBinding()]
Param(
    [parameter (Mandatory = $false, ValueFromPipeLine = $True, HelpMessage = "Want to add user or remove")]
    [Alias('add or remove')]
    [ValidateNotNullOrEmpty()]
    [string]$mode = "add",

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

if ($mode -eq "add") {

    if ($scope -eq "global") {

        if ($null -match $datalakecontainerdir) {
     
            $acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityId $guid -Permission $permission -DefaultScope
            Update-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Acl $acl
            
        }
        else {
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
} 
else {

    if ($scope -eq "global") {

        if ($null -match $datalakecontainerdir) {
     
            $acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityId $guid -Permission $permission -DefaultScope
            Remove-AzDataLakeGen2AclRecursive -FileSystem $datalakecontainer -Acl $acl -Context $adsc
            
        }
        else {
            $acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityId $guid -Permission $permission -DefaultScope
            Remove-AzDataLakeGen2AclRecursive -FileSystem $datalakecontainer -Path $datalakecontainerdir -Acl $acl -Context $adsc
        }
    }
    else {
     
        if ($null -match $datalakecontainerdir) {
     
            $acl = set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityID $guid -Permission $permission -InputObject $acl 
            Remove-AzDataLakeGen2AclRecursive -FileSystem $datalakecontainer -Acl $acl -Context $adsc
         
        }
        else {
         
            $acl = set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityID $guid -Permission $permission -InputObject $acl 
            Remove-AzDataLakeGen2AclRecursive -FileSystem $datalakecontainer -Path $datalakecontainerdir -Acl $acl -Context $adsc 
         
        }
    }
}