##################################################
# Add AD Users
##################################################

# Set values for your environment
$wvduser = "3"
$hruser = "5"
$wvduserprefix = "WVDUser"
$hruserprefix = "HRWVDUser"
$passWord = "P@ssword!"
$userDomain = "azurelearn.com"

# Import the AD Module
Import-Module ActiveDirectory

# Convert the password to a secure string
$UserPass = ConvertTo-SecureString -AsPlainText "$passWord" -Force

#Add the users
for ($i=0; $i -le $wvduser; $i++) {
$newUser = $wvduserprefix + $i
New-ADUser -name $newUser -SamAccountName $newUser -UserPrincipalName $newUser@$userDomain -GivenName $newUser -Surname $newUser -DisplayName $newUser `
-AccountPassword $userPass -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true
}

for ($i=0; $i -le $hruser; $i++) {
    $newUser = $hruserprefix + $i
    New-ADUser -name $newUser -SamAccountName $newUser -UserPrincipalName $newUser@$userDomain -GivenName $newUser -Surname $newUser -DisplayName $newUser `
    -AccountPassword $userPass -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true
    }