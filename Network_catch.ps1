
Get-AzVirtualNetwork -Name "Vnet01" -ResourceGroupName "RG01" | Test-AzPrivateIPAddressAvailability -IPAddress "10.0.1.2"

Test-AzPrivateIPAddressAvailability -VirtualNetwork "Vnet01" -IPAddress "10.0.1.2"