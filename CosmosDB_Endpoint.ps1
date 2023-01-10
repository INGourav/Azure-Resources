# Enable the service endpoint for an existing subnet of a virtual network
$resourceGroupName = "Resource group name"
$vnetName = "Virtual network name"
$subnetName = "Subnet name"
$subnetPrefix = "Subnet address range"
$accountName = "Azure Cosmos DB account name"
$serviceEndpoint = "Microsoft.AzureCosmosDB" # No need to change for cosmosDB

Get-AzVirtualNetwork `
   -ResourceGroupName $resourceGroupName `
   -Name $vnetName | Set-AzVirtualNetworkSubnetConfig `
   -Name $subnetName `
   -AddressPrefix $subnetPrefix `
   -ServiceEndpoint $serviceEndpoint | Set-AzVirtualNetwork

# Get virtual network information
$vnet = Get-AzVirtualNetwork `
   -ResourceGroupName $resourceGroupName `
   -Name $vnetName

$subnetId = $vnet.Id + "/subnets/" + $subnetName

# Prepare an Azure Cosmos DB Virtual Network Rule
$vnetRule = New-AzCosmosDBVirtualNetworkRule `
   -Id $subnetId `
   -IgnoreMissingVNetServiceEndpoint 0  # 1 will ignore missing vnet service point and 0 will not

# Getting Azure Cosmos DB account information
$oldvnetrule = $account.VirtualNetworkRules

# Adding older rules if there are any else it will vanish older ones and add new ones only
$oldvnetrule = $oldvnetrule + $vnetRule

# Update Azure Cosmos DB account properties with the new Virtual Network endpoint configuration
Update-AzCosmosDBAccount `
   -ResourceGroupName $resourceGroupName `
   -Name $accountName `
   -EnableVirtualNetwork $true `
   -VirtualNetworkRuleObject $oldvnetrule # -VirtualNetworkRuleObject @($vnetRule) for array with , 

# Run the following command to verify
$account = Get-AzCosmosDBAccount `
   -ResourceGroupName $resourceGroupName `
   -Name $accountName

$account.IsVirtualNetworkFilterEnabled
$account.VirtualNetworkRules
