 $subs= Get-AzureRmSubscription | Select-Object -ExpandProperty Name
 foreach($sub in $subs)
   {
   Set-AzureRmContext -Subscription $sub
      Get-AzureRmPolicyState | where{$_.IsCompliant -ne "True"} | Select @{N='Subscription Name';E={$sub}}, * | Export-Csv C:\temp\Non_Complimant.csv -Append -NoTypeInformation
 }
