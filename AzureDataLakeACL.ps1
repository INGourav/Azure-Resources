<#
Author : - Gourav Kumar
Reach me : - gouravin@outlook.com
Draft One submitted by : - Ankit Kotnala
Vesrion : - 2.0.2

---Version 2.0.2 update---
If you have user principal name handy with you and do not know how to fetch guid for the user then use below trick,
replace -guid flag with -userprincipal and give the id of the user (like, gourav@azuretest.com) that exists in Azure,
Example run : -
To add access,
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -userorgroup <user|group> -userprincipal 'userid' -permission rw-

To remove access,
.\AzureDataLakeACL.ps1 -datalakestr 'datalake storage account' -datalakestrkey 'datalake storage account key' -datalakecontainer 'container name' -userorgroup <user|group> -userprincipal 'userid' -permission rw- -mode remove
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

    [parameter (Mandatory = $false, ValueFromPipeLine = $True, HelpMessage = "Provide the GUID or user or a group for access")]
    [Alias('User or Group GUID')]
    [string]$guid = $null,

    [parameter (Mandatory = $false, ValueFromPipeLine = $True, HelpMessage = "Provide the User principal name of user e.g: - gourav@testazure.com")]
    [Alias('User or Group GUID')]
    [ValidateNotNullOrEmpty()]
    [string]$userprincipal,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the level of permission")]
    [Alias('r--, -w-, rw-, --x')]
    [ValidateNotNullOrEmpty()]
    [string]$permission

)

# Checking if user has given guid or userid to grant the permission and performing the task accordingly
if ($null -eq $guid) {

    $guid = (Get-AzADUser | Where-Object { $_.UserPrincipalName -eq $userprincipal }).Id
}
else {
    $guid = $guid
}

# setting azure datalake storage account context
$adsc = New-AzStorageContext -StorageAccountName $datalakestr -StorageAccountKey $datalakestrkey

# running the loops if user want to add the permission on given datalake storage
if ($mode -eq "add") {

    # loop will run if we want to add user under default permission
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

        # loop will run if we want to add user under access permission        
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

    # running the loops if user want to omit the permission on given datalake storage    
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