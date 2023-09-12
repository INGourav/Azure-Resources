[CmdletBinding()]

$rawip = Invoke-WebRequest ifconfig.me/ip -UseBasicParsing
$ip = $rawip.Content
$SubscriptionId = 'XXXXXXXXXXXXXXXXXX'
$StorageAccountName = 'XXXXXXXXXXX'
$StorageAccountResourceGroupName = 'runbooktest'
$ContainerName = 'vminfo'
$sleepDuration = 10
$date = ((Get-Date).ToString().Split(" ")[0]).Split("/") -join "_"

$connection = Connect-AzAccount -Identity;

$runbookSubscriptionId = $SubscriptionId;

Select-AzSubscription $subscriptionId

Write-Output "Adding $ip to storage account"
Add-AzStorageAccountNetworkRule -ResourceGroupName $StorageAccountResourceGroupName -Name $StorageAccountName -IPAddressOrRange $ip | Out-Null;    

Start-Sleep -s $sleepDuration;

$vms = Get-AzVM | Select-Object * | Select-Object -First 1
foreach ($vm in $vms) {
    $vminfo = New-object psobject
    $vminfo | Add-Member -MemberType NoteProperty -name "Subscription ID" -Value $SubscriptionId
    $vminfo | Add-Member -MemberType NoteProperty -name "VM Name" -Value $vm.Name
    $vminfo | Add-Member -MemberType NoteProperty -name "VM ResourceGroup" -Value $vm.ResourceGroupName
    $vminfo | Add-Member -MemberType NoteProperty -name "VM Location" -Value $vm.Location
    $vminfo | Add-Member -MemberType NoteProperty -name "VM Size" -Value $vm.HardwareProfile.VmSize
    $vminfo | Add-Member -MemberType NoteProperty -name "VM Status" -Value (Get-AzVM -Name $vm.Name-ResourceGroupName $vm.ResourceGroupName -Status).Statuses.DisplayStatus[-1]
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Type" -Value $vm.StorageProfile.OsDisk.OsType
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk Name" -Value $vm.StorageProfile.OsDisk.Name
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk Size(GB)" -Value (Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).DiskSizeGB
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk Caching" -Value $vm.StorageProfile.OsDisk.Caching
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk CreationOption" -Value $vm.StorageProfile.OsDisk.CreateOption
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk DeleteOption" -Value $vm.StorageProfile.OsDisk.DeleteOption
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk Tier" -Value (Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).Tier
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk Creation Time" -Value (Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).TimeCreated
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk SKU" -Value (Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).sku.Name
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk Encryption Type" -Value (Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).Encryption.Type
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk AV Zone" -Value (((Get-AzDisk -ResourceGroupName $vm.ResourceGroupName  -DiskName $vm.StorageProfile.OsDisk.Name).Zones) -join ';')
    $vminfo | Add-Member -MemberType NoteProperty -name "OS Disk Tag" -Value ((Get-AzDisk -ResourceGroupName $vm.ResourceGroupName -Name $vm.StorageProfile.OsDisk.Name | select @{Name='Tags';Expression={ foreach ($key in $_.Tags.Keys ) { $Key + " = " + $_.Tags[$key] } } }).Tags  -join ' ; ')
    $vminfo | Add-Member -MemberType NoteProperty -name "Boot Diagnostic Enabled" -Value $vm.DiagnosticsProfile.BootDiagnostics.Enabled
    $vminfo | Add-Member -MemberType NoteProperty -name "Boot Diagnostic Storage" -Value ($vm.DiagnosticsProfile.BootDiagnostics.StorageUri.Split("/")).split(".")[2]
    $vei = $vm.Extensions.id ;$ext=foreach($ve in $vei){$ve.Split("/")[-1]}; $e = $ext -join ' ; ';
    $vminfo | Add-Member -MemberType NoteProperty -name "Extension Installed" -Value $e
    $vminfo | Add-Member -MemberType NoteProperty -name "Network Interface" -Value $vm.NetworkProfile.NetworkInterfaces.Id.Split("/")[-1]
    $vminfo | Add-Member -MemberType NoteProperty -name "VNET Name" -Value (Get-AzNetworkInterface -Name $vm.NetworkProfile.NetworkInterfaces.Id.Split("/")[-1]).IpConfigurations.Subnet.Id.Split("/")[-3]
    $vminfo | Add-Member -MemberType NoteProperty -name "Subnet Name" -Value (Get-AzNetworkInterface -Name $vm.NetworkProfile.NetworkInterfaces.Id.Split("/")[-1]).IpConfigurations.Subnet.Id.Split("/")[-1]
    $vminfo | Add-Member -MemberType NoteProperty -name "Private IP" -Value (Get-AzNetworkInterface -Name $vm.NetworkProfile.NetworkInterfaces.Id.Split("/")[-1]).IpConfigurations.PrivateIpAddress
    $i = ((Get-AzNetworkInterface -Name $vm.NetworkProfile.NetworkInterfaces.Id.Split("/")[-1]).IpConfigurations.PublicIpAddress.id).split("/")[-1]
    $pip = (Get-AzPublicIpAddress -Name $i).IpAddress
    $vminfo | Add-Member -MemberType NoteProperty -name "Public IP" -Value $pip
        
    if ($vm.StorageProfile.DataDisks.count -gt 0) {
        $disks = $vm.StorageProfile.DataDisks
        foreach ($disk in $disks) {
            if ($disk.Lun -eq 0) {
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk1 Name" -Value $disk.Name
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk1 Caching" -Value $disk.Caching
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk1 Size(GB)" -Value ((Get-AzDisk -DiskName $vm.StorageProfile.DataDisks.Name -ResourceGroupName $vm.ResourceGroupName).DiskSizeGB)                
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk1 SKU" -Value ((Get-AzDisk -DiskName $vm.StorageProfile.DataDisks.Name -ResourceGroupName $vm.ResourceGroupName).Sku.Name)
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk1 AV Zone" -Value (((Get-AzDisk -DiskName $vm.StorageProfile.DataDisks.Name -ResourceGroupName $vm.ResourceGroupName).Zones) -join ';')
            }if ($disk.Lun -eq 1) {
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk2 Name" -Value $disk.Name
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk2 Caching" -Value $disk.Caching
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk2 Size(GB)" -Value ((Get-AzDisk -DiskName $vm.StorageProfile.DataDisks.Name -ResourceGroupName $vm.ResourceGroupName).DiskSizeGB)
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk2 SKU" -Value ((Get-AzDisk -DiskName $vm.StorageProfile.DataDisks.Name -ResourceGroupName $vm.ResourceGroupName).Sku.Name)
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk2 AV Zone" -Value (((Get-AzDisk -DiskName $vm.StorageProfile.DataDisks.Name -ResourceGroupName $vm.ResourceGroupName).Zones) -join ';')
            }if ($disk.Lun -eq 2) {
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk3 Name" -Value $disk.Name
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk3 Caching" -Value $disk.Caching
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk3 Size(GB)" -Value ((Get-AzDisk -DiskName $vm.StorageProfile.DataDisks.Name -ResourceGroupName $vm.ResourceGroupName).DiskSizeGB)               
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk3 SKU" -Value ((Get-AzDisk -DiskName $vm.StorageProfile.DataDisks.Name -ResourceGroupName $vm.ResourceGroupName).Sku.Name)
                $vminfo | Add-Member -MemberType NoteProperty -name "Data Disk3 AV Zone" -Value (((Get-AzDisk -DiskName $vm.StorageProfile.DataDisks.Name -ResourceGroupName $vm.ResourceGroupName).Zones) -join ';')
            }
        }
    }
    
    $vminfo
    $vminfo | Export-CSV ($env+$date+"_VMInfo.csv") -Append -NoTypeInformation -Force
    $vm = $i = $pip = $vei = $ext = $e = $null;
}

Write-Output "uploading file file to storage account"
$key = (Get-AzStorageAccountKey -ResourceGroupName $StorageAccountResourceGroupName -Name $StorageAccountName)[0].Value
$context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $key
Set-AzStorageBlobContent -Context $Context -Container $ContainerName -File ($env+$date+"_VMInfo.csv") -Blob ($date+"_VMInfo.csv") -Force

Start-Sleep -s $sleepDuration;

Write-Output "Removing $ip to storage account"
Remove-AzStorageAccountNetworkRule -ResourceGroupName $StorageAccountResourceGroupName -AccountName $StorageAccountName -IPAddressOrRange $ip | Out-Null;


 
