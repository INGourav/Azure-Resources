$subs = Get-Azurermsubscription | Select-Object -ExpandProperty Name
foreach($sub in $subs)
{
Set-Azurermcontext -subscription $sub
Get-AzureRmNetworkInterface | Where{$_.VirtualMachine -eq $null} | Select @{N='Subscriotion';E={$sub}}, ResourceGroupName, Name,  Location, ProvisioningState | Export-csv C:\Temp\Or_res_0811\orphannic.csv -append -notypeinformation
}



----------------------------------------------------------------------------------------------------------------------------------------------------


$subs = Get-Azurermsubscription | Select-Object -ExpandProperty Name
foreach($sub in $subs)
{
Set-Azurermcontext -subscription $sub
Get-AzureRmPublicIpAddress | where{$_.IpAddress -eq 'Not Assigned'} | Select @{N='Subscriotion';E={$sub}}, ResourceGroupName, Name,  Location, ProvisioningState | Export-csv C:\Temp\Or_res_0811\orphanpip.csv -append -notypeinformation
}



-----------------------------------------------------------------------------------------------------------------------------------------------------


$subs = Get-Azurermsubscription | Select-Object -ExpandProperty Name
foreach($sub in $subs)
{
Set-Azurermcontext -subscription $sub
Get-AzureRmDisk | Where{$_.ManagedBy -eq $null} | Select @{N='Subscriotion';E={$sub}}, ResourceGroupName, Name,  Location, ProvisioningState | Export-csv C:\Temp\Or_res_0811\orphanunmanageddisk.csv -append -notypeinformation
}
