<#
About the script: This script can apply subnet ranges on Azure CosmosDB account under networking section. So only allowed/whitlisted range could access the same. Helpful to manage traffic control and access destination as well as maintain the compliance.

Version : 2.0.0
Author : Gourav Kumar
Reach me : https://github.com/INGourav  , https://www.linkedin.com/in/gouravrathore/

Feel free to fork, use, and send feedback :)
How to run, example 1 (when we want to whitlist subnet from different subscription, in this case we cannot enable endpoint on subnet so that should be either enabled to will ignore):
.\CosmosDB_Endpoint.ps1 -subscriptionid 'xxxxxx-xxxx-xxx-xxxx' -vnetresourcegroupName 'VNETGR01' -vnetname 'Vnet01' -subnetName 'Subnet01', 'subnet02' -cosmosresourcegroupName 'cosmosrg1' -cosmosdbaccount 'cosmos1' -enableendpoint $False

example 2 (when we want to enable endpoint on subnet and this is in same subscription)
.\CosmosDB_Endpoint.ps1 -vnetresourcegroupName 'VNETGR01' -vnetname 'Vnet01' -subnetName 'Subnet01', 'subnet02' -cosmosresourcegroupName 'cosmosrg1' -cosmosdbaccount 'cosmos1'
#>


Param(
   [parameter (Mandatory=$False, Position=0, ValueFromPipeLine=$True, HelpMessage="Provide the different subscription ID where the subnet exists, only if you want to enable subnet from different subscription that is under the same AD tenant")]
   [Alias('subscriptio ID')]
   [ValidateNotNullOrEmpty()]
   [string]$subscriptionid = $null,
   
   [parameter (Mandatory=$True, Position=1, ValueFromPipeLine=$True, HelpMessage="Virtual Network resource group name")]
   [Alias('VNet RG')]
   [ValidateNotNullOrEmpty()]
   [string]$vnetresourcegroupName,

   [parameter (Mandatory=$True, Position=2, ValueFromPipeLine=$True, HelpMessage="Virtual Network name")]
   [Alias('VNet name')]
   [ValidateNotNullOrEmpty()]
   [string]$vnetname,

   [parameter (Mandatory=$True, Position=3, ValueFromPipeLine=$True, HelpMessage="subnet names")]
   [Alias('Subnet name(s)')]
   [ValidateNotNullOrEmpty()]
   [array]$subnetName,

   [parameter (Mandatory=$True, Position=4, ValueFromPipeLine=$True, HelpMessage="CosmosAccount resource group name")]
   [Alias('Cosmos RG')]
   [ValidateNotNullOrEmpty()]
   [string]$cosmosresourcegroupName,

   [parameter (Mandatory=$True, Position=5, ValueFromPipeLine=$True, HelpMessage="CosmosAccount name")]
   [Alias('Cosmos Name')]
   [ValidateNotNullOrEmpty()]
   [array]$cosmosdbaccount,

   [parameter (Mandatory=$False, Position=6, ValueFromPipeLine=$True, HelpMessage="Whether we want to enable endpoint on subnet or not, bydefault its enabling")]
   [Alias('Cosmos Name either $True or $False')]
   [ValidateNotNullOrEmpty()]
   [Boolean]$enableendpoint = $True
   )

$serviceendpoint = "Microsoft.AzureCosmosDB" # No need to change for cosmosDB
$rules = @() # creating an object var to store all the rules during iteration

if($null -eq $subscriptionid)
{
   $vnet = Get-AzVirtualNetwork `
   -ResourceGroupName $vnetresourcegroupname `
   -Name $vnetname
   if ($true -eq $enableendpoint) {
     foreach ($snet in $subnetname) {
        foreach ($vnetsub in $vnet.Subnets) {
            if ($snet -eq $vnetsub.Name) {
                $address = $vnetsub.AddressPrefix
                $vnet| Set-AzVirtualNetworkSubnetConfig `
                -Name $snet `
                -AddressPrefix $address `
                -ServiceEndpoint $serviceendpoint | Set-AzVirtualNetwork -Verbose
                $subnetId = $vnet.Id + "/subnets/" + $snet
                $vnetRule = New-AzCosmosDBVirtualNetworkRule `
                -Id $subnetId `
                -IgnoreMissingVNetServiceEndpoint 0
                $rules    += $vnetRule
            }       
        }
      }     
    }
   else {
        foreach($snet in $subnetName)
         {
          $subnetId = $vnet.Id + "/subnets/" + $snet
          $vnetRule = New-AzCosmosDBVirtualNetworkRule `
          -Id $subnetId `
          -IgnoreMissingVNetServiceEndpoint 1
          $rules    += $vnetRule
        }
   }
}
else {
    foreach($snet in $subnetName)
      {
        $subnetId = "/subscriptions/"+$subscriptionID+"/resourceGroups/"+$vnetresourceGroupName+"/providers/Microsoft.Network/virtualNetworks/"+$vnetName+"/subnets/"+$snet
        $vnetRule = New-AzCosmosDBVirtualNetworkRule `
        -Id $subnetId ` 
        -IgnoreMissingVNetServiceEndpoint 1
        $rules    += $vnetRule
      }
}
foreach ($account in $cosmosdbaccount) {
   # Getting Azure Cosmos DB account information and already placed rules
   $accountname = Get-AzCosmosDBAccount `
   -ResourceGroupName $cosmosresourceGroupName `
   -Name $account
   $oldvnetrule = $accountname.VirtualNetworkRules
   # Adding older rules if there are any else it will vanish older ones and add new ones only
   $finalrules = $oldvnetrule + $rules
   
   # Update Azure Cosmos DB account properties with the new Virtual Network endpoint configuration
   Update-AzCosmosDBAccount `
   -ResourceGroupName $cosmosresourceGroupName `
   -Name $accountname `
   -EnableVirtualNetwork $true `
   -VirtualNetworkRuleObject @($finalrules)
}
