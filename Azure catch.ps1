# To check available IP in define VNET
Get-AzVirtualNetwork -Name "testnetwork" -ResourceGroupName "drtestwvdcac" | Test-AzPrivateIPAddressAvailability -IPAddress "10.0.0.4"

# To Check valid API version
(Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute").resourceTypes
# Use for one prticular resource
(Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute").resourceTypes | Where-Object ResourceTypeName -eq "virtualMachines"

# To Export tags of any Azure resource
Get-AzVirtualNetwork -Name "testnetwork" -ResourceGroupName "drtestwvdcac" | Select-Object ResourceGroupName,  @{Name='Tags';Expression={ foreach ($key in $_.Tag.Keys ) { $Key + "=" + $_.Tag[$key] + -join";"}}}

# Static NIC IP
$NIC = Get-AzNetworkInterface -ResourceGroupName "ad-vm-rg" -Name "advm-01-nic"
$NIC.IpConfigurations[0].PrivateIpAllocationMethod = 'Static'
Set-AzNetworkInterface -NetworkInterface $NIC

# Acquire Azure access token with powershell
https://azurebuild.wordpress.com/2020/09/11/acquire-azure-access-token-with-powershell/

function Get-AccessTokenByUserLogin {
    $context = Get-AzContext
    $profile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    $profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($profile)
    $token = $profileClient.AcquireAccessToken($context.Subscription.TenantId)
    return $token.AccessToken
}

Example for calling Azure REST API to list Azure Web Apps

function Get-AccessToken {
    $context = Get-AzContext
    $profile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    $profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($profile)
    $token = $profileClient.AcquireAccessToken($context.Subscription.TenantId)
    return $token.AccessToken
}
$subscriptionid = "67d6179d-a99d-4ccd-8c56-4d3ff2e13349"
$rg_name = "off-rg"
$rm_endpoint = "https://management.azure.com"
$authHeader = @{
    'Content-Type'  = 'application/json'
    'Authorization' = 'Bearer ' + (Get-AccessToken)
}
 
$uri = https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$WebApp_RG/providers/Microsoft.Web/sites?api-version=2019-08-01"
 
$respone = Invoke-RestMethod -Method Get -Headers $authHeader -Uri $uri
$response

