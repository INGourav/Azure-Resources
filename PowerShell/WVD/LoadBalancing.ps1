# Set Host Pool Load Balancing

# Connect to Azure AD
Connect-AzAccount

# Get current connection status
Get-AzContext

# Set host pool variables
$resourceGroup = "ResourceGroupName"
$hostPool = "HostPoolName"

# Get the Host Pool settings
Get-AzWvdHostPool -ResourceGroupName $resourceGroup -Name $hostPool | Format-List

# Set the Host Pool to Breadth-first
Update-AzWvdHostPool -ResourceGroupName $resourceGroup -Name $hostPool -LoadBalancerType BreadthFirst -MaxSessionLimit 99999
