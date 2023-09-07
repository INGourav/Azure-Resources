$SubscriptionId = "XXXXXXXXXXXXXXXXXXXXXXXXX"
$path = (Get-Location).Path
$reportname = "test.csv"

Connect-AzAccount

Select-AzSubscription $subscriptionId

$vms = Get-AzVM | Select-Object *
foreach ($vm in $vms) {
    $vminfo = New-object psobject
    $vminfo | Add-Member -MemberType NoteProperty -name "Subscription ID" -Value $SubscriptionId
    $vminfo | Add-Member -MemberType NoteProperty -name "VM Name" -Value $vm.Name
    $vminfo | Add-Member -MemberType NoteProperty -name "VM ResourceGroup" -Value $vm.ResourceGroupName
    $vminfo | Add-Member -MemberType NoteProperty -name "VM Location" -Value $vm.Location
    $vminfo | Add-Member -MemberType NoteProperty -name "VM Size" -Value $vm.HardwareProfile.VmSize
    $vminfo | Add-Member -MemberType NoteProperty -name "VM Status" -Value (Get-AzVM -Name $vm.Name-ResourceGroupName $vm.ResourceGroupName -Status).Statuses.DisplayStatus[-1]
    $vminfo | Add-Member -MemberType NoteProperty -name "Os Type" -Value $vm.StorageProfile.OsDisk.OsType
    $vminfo | Add-Member -MemberType NoteProperty -name "Os Disk Name" -Value $vm.StorageProfile.OsDisk.Name
    $vminfo | Add-Member -MemberType NoteProperty -name "Os Disk Size(GB)" -Value $vm.StorageProfile.OsDisk.DiskSizeGB
    $vminfo | Add-Member -MemberType NoteProperty -name "Os Disk Caching" -Value $vm.StorageProfile.OsDisk.Caching
    $vminfo | Add-Member -MemberType NoteProperty -name "Os Disk Tier" -Value (Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).Tier
    $vminfo | Add-Member -MemberType NoteProperty -name "Os Disk Creation Time" -Value (Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).TimeCreated
    $vminfo | Add-Member -MemberType NoteProperty -name "Os Disk SKU" -Value (Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).sku.Name
    $vminfo | Add-Member -MemberType NoteProperty -name "Os Disk Encryption Type" -Value (Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).Encryption.Type
    $vminfo | Add-Member -MemberType NoteProperty -name "Os Disk AV Zone" -Value (((Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).Zones) -join ';')
    $vminfo | Add-Member -MemberType NoteProperty -name "Boot Diagnostic Enabled" -Value $vm.DiagnosticsProfile.BootDiagnostics.Enabled
    $vminfo | Add-Member -MemberType NoteProperty -name "Boot Diagnostic Storage" -Value ($vm.DiagnosticsProfile.BootDiagnostics.StorageUri.Split("/")).split(".")[2]
    $vminfo | Add-Member -MemberType NoteProperty -name "Network Interface" -Value $vm.NetworkProfile.NetworkInterfaces.Id.Split("/")[-1]
    $vminfo | Add-Member -MemberType NoteProperty -name "VNET Name" -Value (Get-AzNetworkInterface -Name $vm.NetworkProfile.NetworkInterfaces.Id.Split("/")[-1]).IpConfigurations.Subnet.Id.Split("/")[-3]
    $vminfo | Add-Member -MemberType NoteProperty -name "Subnet Name" -Value (Get-AzNetworkInterface -Name $vm.NetworkProfile.NetworkInterfaces.Id.Split("/")[-1]).IpConfigurations.Subnet.Id.Split("/")[-1]
    $vminfo | Add-Member -MemberType NoteProperty -name "Private IP" -Value (Get-AzNetworkInterface -Name $vm.NetworkProfile.NetworkInterfaces.Id.Split("/")[-1]).IpConfigurations.PrivateIpAddress
    $i = ((Get-AzNetworkInterface -Name $vm.NetworkProfile.NetworkInterfaces.Id.Split("/")[-1]).IpConfigurations.PublicIpAddress.id).split("/")[-1]
    $pip = (Get-AzPublicIpAddress -Name $i).IpAddress
    $vminfo | Add-Member -MemberType NoteProperty -name "Public IP" -Value $pip
    $i = $null; $pip = $null
    

    if ($vm.StorageProfile.DataDisks.count -gt 0) {
        $disks = $vm.StorageProfile.DataDisks
        foreach ($disk in $disks) {
            if ($disk.Lun -eq 0) {
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk1 Name" -Value $disk.Name
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk1 Size(GB)" -Value $disk.DiskSizeGB
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk1 Caching" -Value $disk.Caching
            }if ($disk.Lun -eq 1) {
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk2 Name" -Value $disk.Name
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk2 Size(GB)" -Value $disk.DiskSizeGB
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk2 Caching" -Value $disk.Caching
            }if ($disk.Lun -eq 2) {
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk3 Name" -Value $disk.Name
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk3 Size(GB)" -Value $disk.DiskSizeGB
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk3 Caching" -Value $disk.Caching
            }
        }
    }
    $vminfo
    $vminfo | Export-CSV "$path$reportname" -Append -NoTypeInformation
}
