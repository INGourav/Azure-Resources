$subs= Get-AzSubscription | Select-Object -ExpandProperty Name
foreach($sub in $subs)
{
Set-Azcontext -subscription $sub
$Gw = Get-AzApplicationGateway
foreach($G in $Gw)
{
$newObj=New-Object -TypeName psobject
$newObj|Add-Member -MemberType NoteProperty -Name "Subscription" -Value $sub
$newObj|Add-Member -MemberType NoteProperty -Name "AppGW Name" -Value $G.Name
$newObj|Add-Member -MemberType NoteProperty -Name "Resource Group" -Value $G.resourcegroupname
$newObj|Add-Member -MemberType NoteProperty -Name "Location" -Value $G.location
$newObj|Add-Member -MemberType NoteProperty -Name "SKU Name" -Value $G.sku.Name
$newObj|Add-Member -MemberType NoteProperty -Name "SKU Tier" -Value $G.sku.Tier
$newObj|Add-Member -MemberType NoteProperty -Name "SKU Capacity" -Value $G.sku.Capacity
$newObj|Export-Csv C:\Temp\"AzureAppGW1"$Day$Month.csv -Append -NoTypeInformation
}
}
