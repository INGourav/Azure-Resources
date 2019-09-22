<# About this Script
Using this script we could check cert Application Gateway and App Service Certificates that are going to expire in next 30 days
Reference
https://winterdom.com/2017/11/02/decoding-appgateway-ssl-certs
Reach Me : - gouravin@outlook.com or gouravrathore23@gmail.com
#>

#Function to check CertExpiration days 

function Test-CertExpiresSoon($cert) {
    $span = [TimeSpan]::FromDays(30)
    $today = [DateTime]::Today
    return ($cert.NotAfter - $today) -lt $span
}

#Function to decode certificate

function Decode-Certificate($certBytes) {
    $p7b = New-Object System.Security.Cryptography.Pkcs.SignedCms
    $p7b.Decode($certBytes)
    return $p7b.Certificates[0]
}

#Runing for all Subscription under same AD tenant

$subs= Get-AzureRmSubscription | Select-Object -ExpandProperty Name
foreach($sub in $subs)
{
Set-Azurermcontext -subscription $sub

#Cheking all Application Gateway

$gateways = Get-AzureRmApplicationGateway

foreach ($gw in $gateways) {
    foreach ($cert in $gw.SslCertificates) {
        $certBytes = [Convert]::FromBase64String($cert.PublicCertData)
        $x509 = Decode-Certificate $certBytes

        if (Test-CertExpiresSoon $x509) {
            [PSCustomObject] @{
                Subscription = $sub
                ResourceGroup = $gw.ResourceGroupName;
                AppGateway = $gw.Name;
                CertSubject = $x509.Subject;
                CertThumbprint = $x509.Thumbprint;
                CertExpiration = $x509.NotAfter;
} 
  }
    } 
	   }
	
#Now we are checking all Azure App Service Certificates that are going to expire in next 30 days

 $appcerts = Get-AzureRmWebAppCertificate | where{$_.ExpirationDate -lt (Get-date).AddDays(30)}

foreach ($appcert in $appcerts) {
    #$appcertname = $appcert | Select Name
     #$appcertExpiryDate = $appcert | Select ExpirationDate
      #$appcertID =  $appcert | Select ID
     [PSCustomObject] @{
      Subscription = $sub
      AppCertName = $appcert.Name;
      AppCertExpiryDate = $appcert.ExpirationDate;
      AppCertID = $appcert.ID;
                        }
}
 }
