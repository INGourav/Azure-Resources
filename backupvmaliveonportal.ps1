<#
This Script is wriiten to create or populate report of the VMs. Those are deleted from Azure but still protected by Azure Recovery Vault and backup remains orphan.
This will run against ecery recovery service vault that is there in subscription.
Author : - Gourav Kumar
Reach Me: - gouravin@outlook.com
Version: - 2.0
Date:- 7th October 2021

---Update---
This is updated on New Az module, old one can be found on below link,
https://github.com/INGourav/AzureBackup/blob/master/Backup%20VM%20Alive%20in%20Portal.ps1

Feel free to use, edit, and do share your feedback on this small piece of work.
#>

Begin{
    $Subs = Get-AzSubscription | Select-Object -ExpandProperty Name
      foreach($sub in $Subs)
       {
     Set-AzContext -Subscription $sub
       $RVS = Get-AzRecoveryServicesVault
     foreach($RV in $RVS)
       {
      Set-AzRecoveryServicesVaultContext -Vault $RV
        $RVNAME = $RV | Select-Object -ExpandProperty Name
      $Cont = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM -Status Registered | Select-Object -ExpandProperty FriendlyName
     foreach($con in $Cont)
       {
      $VM = Get-AzVM | Where-Object {$_.Name -eq $con} | Select-Object -ExpandProperty Name
        if($VM)
        {
       #Uncomment Below line if you want to see reult on PowerShell host console
       #Write-Host  $VM ";VM Found in Subscription;" $sub  ";Sitting in;" $RVNAME ";Recovery Vault;"
       $VMINRV = New-Object psobject
       $VMINRV | Add-Member -MemberType NoteProperty -name Subscription -Value $sub
       $VMINRV | Add-Member -MemberType NoteProperty -name Server -Value $VM
       $VMINRV | Add-Member -MemberType NoteProperty -name RecoveryVault -Value $RVNAME
       $VMINRV | Export-Csv C:\Temp\vmfound.csv -Append -NoTypeInformation
       }
     else
        {
       # Uncomment Below line if you want to see reult on PowerShell host console
       #Write-Host  $con ";VM Not Found in Subscription;" $sub ";Sitting in;" $RVNAME ";Recovery Vault;"
       $VMNOTINRV = New-Object psobject
       $VMNOTINRV | Add-Member -MemberType NoteProperty -name Subscription -Value $sub
       $VMNOTINRV | Add-Member -MemberType NoteProperty -name Server -Value $con
       $VMNOTINRV | Add-Member -MemberType NoteProperty -name RecoveryVault -Value $RVNAME
       $VMNOTINRV | Export-Csv C:\Temp\vmnotfound.csv -Append -NoTypeInformation
       }
      }
     }
    }
     }
    End{}