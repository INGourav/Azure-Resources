<#
Script of export inforamtion about KeyVault and its connected VNET
Author : - Gourav Kumar
Reach Me : - gouravin@outlook.com
Version : - 1.0.1 
#>

$keyvaults = Get-AzKeyVault |Select-Object -ExpandProperty "VaultName"
foreach ($keyvault in $keyvaults)
{
$vault = Get-AzKeyVault -VaultName $keyvault
$Acls = $vault.NetworkAcls.VirtualNetworkResourceIds
if ($null -ne $Acls) {
    $vaultinfo = New-Object psobject
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Subscription ID" -Value $vault.ResourceId.Split('/')[2]
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault Name" -Value $keyvault
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault ResourceGroup" -Value $vault.ResourceGroupName
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault Location" -Value $vault.Location
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault SKU" -Value $vault.Sku
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "EnableForDeployment" -Value $vault.EnabledForDeployment
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "EnableForTemplateDeployment" -Value $vault.EnabledForTemplateDeployment
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "EnableForDiskEncryption" -Value $vault.EnabledForDiskEncryption
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "EnableForRBACAuth" -Value $vault.EnableRbacAuthorization
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Soft Delete" -Value $vault.EnableSoftDelete
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Soft Delete Retention(Days)" -Value $vault.SoftDeleteRetentionInDays
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "VNET" -Value $Acls.split('/')[-3]
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "VNET ResourceGroup" -Value $Acls.split('/')[4]
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Subnet" -Value $Acls.split('/')[-1]
    $vaultinfo | Export-Csv C:\temp\KeyVaultinfo.csv -Append -NoTypeInformation
} else {
    $vaultinfo = New-Object psobject
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Subscription ID" -Value $vault.ResourceId.Split('/')[2]
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault Name" -Value $keyvault
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault ResourceGroup" -Value $vault.ResourceGroupName
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault Location" -Value $vault.Location
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault SKU" -Value $vault.Sku
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "EnableForDeployment" -Value $vault.EnabledForDeployment
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "EnableForTemplateDeployment" -Value $vault.EnabledForTemplateDeployment
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "EnableForDiskEncryption" -Value $vault.EnabledForDiskEncryption
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "EnableForRBACAuth" -Value $vault.EnableRbacAuthorization
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Soft Delete" -Value $vault.EnableSoftDelete
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Soft Delete Retention(Days)" -Value $vault.SoftDeleteRetentionInDays
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "VNET" -Value "No VNeT Attached"
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "VNET ResourceGroup" -Value "N/A"
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Subnet" -Value "No VNeT Attached"
    $vaultinfo | Export-Csv C:\temp\KeyVaultinfo.csv -Append -NoTypeInformation
}
}