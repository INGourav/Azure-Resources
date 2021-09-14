 ### To Get all the details of non compliance resources ###
 Connect-AzAccount
 
 $non_comp = Get-AzPolicyState -filter "ComplianceState eq 'NonCompliant'" | Select-Object *
 foreach ($noncomp in $non_comp) {
     $resourcename            = $noncomp.ResourceId.Split("/")[-1]
     $resourcetype            = $noncomp.ResourceType.Split("/")[-1]
     $location                = $noncomp.ResourceLocation
     $resourcegroup           = $noncomp.ResourceGroup
     $PolicyAssignmentName    = $noncomp.PolicyAssignmentName 
     $PolicyAssignmentScope   = $noncomp.PolicyAssignmentScope
     $PolicyDefinitionAction  = $noncomp.PolicyDefinitionAction

     $azpolicy = New-Object psobject
     $azpolicy | Add-Member -MemberType NoteProperty -name "ResourceName" -Value $resourcename 
     $azpolicy | Add-Member -MemberType NoteProperty -name "ResourceType" -Value $resourcetype 
     $azpolicy | Add-Member -MemberType NoteProperty -name "ResourceLocation" -Value $location 
     $azpolicy | Add-Member -MemberType NoteProperty -name "ResourceGroup" -Value $resourcegroup 
     $azpolicy | Add-Member -MemberType NoteProperty -name "PolicyAssignmentName" -Value $PolicyAssignmentName
     $azpolicy | Add-Member -MemberType NoteProperty -name "PolicyAssignmentScope" -Value $PolicyAssignmentScope
     $azpolicy | Add-Member -MemberType NoteProperty -name "PolicyDefinitionAction" -Value $PolicyDefinitionAction
     $azpolicy 

 }



##### Use below script for Azure automation account to get the count of resources #####

Disable-AzContextAutosave –Scope Process
$connection = Get-AutomationConnection -Name AzureRunAsConnection
while(!($connectionResult) -and ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult = Connect-AzAccount `
                            -ServicePrincipal `
                            -Tenant $connection.TenantID `
                            -ApplicationId $connection.ApplicationID `
                            -CertificateThumbprint $connection.CertificateThumbprint
    Start-Sleep -Seconds 10
}

$output = Get-AzPolicyState -filter "ComplianceState eq 
'NonCompliant'" -Apply "groupby((ResourceId))"

if (@($output).Count -gt 0) { Write-Output "Non-Compliant Resources" $output.Count }else
 { Write-Output "All Resources Compliant" }





############################# Log Analytics KQL ############################
#       AzureActivity                                                      #
#       | where CategoryValue == "Policy"                                  #
#       | where parse_json(Properties).isComplianceCheck == "False"        #
#       | extend resource_ = tostring(Properties_d.resource)               #
############################################################################