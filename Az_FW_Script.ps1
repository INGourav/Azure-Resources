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