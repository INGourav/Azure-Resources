Connect-AzAccount

$name = "drtestwvdcac"
$location = "canadacentral"
New-AzResourceGroup -Name $name -Location $location


$vnetaddressrange = "10.0.0.0/16"
$frontendrange    = "10.0.1.0/24"
$frontendSubnet   = New-AzVirtualNetworkSubnetConfig -Name "$name-frontendsubnet" -AddressPrefix $frontendrange
New-AzVirtualNetwork -Name "$name-vnet" -Location $location -AddressPrefix $vnetaddressrange -ResourceGroupName $name -Subnet $frontendSubnet

# Create a VM with Static IP
vm-adm
Test@1234567890
# Connect and run below script in sequence

#Declare variables
$DatabasePath = "G:\windows\NTDS"
$DomainMode = "WinThreshold"
#Change the Domain name and Domain Net BIOS Name to match your public domain name
$DomainName = "drtestwvdcac.com"
$DomaninNetBIOSName = "drtestwvdcac"
$ForestMode = "WinThreshold"
$LogPath = "G:\windows\NTDS"
$SysVolPath = "G:\windows\SYSVOL"
$Password = "Pass1w0rd"

#Install AD DS, DNS and GPMC 
start-job -Name addFeature -ScriptBlock { 
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools } 
Wait-Job -Name addFeature 
Get-WindowsFeature | Where-Object {$_.InstallState -eq 'Installed'} | Format-Table DisplayName,Name,InstallState

#Convert Password 
$Password = ConvertTo-SecureString -String $Password -AsPlainText -Force

#Create New AD Forest
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath $DatabasePath -DomainMode $DomainMode -DomainName $DomainName `
    -SafeModeAdministratorPassword $Password -DomainNetbiosName $DomainNetBIOSName -ForestMode $ForestMode -InstallDns:$true -LogPath $LogPath -NoRebootOnCompletion:$false `
    -SysvolPath $SysVolPath -Force:$true


##################################################
# Add AD Users
##################################################

# Set values for your environment
$numUsers = "10"
$userPrefix = "WVDUser"
$passWord = "P@ssword!"
$userDomain = "drtestwvdcac.com"

# Import the AD Module
Import-Module ActiveDirectory

# Convert the password to a secure string
$UserPass = ConvertTo-SecureString -AsPlainText "$passWord" -Force

#Add the users
for ($i=0; $i -le $numUsers; $i++) {
$newUser = $userPrefix + $i
New-ADUser -name $newUser -SamAccountName $newUser -UserPrincipalName $newUser@$userDomain -GivenName $newUser -Surname $newUser -DisplayName $newUser `
-AccountPassword $userPass -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true
}















$connectTestResult = Test-NetConnection -ComputerName drtestwvdcacstr.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"drtestwvdcacstr.file.core.windows.net`" /user:`"Azure\drtestwvdcacstr`" /pass:`"icMoLN350xsUJUaPAjIiHHf0rFs2tATy96PmOA1XYANBLMfPxZvt+w0knQS1/S9cYKub4Jr5w896BilmjGVezQ==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\drtestwvdcacstr.file.core.windows.net\drtestwvdcacsfs" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}