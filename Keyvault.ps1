$keyvaults= Get-AzKeyVault |Select-Object -ExpandProperty "VaultName"
foreach ($keyvault in $keyvaults)
{
$vault = Get-AzKeyVault -VaultName $keyvault
$Acls = $vault.NetworkAcls.VirtualNetworkResourceIds
$vaultinfo = New-Object psobject
$vaultinfo | Add-Member -MemberType NoteProperty -Name "Vault Name" -Value $keyvault
$vaultinfo | Add-Member -MemberType NoteProperty -Name "VNET ID" -Value $Acls
$vaultinfo
}