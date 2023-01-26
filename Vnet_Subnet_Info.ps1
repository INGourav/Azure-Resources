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


############################### Script to print value of console #################################

$ErrorActionPreference = "SilentlyContinue"
$subscriptions = Get-AzSubscription | select -ExpandProperty SubscriptionId
foreach ($subscription in $subscriptions) {
    Set-Azcontext -SubscriptionId $subscription
    $vnets = Get-AzVirtualNetwork
 foreach ($vnet in $vnets) {
    $subnets = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet
    foreach ($subnet in $subnets) {
        $snet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnet.Name
        $vnetname = $vnet.Name
        $vnetrange = $vnet.AddressSpace.AddressPrefixes
        $subnetName = $snet.Name
        $subnetaddress = $snet.AddressPrefix
        $subnetnsgid = $snet.NetworkSecurityGroup.Id
        $subnetnsg = $subnetnsgid.Split("/")[-1]
        $subnetrouteid = $subnet.RouteTable.id
        $subnetroute = $subnetrouteid.Split("/")[-1]
        $subnetendpoint = $subnet.ServiceEndpoints.Service
        $subnetendpointlocation = $subnet.ServiceEndpoints.Locations

        $subnetconfig = New-Object psobject
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subscription ID" -Value $subscription
        $subnetconfig | Add-Member -MemberType NoteProperty -name "VNet Name" -Value $vnetname
        $subnetconfig | Add-Member -MemberType NoteProperty -name "VNet Range" -Value  $vnetrange
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet Name" -Value $subnetName
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet Address" -Value $subnetaddress
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet NSG" -Value $subnetnsg
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet Route" -Value $subnetroute
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet Endpoint" -Value $subnetendpoint
        $subnetconfig | Add-Member -MemberType NoteProperty -name "Subnet Endpoint Location" -Value $subnetendpointlocation
        $subnetconfig
        $subnetnsg = $null; $subnetroute = $null; $subnetendpoint = $null; $subnetendpointlocation = $null
    }
  }
}
