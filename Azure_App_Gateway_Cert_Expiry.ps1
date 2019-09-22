Login-AzureRmAccount
$style = @"
<style>
h1, h5, th { text-align: center; font-family: Segoe UI; }
table { margin: auto; font-family: Segoe UI; box-shadow: 10px 10px 5px #888; border: thin ridge grey; }
th { background: #0046c3; color: #fff; max-width: 400px; padding: 5px 10px; }
td { font-size: 11px; padding: 5px 20px; color: #000; }
tr { background: #b8d1f3; }
tr:nth-child(even) { background: #dae5f4; }
tr:nth-child(odd) { background: #b8d1f3; }
</style>
"@


$Report = @()
$Certdata = @()

$subs= Get-AzureRmSubscription | Select-Object -ExpandProperty Name

foreach($sub in $subs)
{
Set-Azurermcontext -subscription $sub

$gateways = Get-AzureRmApplicationGateway

    foreach ($appgw in $gateways)
    {
        $CertInfo = "$null"

        $certs=$appgw.SslCertificates
        $span = [TimeSpan]::FromDays(30)
        $today = [DateTime]::Today
        if ($certs)
        {

        foreach ($cert in $certs)
        {
        $certBytes = [Convert]::FromBase64String($cert.PublicCertData)
        $x509=Decode-Certificate $certBytes
        $ans= ($x509.NotAfter - $today) -lt $span
        if ($ans)
        {
       $CertInfo =  [PSCustomObject] @{
                Subscription = $sub
                ResourceGroup = $appgw.ResourceGroupName;
                AppGateway = $appgw.Name;
                CertSubject = $x509.Subject;
                CertThumbprint = $x509.Thumbprint;
                CertExpiration = $x509.NotAfter;
                'Expiring/Expired' = $ans
                }
       }
            }
        $Certdata += $CertInfo
         }
        
    }
     
}
    $Certdata | ConvertTo-Html -Head $style |Out-File c:\temp\certexpiry.htm 
