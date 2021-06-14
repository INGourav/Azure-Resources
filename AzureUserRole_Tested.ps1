# Author of this script :- Gourav Kumar
# Feel free to use and Edit, no copyrights
# Can reach me at gouravrathore23@gmail.com or gouravin@outlook.com
# Do not forget to share feedback and Rating on it. :)

# Login to Azure Account
#Login-AzureRmAccount

# Prompting the user to select the subscription
Get-AzureRmSubscription | Out-GridView -OutputMode Single -Title "Please select a subscription" | ForEach-Object {$_.SubscriptionName = $PSItem.Name}
Write-Host "You have selected the subscription: $SubscriptionName. Proceeding with fetching the Azure User Role for it. `n" -ForegroundColor yellow

# Setting the selected subscription
Select-AzureRmSubscription -SubscriptionName $SubscriptionName

# Running command to export the user role in CSV with 
Get-AzureRmRoleAssignment | select-object -Property DisplayName, SignInName, RoleDefinitionName, ObjectType, CanDelegate | Export-Csv C:\Temp\$SubscriptionName.csv

Write-Host "Sucessfully exported user role for subscription" $SubscriptionName