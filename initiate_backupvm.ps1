<#
This script has two parts 
First one is to enable backup on Azure VM
And the second one to initiate Backup on the VM
Author: - Gourav Kumar
Reach Me: - gouravin@outlook.com
Feel free to edit and share review
#>

$vaultname = "rsv name"
$backuppolicyname = "backup policy name"
$vm = "virtual machine name on which we need to enable backup"
$vmrg = "virtual machine rg"

#stroing vault name in variable
$vault= Get-AzRecoveryServicesVault | Where-Object{$_.Name -eq $vaultname} | Select-Object -ExpandProperty Name

#List Azure recovery valult and set backup redundency locally, I am taking locally in this script
Get-AzRecoveryServicesVault -Name $vault | Set-AzRecoveryServicesBackupProperties -BackupStorageRedundancy LocallyRedundant

#List Azure recovery valult and set backup redundency Geo, if you taking this option then comment the above line and uncomment the below line
#Get-AzRecoveryServicesVault -Name $vault | Set-AzRecoveryServicesBackupProperties -BackupStorageRedundancy GeoRedundant

#Now setting vault to for further use
Set-AzRecoveryServicesVaultContext -Vault $vault

#Get-AzRecoveryServicesVault -Name "vaultname" | Set-AzRecoveryServicesVaultContext

#Storing policy inside the vaiable for further use
$policy= Get-AzRecoveryServicesBackupProtectionPolicy -Name $backuppolicyname

#Last step to enable backup on VM
Enable-AzRecoveryServicesBackupProtection -ResourceGroupName $vmrg -Name $vm -Policy $policy




####Now time to initate backup job on servers########


#storing VM data into Variables if you have number of VMs in different RGs then copy names in CSV and use get content to pasre data
$vm=Get-Content -Path C:\Users\kumar_g\Desktop\Azvmbackup.csv

#However if you have single VM we could use below line. Simply uncomment the below one and Comment the above line in Script.
#$vm= Get-AzVM -ResourceGroupName "VM_RG_Name" -Name "VM Name"

#running script for each VMs
foreach($v in $vm)
{
#Telling script to use Azure VM container for $v VMs
$backupcontainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -FriendlyName $v

#Getting ready and Creating backup
$item = Get-AzRecoveryServicesBackupItem -Container $backupcontainer -WorkloadType "AzureVM"

#Displaying VM and their status about Backup
Backup-AzRecoveryServicesBackupItem -Item $item
}

