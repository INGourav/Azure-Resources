# To check available IP in define VNET
Get-AzVirtualNetwork -Name "testnetwork" -ResourceGroupName "drtestwvdcac" | Test-AzPrivateIPAddressAvailability -IPAddress "10.0.0.4"

# To Check valid API version
(Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute").resourceTypes
# Use for one prticular resource
(Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute").resourceTypes | Where-Object ResourceTypeName -eq "virtualMachines"

# To Export tags of any Azure resource
Get-AzVirtualNetwork -Name "testnetwork" -ResourceGroupName "drtestwvdcac" | Select-Object ResourceGroupName,  @{Name='Tags';Expression={ foreach ($key in $_.Tag.Keys ) { $Key + "=" + $_.Tag[$key] + -join";"}}}