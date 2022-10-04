$subs = Get-Azsubscription | Select-Object-Object -ExpandProperty Name
foreach ($sub in $subs) {
    Set-Azcontext -subscription $sub
    Get-AzNetworkInterface | Where-Object { $_.VirtualMachine -eq $null } | Select-Object @{N = 'Subscriotion'; E = { $sub } }, ResourceGroupName, Name, Location, ProvisioningState | Export-csv C:\Temp\Or_res_0811\orphannic.csv -append -notypeinformation
}



#############################################################


$subs = Get-Azsubscription | Select-Object-Object -ExpandProperty Name
foreach ($sub in $subs) {
    Set-Azcontext -subscription $sub
    Get-AzPublicIpAddress | Where-Object { $_.IpAddress -eq 'Not Assigned' } | Select-Object @{N = 'Subscriotion'; E = { $sub } }, ResourceGroupName, Name, Location, ProvisioningState | Export-csv C:\Temp\Or_res_0811\orphanpip.csv -append -notypeinformation
}



#############################################################-


$subs = Get-Azsubscription | Select-Object-Object -ExpandProperty Name
foreach ($sub in $subs) {
    Set-Azcontext -subscription $sub
    Get-AzDisk | Where-Object { $_.ManagedBy -eq $null } | Select-Object @{N = 'Subscriotion'; E = { $sub } }, ResourceGroupName, Name, Location, ProvisioningState | Export-csv C:\Temp\Or_res_0811\orphanunmanageddisk.csv -append -notypeinformation
}


#############################################################-


$RGS = Get-AzResourceGroup | select ResourceGroupName,  @{Name='Tags';Expression={ foreach ($key in $_.Tags.Keys ) { $Key + "=" + $_.Tags[$key] } } }
foreach ($RG in $RGS) {
 if ($null -eq $RG.Tags) {

    Write-Host 'This RG do not have any tags' $RG.ResourceGroupName
 }
  elseif ($RG.Tags -notcontains 'owner' -or $RG.Tags -notcontains 'Expiry Date')
 {
    Write-Host 'This RG either do not have any owner and expiry date tags' $RG.ResourceGroupName
 }
}

#############################################################-

Get-AzResource | select ResourceName,  ResourceType, ResourceGroupName, @{Name='Tags';Expression={ foreach ($key in $_.Tags.Keys ) { $Key + "=" + $_.Tags[$key] } } 
} | Export-Csv C:\temp\OrphanResources.csv -Append -NoTypeInformation -Verbose
