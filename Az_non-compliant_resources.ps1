 $subs= Get-AzureRmSubscription | Select-Object -ExpandProperty Name
 foreach($sub in $subs)
   {
   Set-AzureRmContext -Subscription $sub
      Get-AzureRmPolicyState | Where-Object{$_.IsCompliant -ne "True"} | Select-Object @{N='Subscription Name';E={$sub}}, * | Export-Csv C:\temp\Non_Complimant.csv -Append -NoTypeInformation
 }
