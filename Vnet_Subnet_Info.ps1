$ErrorActionPreference = "SilentlyContinue"
$subscriptions = Get-AzSubscription | select -ExpandProperty SubscriptionId
foreach ($subscription in $subscriptions) {
    Set-Azcontext -SubscriptionId $subscription
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
        Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnet.Name | Select-Object @{n = "SubscriptionId"; e = { $subscription -join "," } }, @{n = "VNet Name"; e = { $vnet.Name -join "," } }, @{n = "VNet Range"; e = { $vnetrange -join "," } }, `
        @{n = "Subnet Name"; e = { $subnet.Name -join "," } }, @{n = "Subnet Address"; e = { $_.AddressPrefix -join "," } }, @{n = "Subnet NSG"; e = { $subnetnsg -join "," } }, @{n = "Subnet Route Name"; e = { $subnetroute -join "," } }, `
        @{n = "Subnet Endpoints"; e = { $subnetendpoint -join "," } }, @{n = "Subnet Endpoints Locations"; e = { $subnetendpointlocation -join "; " } } `
        | Export-Csv C:\Temp\SubnetInfo.csv -Append -NoTypeInformation
        $subnetnsg = $null; $subnetroute = $null; $subnetendpoint = $null; $subnetendpointlocation = $null
    }
 }
}


############################### Script to print/export csv value of console #################################

$ErrorActionPreference = "SilentlyContinue"
$subscriptions = Get-AzSubscription | select -ExpandProperty SubscriptionId
foreach ($subscription in $subscriptions) {
    Set-Azcontext -SubscriptionId $subscription
   $vnets = Get-AzVirtualNetwork
  foreach ($vnet in $vnets) {
    $subnets = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet
    $PeerVnet = $vnet | Select-Object @{n = "VnetName"; e = { foreach($id in $vnet.VirtualNetworkPeerings.RemoteVirtualNetwork.Id){$n += @($id.Split("/")[-1] -join ': ')} ; (-split $n) -join "; " } }
    foreach ($subnet in $subnets) {
        $snet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnet.Name
        $vnetname = $vnet.Name
        $subnetnsgid = $snet.NetworkSecurityGroup.Id
        $subnetnsg = $subnetnsgid.Split("/")[-1]
        $subnetrouteid = $subnet.RouteTable.id
        $subnetroute = $subnetrouteid.Split("/")[-1]
        $subnetconfig = New-Object psobject
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subscription ID" -Value $subscription
        $subnetconfig | Add-Member -MemberType NoteProperty -name "VNet Name" -Value $vnetname
        $subnetconfig | Add-Member -MemberType NoteProperty -name "VNet Range" -Value  ($vnet.AddressSpace.AddressPrefixes -join '; ')
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet Name" -Value $snet.Name
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet Address" -Value ($snet.AddressPrefix -join '; ')
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet NSG" -Value $subnetnsg
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet Route" -Value $subnetroute
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet Endpoint" -Value ($subnet.ServiceEndpoints.Service -join '; ')
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet Endpoint Location" -Value ($subnet.ServiceEndpoints.Locations -join '; ')
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Peering Name" -Value ($vnet.VirtualNetworkPeerings.Name -join '; ')
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Peer VNetName" -Value $PeerVnet.VnetName
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Peering State" -Value ($vnet.VirtualNetworkPeerings.PeeringState -join '; ')
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Peer VNetAddress" -Value ($vnet.VirtualNetworkPeerings.RemoteVirtualNetworkAddressSpace.AddressPrefixes -join '; ')
        $subnetconfig | Export-Csv C:/Temp/NetWorkinfo.CSV -Append -NoTypeInformation
        $subnetconfig
        $subnetnsg = $null; $subnetroute = $null; $subnetendpoint = $null; $subnetendpointlocation = $null
    }
  }
}
