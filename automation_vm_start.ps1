Connect-AzAccount -Identity
# (Get-Date).DayOfWeek
# $vmrg = Get-AutomationVariable -Name 'vmresourcegroupname'
# $vm   = Get-AutomationVariable -Name 'vmname'

$vmrg = 'vmrg'
$vmnames   = 'vm01', 'vm02', 'vm03'

foreach ($vm in $vmnames) {
    $statuses = Get-AzVM -ResourceGroupName $vmrg -Name $vm | Select-Object Name, Tags, @{Name="Status"; Expression={(Get-AzVM -Name $_.Name -ResourceGroupName $_.ResourceGroupName -status).Statuses[1].displayStatus}}
    if ('VM deallocated' -eq $statuses.Status -and $statuses.Tags.Keys -eq 'runbookstartvm' -and $statuses.Tags.Values -eq 'yesrunbookstart') {
        Write-Output "Starting $vm....."
        $start = Start-AzVM -ResourceGroupName $vmrg -Name $vm
        $vst = $Start.StartTime
        Write-Output "$vm statrted on $vst"
    }
    else{
        Write-Output "$VM is already either running or not in the condition"
    }
}
