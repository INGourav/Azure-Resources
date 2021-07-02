# Set Personal Host Pool Assignment Type

# Connect to Azure AD
Connect-AzAccount

# Get current connection status
Get-AzContext

# Set host pool variables
$resourceGroup = "ResourceGroupName"
$hostPool = "HostPoolName"
$sessionHost = "SessionHost.Domain.com"
$userUpn = "User2@Domain.com"

# Get the Host Pool settings
Get-AzWvdHostPool -ResourceGroupName $resourceGroup -Name $hostPool | Format-List

# Change Host Pool Assignment Type
Update-AzWvdHostPool -ResourceGroupName $resourceGroup -Name $hostPool -PersonalDesktopAssignmentType  Direct

# View Session Host Assignemtn
Get-AzWvdSessionHost -ResourceGroupName $resourceGroup -HostPoolName $hostPool -Name $sessionHost | Format-List

Update-AzWvdSessionHost -ResourceGroupName $resourceGroup -HostPoolName $hostPool -Name $sessionHost -AssignedUser $userUpn