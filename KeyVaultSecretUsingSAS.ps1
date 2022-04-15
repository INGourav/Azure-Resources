[CmdletBinding()]

Param(
    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the Key Vault Name to export certificate")]
    [Alias('KeyVaultName')]
    [ValidateNotNullOrEmpty()]
    [string]$keyvault,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the ResourceGroup name")]
    [Alias('RG of Storage account')]
    [ValidateNotNullOrEmpty()]
    [string]$rg,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the storageaccount name")]
    [Alias('storageaccount name')]
    [ValidateNotNullOrEmpty()]
    [string]$storageaccount,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the secret name")]
    [Alias('secret name')]
    [ValidateNotNullOrEmpty()]
    [string]$secretname,

    [parameter (Mandatory= $True, ValueFromPipeline = $True, HelpMessage = "Provide Subcscription name to set contect")]
    [Alias('Azure subscription name')]
    [ValidateNotNullOrEmpty()]
    [string]$azsub

)
Set-AzContext -Subscription $azsub
$context = (Get-AzStorageAccount -ResourceGroupName $rg -Name $storageaccount).Context
$sas = New-AzStorageAccountSASToken -Context $context -Service Blob,File,Table,Queue -ResourceType Service,Container,Object -Permission racwdlup
$Secret = ConvertTo-SecureString -String $sas -AsPlainText -Force
$Expires = (Get-Date).AddYears(2).ToUniversalTime()
$NBF =(Get-Date).ToUniversalTime()
$Tags = @{ "Created By" = "Gourav"; "CostCenter" = "23"}
$ContentType = "txt" # optional
Set-AzKeyVaultSecret -VaultName $keyvault -Name $secretname -SecretValue $Secret -Expires $Expires -NotBefore $NBF -ContentType $ContentType -Tags $Tags  # we we want to disable the secret while creation use -Disable flag