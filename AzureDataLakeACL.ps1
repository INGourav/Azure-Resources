<#
Author : - Gourav Kumar
Draft One submitted by : - Ankit Kotnala
How to run,
.\AzureDataLakeACL.ps1 -datalakestr "datalakestr" -datalakestrkey "datalakestrkey" -datalakecontainer "datalakecontainer" -userorgroup "Group" -guid "groupguid"
#>

Param(
[parameter (Mandatory=$True, Position=0, ValueFromPipeLine=$True, HelpMessage= "Provide the Datalake storage account name")]
[Alias('DataLake')]
[ValidateNotNullOrEmpty()]
[string]$datalakestr,

[parameter (Mandatory=$True, Position=1, ValueFromPipeLine=$True, HelpMessage= "Provide the Datalake storage account key")]
[Alias('DataLake Key')]
[ValidateNotNullOrEmpty()]
[string]$datalakestrkey,

[parameter (Mandatory=$True, Position=2, ValueFromPipeLine=$True, HelpMessage= "Provide the Datalake storage container")]
[Alias('DataLake Container')]
[ValidateNotNullOrEmpty()]
[string]$datalakecontainer,

[parameter (Mandatory=$false, Position=3, ValueFromPipeLine=$True, HelpMessage= "Provide the Datalake storage container directory")]
[Alias('DataLake Container Directory Name')]
[string]$datalakecontainerdir,

[parameter (Mandatory=$True, Position=4, ValueFromPipeLine=$True, HelpMessage= "Provide the entity name either user or group, by default it is user")]
[Alias('User or Group GUID')]
[ValidateNotNullOrEmpty()]
[string]$userorgroup = "User",

[parameter (Mandatory=$True, Position=5, ValueFromPipeLine=$True, HelpMessage= "Provide the GUID or user or a group for access")]
[Alias('User or Group GUID')]
[ValidateNotNullOrEmpty()]
[string]$guid

)

$adsc = New-AzStorageContext -StorageAccountName $datalakestr -StorageAccountKey $datalakestrkey

   if ($null -ne $datalakecontainerdir) {
       $acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType $userorgroup -EntityId $guid -Permission rw- `
       Update-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Acl $acl -Path $datalakecontainerdir -Verbose
       
   } else {
       $acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType User -EntityId $guid -Permission rw- `
       Update-AzDataLakeGen2Item -Context $adsc -FileSystem $datalakecontainer -Acl $acl -Verbose
   }
