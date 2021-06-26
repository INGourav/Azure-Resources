# To check available IP in define VNET
Get-AzVirtualNetwork -Name "testnetwork" -ResourceGroupName "drtestwvdcac" | Test-AzPrivateIPAddressAvailability -IPAddress "10.0.0.4"

# To Check valid API version
(Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute").resourceTypes
# Use for one prticular resource
(Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute").resourceTypes | Where-Object ResourceTypeName -eq "virtualMachines"

# To Export tags of any Azure resource
Get-AzVirtualNetwork -Name "testnetwork" -ResourceGroupName "drtestwvdcac" | Select-Object ResourceGroupName,  @{Name='Tags';Expression={ foreach ($key in $_.Tag.Keys ) { $Key + "=" + $_.Tag[$key] + -join";"}}}

# Static NIC IP
$NIC = Get-AzNetworkInterface -ResourceGroupName "ad-vm-rg" -Name "advm-01-nic"
$NIC.IpConfigurations[0].PrivateIpAllocationMethod = 'Static'
Set-AzNetworkInterface -NetworkInterface $NIC
