<# 
Why we need this script,
This export the given certificate from the Azure KeyVault with its key value pair and we can use/import the certificate furrther in apps
In it previous version this script could only exports the given one certificate in a single run
However now in this version this can export all certificate from a single ke vault in single run

How to run,
.\Azure_Key_Vault_Cert_Export.ps1 -vaultname "azkeyvault23" -certname "azkeyvault23cert", "azkeyvault23cert01", "azkeyvault23cert02" -certpwd 'P@s$w0rD' -dir 'C:\temp\'

Version = 2.0.0
#>

Param(
    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the Key Vault Name to export certificate")]
    [Alias('KeyVaultName')]
    [ValidateNotNullOrEmpty()]
    [string]$vaultName,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the certificate name to export")]
    [Alias('Certificate Name(s)')]
    [ValidateNotNullOrEmpty()]
    [string[]]$certname,

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
foreach ($cer in $certname) {
    Write-Host "Checking status for $cer"
    $cerinfo = Get-AzKeyVaultCertificate -VaultName $vaultName -Name $cer
    if ($null -eq $cerinfo) {
        Write-Host "The given certificate $cer does not exist in $vaultname"
    }
    else {
        Write-Output "The given certificate $cer exist in $vaultname, performing further operations for this"
        $secret = Get-AzKeyVaultSecret -VaultName $vaultName -Name $cerinfo.name
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
          [System.IO.File]::WriteAllBytes($dir + $cerinfo.name + '.pfx', $pfxFileByte)
          
          # If you directly want to import this on local machine than you can uncomment below lines
          # $file = $dir + $cerinfo.name + '.pfx'
          # Import-PfxCertificate -FilePath $file -CertStoreLocation Cert:\CurrentUser\My -Password $securecertpwd
    }

}