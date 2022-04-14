$rg = "pstest"
$storageaccount = "pstests"
$keyvault = "pstestk"
$secretname = "testpssecret"
$context = (Get-AzStorageAccount -ResourceGroupName $rg -Name $storageaccount).Context
$sas = New-AzStorageAccountSASToken -Context $context -Service Blob,File,Table,Queue -ResourceType Service,Container,Object -Permission racwdlup
$Secret = ConvertTo-SecureString -String $sas -AsPlainText -Force
$Expires = (Get-Date).AddYears(2).ToUniversalTime()
$NBF =(Get-Date).ToUniversalTime()
$Tags = @{ "Created By" = "Gourav"; "CostCenter" = "23"}
$ContentType = "txt" # optional
Set-AzKeyVaultSecret -VaultName $keyvault -Name $secretname -SecretValue $Secret -Expires $Expires -NotBefore $NBF -ContentType $ContentType -Tags $Tags  # we we want to disable the secret while creation use -Disable flag