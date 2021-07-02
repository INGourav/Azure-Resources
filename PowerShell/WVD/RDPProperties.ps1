# View the current RDP Settings
Get-AzWvdHostPool -ResourceGroupName <WVD_ResourceGroup> -Name <WVD_HostPool> | Format-list Name, CustomRdpProperty

# Remove existing settings
Update-AzWvdHostPool -ResourceGroupName <WVD_ResourceGroup> -Name <WVD_HostPool> -CustomRdpProperty ""  

# Add an RDP Property
Update-AzWvdHostPool -ResourceGroupName <WVD_ResourceGroup> -Name <WVD_HostPool> -CustomRdpProperty redirectclipboard:i:0
Update-AzWvdHostPool -ResourceGroupName <WVD_ResourceGroup> -Name <WVD_HostPool> -CustomRdpProperty redirectprinters:i:0

# Add multiple RDP Properties
$properties = “redirectclipboard:i:0;redirectprinters:i:0;drivestoredirect:s:”
Update-AzWvdHostPool -ResourceGroupName <WVD_ResourceGroup> -Name <WVD_HostPool> -CustomRdpProperty $properties
