#using this script we can export Azure load balancers public Ips for multiple subscriptions under same AD tenant
#V1.0
#Author:- Gourav Kumar
#Reach Me: - gouravrathore23@gmail.com or gouravin@outlook.com
#login Azure subscription using your credentials
Login-AzureRmAccount
#$subs is feching all the subscriptions that you have in same tenant
$subs=Get-AzureRmSubscription | Select-Object -ExpandProperty Name
#But if you want this script to be execute for particular subscription then comment the above line and uncomment the below line. Also change the sunscription name inplace of TechNet
#$subs=Get-AzureRmSubscription | where{$_.Name -eq "TechNet"} | Select-Object -ExpandProperty Name
foreach($sub in $subs)
{
Set-Azurermcontext -Subscription $sub
Get-AzureRmPublicIpAddress | Where-Object{$_.DnsSettings.Fqdn -like "*" -and $_.IpConfiguration.Id -like "*LoadBalancerFrontEnd*"} | Select-Object @{N='Subscription Name';E={$sub}}, ResourceGroupName, Name, Location, PublicIpAllocationMethod, PublicIpAddressVersion, IpAddress, IdleTimeoutInMinutes, ProvisioningState | Export-Csv C:\Temp\Az_loadbalancerpublicIp.csv -Append -NoTypeInformation
}
