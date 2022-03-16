<# 
Why we need this script,
This export the given certificate from the Azure KeyVault with its key value pair and we can use/import the certificate furrther in apps
Currently this script exports the given one certificate in a single run however I am working on version 2 that can export all certificate in single run

How to run,
.\Azure_Key_Vault_Cert_Export.ps1 -vaultname 'azkeyvault23' -certname 'azkeyvault23cert' -certpwd 'P@s$w0rD' -dir 'C:\temp\'

Version = 1.0.0
#>

Param(
    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the Key Vault Name to export certificate")]
    [Alias('KeyVaultName')]
    [ValidateNotNullOrEmpty()]
    [string]$vaultName,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the certificate name to export")]
    [Alias('Certificate Name')]
    [ValidateNotNullOrEmpty()]
    [string]$certname,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the password for the certificate to use")]
    [Alias('Password for the PFX certificate file')]
    [ValidateNotNullOrEmpty()]
    [string]$certpwd,


    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the location to store the certicate in local machine")]
    [Alias('location we want to store the certicate')]
    [ValidateNotNullOrEmpty()]
    [string]$dir

)

$securecertpwd = ConvertTo-SecureString $certpwd -AsPlainText -Force
$cert = Get-AzKeyVaultCertificate -VaultName $vaultName -Name $certname
$secret = Get-AzKeyVaultSecret -VaultName $vaultName -Name $cert.Name
$secretValueText = '';
$ssptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
try {
    $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssptr)
}
finally {
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssptr)
}
$secretByte = [Convert]::FromBase64String($secretValueText)
$x509Cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2
$x509Cert.Import($secretByte, "", "Exportable,PersistKeySet")
$type = [System.Security.Cryptography.X509Certificates.X509ContentType]::Pfx
$pfxFileByte = $x509Cert.Export($type, $securecertpwd)

# This line will store the file in the system's location
[System.IO.File]::WriteAllBytes($dir + $cert.Name + '.pfx', $pfxFileByte)

# If you directly want to import this on local machine than you can uncomment below lines
# $file = $dir + $cert.Name + '.pfx'
# Import-PfxCertificate -FilePath $file -CertStoreLocation Cert:\CurrentUser\My -Password $securecertpwd