/* below lines can be used to list the available backup recovery point of a backup item in a recovery services vault
from a start date to an end date. */

$vmName = ""
$vaultName = ""

$vaultId = (Get-AzREcoveryServicesVault -Name $vaultName).ID

$Container = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM -Status Registered -VaultId $vaultId -FriendlyName $vmName

$item = Get-AzRecoveryServicesBackupItem -Container $Container -WorkloadType AzureVM -VaultId $vaultId
$startDate = (Get-Date).AddDays(-27)
$endDate = (Get-Date).AddDays(3)

Get-AzRecoveryServicesBackupRecoveryPoint -Item $item -VaultId $vaultId -StartDate $startDate.ToUniversalTime() -EndDate $endDate.ToUniversalTime()
