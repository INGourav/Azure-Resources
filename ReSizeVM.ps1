param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$subscription,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$resourceGroupName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string[]]$vmName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$size
)

$time = (Get-Date).ToString()
$zone = ((Get-timeZone).DisplayName).ToString()
$name = ((Get-timeZone).StandardName).ToString()
Write-Output "VM Scale UP/DOWN Time = $time $Zone $Name"

Set-Azcontext -SubscriptionId $subscription

foreach ($vmloop in $vmName) {
    $VMStats = (Get-AzVM -Name $vmloop -ResourceGroupName $resourceGroupName -Status).Statuses
    
    if ("VM running" -eq $VMStats[1].DisplayStatus)
    {
        Write-Output "Stopping the $vmloop"

        Stop-AzVM -ResourceGroupName $resourceGroupName -Name $vmloop -Force

        $vm1 = Get-AzVM -ResourceGroupName $resourceGroupName -VMName $vmloop
        $vm1.HardwareProfile.VmSize = $size

        Update-AzVM -VM $vm1 -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue

        Start-AzVM -ResourceGroupName $resourceGroupName -Name $vmloop
    }else {
        Write-Output "$vmloop is already stopped performing resize"

        $vm1 = Get-AzVM -ResourceGroupName $resourceGroupName -VMName $vmloop
        $vm1.HardwareProfile.VmSize = $size

        Update-AzVM -VM $vm1 -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue

        Start-AzVM -ResourceGroupName $resourceGroupName -Name $vmloop
    }
}
