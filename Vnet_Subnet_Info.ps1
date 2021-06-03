$ErrorActionPreference = "SilentlyContinue"
$vnets = Get-AzVirtualNetwork
foreach ($vnet in $vnets) {
    $subnets = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet
    foreach ($subnet in $subnets) {
        $vnetrange = $vnet.AddressSpace.AddressPrefixes
        $subnetnsgid = $subnet.NetworkSecurityGroup.Id
        $subnetnsg = $subnetnsgid.Split("/")[-1]
        $subnetrouteid = $subnet.RouteTable.id
        $subnetroute = $subnetrouteid.Split("/")[-1]
        $subnetendpoint = $subnet.ServiceEndpoints.Service
        $subnetendpointlocation = $subnet.ServiceEndpoints.Locations
        Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnet.Name | Select-Object @{n="VNet Name";e={$vnet.Name -join ","}}, @{n="VNet Range";e={$vnetrange -join ","}}, @{n="Subnet Name";e={$subnet.Name -join ","}}, @{n="Subnet Address";e={$_.AddressPrefix -join ","}}, @{n="Subnet NSG";e={$subnetnsg -join ","}}, @{n="Subnet Route Name";e={$subnetroute -join ","}}, @{n="Subnet Endpoints";e={$subnetendpoint -join ","}}, @{n="Subnet Endpoints Locations";e={$subnetendpointlocation -join "; "}} | Export-Csv C:\Temp\SubnetInfo.csv -Append -NoTypeInformation
        $subnetnsg = $null; $subnetroute = $null; $subnetendpoint = $null; $subnetendpointlocation = $null
    }
}