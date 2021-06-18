# Stop an existing firewall
$fwname = "testrgfr01"
$fwrg   = "testrgfr"
$azfw = Get-AzFirewall -Name $fwname -ResourceGroupName $fwrg
$azfw.Deallocate()
Set-AzFirewall -AzureFirewall $azfw




# Start a firewall
$fwname = "testrgfr01"
$fwrg   = "testrgfr"
$fevnet = "testrgfr01-vnet"
$fwpip1 = "testrgfr01-pip"
$fwpip2 = "testrgfr01-pip2"

$azfw = Get-AzFirewall -Name $fwname -ResourceGroupName $fwrg
$vnet = Get-AzVirtualNetwork -ResourceGroupName $fwrg -Name $fevnet
$publicip1 = Get-AzPublicIpAddress -Name $fwpip1 -ResourceGroupName $fwrg
$publicip2 = Get-AzPublicIpAddress -Name $fwpip2 -ResourceGroupName $fwrg
$azfw.Allocate($vnet,@($publicip1,$publicip2))
Set-AzFirewall -AzureFirewall $azfw




# Add a Threat Intelligence allow list to an Existing Azure Firewall

# Create the allow list with both FQDN and IPAddresses
$fw = Get-AzFirewall -Name "Name_of_Firewall" -ResourceGroupName "Name_of_ResourceGroup"
$fw.ThreatIntelWhitelist = New-AzFirewallThreatIntelWhitelist `
   -FQDN @("fqdn1", "fqdn2") -IpAddress @("ip1", "ip2")

# Or Update FQDNs and IpAddresses separately
$fw = Get-AzFirewall -Name $firewallname -ResourceGroupName $RG
$fw.ThreatIntelWhitelist.IpAddresses = @($fw.ThreatIntelWhitelist.IpAddresses + $ipaddresses)
$fw.ThreatIntelWhitelist.fqdns = @($fw.ThreatIntelWhitelist.fqdns + $fqdns)


Set-AzFirewall -AzureFirewall $fw