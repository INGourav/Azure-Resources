$subs = Get-Azurermsubscription | Select-Object-Object -ExpandProperty Name
foreach ($sub in $subs) {
    Set-Azurermcontext -subscription $sub
    Get-AzureRmNetworkInterface | Where-Object { $_.VirtualMachine -eq $null } | Select-Object @{N = 'Subscriotion'; E = { $sub } }, ResourceGroupName, Name, Location, ProvisioningState | Export-csv C:\Temp\Or_res_0811\orphannic.csv -append -notypeinformation
}



#############################################################


$subs = Get-Azurermsubscription | Select-Object-Object -ExpandProperty Name
foreach ($sub in $subs) {
    Set-Azurermcontext -subscription $sub
    Get-AzureRmPublicIpAddress | Where-Object { $_.IpAddress -eq 'Not Assigned' } | Select-Object @{N = 'Subscriotion'; E = { $sub } }, ResourceGroupName, Name, Location, ProvisioningState | Export-csv C:\Temp\Or_res_0811\orphanpip.csv -append -notypeinformation
}



#############################################################-


$subs = Get-Azurermsubscription | Select-Object-Object -ExpandProperty Name
foreach ($sub in $subs) {
    Set-Azurermcontext -subscription $sub
    Get-AzureRmDisk | Where-Object { $_.ManagedBy -eq $null } | Select-Object @{N = 'Subscriotion'; E = { $sub } }, ResourceGroupName, Name, Location, ProvisioningState | Export-csv C:\Temp\Or_res_0811\orphanunmanageddisk.csv -append -notypeinformation
}
