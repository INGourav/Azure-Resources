# Connect to Azure account
#Connect-Azaccount

# Create resourceGroup for point to site
$builddate    = Get-Date -Format "MM/dd/yyyy"
$rgname       = "az-rg-pts"
$location     = "Central India"
$tag          = @{ BuildDate = $builddate; BuildBy = 'Gourav' }
New-AzResourceGroup -Name $rgname -Location $location -Tag $tag -Verbose

Start-Sleep -Seconds 5

# Creation on Vnet and Subnet for pts
$builddate        = Get-Date -Format "MM/dd/yyyy"
$rgname           = "az-rg-pts"
$vnetname         = "az-vnet-pts"
$subnetName       = "frontendSubnet"
$location         = "Central India"
$vnetaddressrange = "10.0.0.0/16"
$frontendrange    = "10.0.1.0/24"
$gatewayrange     = "10.0.2.0/24"
$tag              = @{ BuildDate = $builddate; BuildBy = 'Gourav'; IP = '10.0.0.0/16' }
$frontendSubnet   = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $frontendrange
$gatewaySubnet    = New-AzVirtualNetworkSubnetConfig -Name Gatewaysubnet  -AddressPrefix $gatewayrange
New-AzVirtualNetwork -Name $vnetname -Location $location -AddressPrefix $vnetaddressrange -Tag $tag -ResourceGroupName $rgname -Subnet $frontendSubnet,$gatewaySubnet


# Creation of NSG for traffic filtering
$builddate                  = Get-Date -Format "MM/dd/yyyy"
$rgname                     = "az-rg-pts"
$location                   = "Central India"
$nsgname                    = "az-nsg-pts-vm"
$vnetname                   = "az-vnet-pts"
$subnetName                 = "frontendSubnet"  

$rule1 = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389
$rule2 = New-AzNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rgname -Location $location -Name $nsgname -SecurityRules $rule1,$rule2

$vnet = Get-AzVirtualNetwork -Name $vnetname -ResourceGroupName $rgname
$subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName
# Commenting the below line as I am not going to fetch NSG now at this point in time.
#$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $rgname -Name $nsgname
$subnet.NetworkSecurityGroup = $nsg
Set-AzVirtualNetwork -VirtualNetwork $vnet


Start-Sleep -Seconds 5

# Creation of New Virtual Machine and its component
$builddate                  = Get-Date -Format "MM/dd/yyyy"
$rgname                     = "az-rg-pts"
$vnetname                   = "az-vnet-pts"
$location                   = "Central India"
$straccount                 = "azstrptsdiag"
$strsku                     = "Standard_LRS"
$nicName                    = "az-vm-pts-nic"
$subnetName                 = "frontendSubnet"
$vmlocaladminuser           = "az-vm-pts-adm"
$vmlocaladminsecurepassword = ConvertTo-SecureString "Test@1234567890" -AsPlainText -Force
$computername               = "az-vm-pts"
$vmname                     = "az-vm-pts"
$vmsize                     = "Standard_B2ms"
$vmosdisksku                = 'Standard_LRS'
$vmosdiskname               = "$vmname-osdisk"
$vmdatadiskname1            = "$vmname-datadisk-1"
$vmdatadiskname2            = "$vmname-datadisk-2"
$nicname                    = "az-vm-pts-nic"
$tag                        = @{ BuildDate = $builddate; BuildBy = 'Gourav' }

# Storage account for boot diag
New-AzStorageAccount -ResourceGroupName $rgname -Name $straccount -Location $location -SkuName $strsku -Tag $tag
Start-Sleep -Seconds 20

$vnet = Get-AzVirtualNetwork -Name $vnetname
$subnetid = (Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $vnet).id
$nic = New-AzNetworkInterface -Name $nicname -ResourceGroupName $rgname -Location $location -SubnetId $subnetid -Tag $tag
Start-Sleep -Seconds 5

$nic.IpConfigurations[0].PrivateIpAllocationMethod = "static"
Set-AzNetworkInterface -NetworkInterface $nic

$credential = New-Object System.Management.Automation.PSCredential ($vmlocaladminuser, $vmlocaladminsecurepassword)
$virtualmachine = New-AzVMConfig -VMName $vmname -VMSize $vmsize
$virtualmachine = Set-AzVMOperatingSystem -VM $virtualmachine -Windows -ComputerName $computername -Credential $credential -ProvisionVMAgent -EnableAutoUpdate
$virtualmachine = Add-AzVMNetworkInterface -VM $virtualmachine -Id $nic.Id
$virtualmachine = Set-AzVMSourceImage -VM $virtualmachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2012-R2-Datacenter' -Version latest
$virtualmachine = Set-AzVMBootDiagnostic -VM $virtualmachine -ResourceGroupName $rgname -StorageAccountName $straccount -Enable
$virtualmachine = Set-AzVMOSDisk -VM $virtualmachine -Name $vmosdiskname -StorageAccountType $vmosdisksku -DiskSizeInGB 127 -Caching 'ReadWrite' -CreateOption 'FromImage' -Windows
# Uncomment this for data disk
$diskconfig1 = New-AzDiskConfig -Location $location -DiskSizeGB 32 -SkuName StandardSSD_LRS -OsType Windows -CreateOption Empty -Tag $tag
$disk1 = New-AzDisk -ResourceGroupName $rgname -DiskName $vmdatadiskname1 -Disk $diskconfig1
$diskconfig2 = New-AzDiskConfig -Location $location -DiskSizeGB 32 -SkuName Premium_LRS -OsType Windows -CreateOption Empty -tag $tag
$disk2 = New-AzDisk -ResourceGroupName $rgname -DiskName $vmdatadiskname2 -Disk $diskconfig2
$virtualmachine = Add-AzVMDataDisk -VM $virtualmachine -Name $vmdatadiskname1 -Lun 0 -Caching "None" -CreateOption "Attach" -ManagedDiskId $disk1.Id
$virtualmachine = Add-AzVMDataDisk -VM $virtualmachine -Name $vmdatadiskname2 -Lun 1 -Caching "ReadOnly" -CreateOption "Attach" -ManagedDiskId $disk2.Id
New-AzVM -ResourceGroupName $rgname -Location $location -VM $virtualmachine -Verbose -Tag $tag


# # create a lock on RG so none can delete this without removal of the same
# $lockname = "Non Deletable"
# New-AzResourceLock -LockName $lockname -LockLevel CanNotDelete -LockNotes "point to site connectivity resourcegroup" -Scope $rgname

