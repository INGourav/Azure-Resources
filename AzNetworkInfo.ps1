<#
About the script: This script can export informational spreadsheet about the Virtual Network those are under same AD tenant in different subscriptions.
Version : 2.0.0
Author : Gourav Kumar
Reach me : https://github.com/INGourav  , https://www.linkedin.com/in/gouravrathore/
Feel free to fork, use, and send feedback :)
#>

$ErrorActionPreference = "SilentlyContinue"
$subscriptions = Get-AzSubscription | select -ExpandProperty SubscriptionId
foreach ($subscription in $subscriptions) {
    Set-Azcontext -SubscriptionId $subscription
    $vnets = Get-AzVirtualNetwork
    foreach ($vnet in $vnets) {
       $subnets = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet
       $PeerVnet = $vnet | Select-Object @{n = "VnetName"; e = { foreach($id in $vnet.VirtualNetworkPeerings.RemoteVirtualNetwork.Id){$n += @($id.Split("/")[-1] -join ': ')} ; (-split $n) -join "; " } }
    foreach ($subnet in $subnets) {
        $vnetrange = $vnet.AddressSpace.AddressPrefixes
        $subnetnsgid = $subnet.NetworkSecurityGroup.Id
        $subnetnsg = $subnetnsgid.Split("/")[-1]
        $subnetrouteid = $subnet.RouteTable.id
        $subnetroute = $subnetrouteid.Split("/")[-1]
        $subnetendpoint = $subnet.ServiceEndpoints.Service
        $subnetendpointlocation = $subnet.ServiceEndpoints.Locations
        $subnetMask = $subnet.AddressPrefix.Split("/")[1]
        $netmaskLength = [Math]::Pow(2, 32 - [int]$subnetMask)
        $availableIpAddresses = $netmaskLength - 5 - $subnet.IpConfigurations.Count
        Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnet.Name `
        | Select-Object @{n = "Subscription Id"; e = { $subscription -join " , " } }, `
        @{n = "VNet Name"; e = { $vnet.Name -join " , " } }, `
        @{n = "VNet Range"; e = { $vnet.AddressSpace.AddressPrefixes -join " , " } }, `
        @{n = "Subnet Name"; e = { $subnet.Name -join " , " } }, `
        @{n = "Subnet Address"; e = { $_.AddressPrefix -join " , " } }, `
        @{n = "Subnet NSG"; e = { $subnetnsg -join " , " } }, `
        @{n = "Subnet Route Name"; e = { $subnetroute -join " , " } }, `
        @{n = "Subnet Endpoints"; e = { $subnet.ServiceEndpoints.Service -join " , " } }, `
        @{n = "Subnet Endpoints Locations"; e = { $subnetendpointlocation -join " , " } }, `
        @{n = "Peering Name"; e = { ($vnet.VirtualNetworkPeerings.Name -join " , " )} }, `
        @{n = "Peer VNetName"; e = { $PeerVnet.VnetName } }, `
        @{n = "Peering State"; e = { $vnet.VirtualNetworkPeerings.PeeringState -join " , " } }, `
        @{n = "Peer VNetAddress"; e = { ($vnet.VirtualNetworkPeerings.RemoteVirtualNetworkAddressSpace.AddressPrefixes -join " , " )} }, `
        @{n = "Available IPs"; e = {$availableIpAddresses}} `
        | Export-Csv C:\Temp\SubnetInfo.csv -Append -NoTypeInformation
        $subnetnsg = $null; $subnetroute = $null; $subnetendpoint = $null; $subnetendpointlocation = $null
    }
  }
}
