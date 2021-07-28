<#
Script of export inforamtion about KeyVault and its connected VNET
Author : - Gourav Kumar
Reach Me : - gouravin@outlook.com
Version : - 1.0.0 
#>

$keyvaults = Get-AzKeyVault |Select-Object -ExpandProperty "VaultName"
foreach ($keyvault in $keyvaults)
{
$vault = Get-AzKeyVault -VaultName $keyvault
$Acls = $vault.NetworkAcls.VirtualNetworkResourceIds
if ($null -ne $Acls) {
    $vaultinfo = New-Object psobject
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault Name" -Value $keyvault
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault ResourceGroup" -Value $vault.ResourceGroupName
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "VNET" -Value $Acls.split('/')[-3]
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "VNET ResourceGroup" -Value $Acls.split('/')[4]
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Subnet" -Value $Acls.split('/')[-1]
    $vaultinfo | Format-List
} else {
    $vaultinfo = New-Object psobject
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault Name" -Value $keyvault
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault ResourceGroup" -Value $vault.ResourceGroupName
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "VNET" -Value "No VNeT Attached"
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "VNET ResourceGroup" -Value "N/A"
    $vaultinfo | Add-Member -MemberType NoteProperty -Name "Subnet" -Value "No VNeT Attached"
    $vaultinfo | Format-List
}
}