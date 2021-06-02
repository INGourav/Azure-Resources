$vnets = Get-AzVirtualNetwork
foreach ($vnet in $vnets) {
    $subnets = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet
    foreach ($subnet in $subnets) {
        $vnetrange = $vnet.AddressSpace.AddressPrefixes
        $subnetnsgid = $subnet.NetworkSecurityGroup.Id
        $subnetnsg = $subnetnsgid.Split("/")[-1]
        Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnet.Name | Select-Object @{n="Vnet Name";e={$vnet.Name -join ","}}, @{n="Vnet Range";e={$vnetrange -join ","}}, @{n="Subnet Name";e={$subnet.Name -join ","}}, @{n="Subnet Address";e={$_.AddressPrefix -join ","}}, @{n="Subnet NSG";e={$subnetnsg -join ","}} | Export-Csv C:\Temp\VnetInfo.csv -Append -NoTypeInformation
        $subnetnsg = $null
    }
}