<#
This script is basically created to copy and paste fileshare from one storage account to another.
We used this to copy our MSIX appa attach VHDX from one fileshare another for BCDR
Author: -  Gourav Kumar
Reach Me: - gouravin@outlook.com
LinkedIN: - https://www.linkedin.com/in/gouravrathore/
Version: - 1.0.0.2
#>

$date     = (Get-Date).AddDays(-1)     # Getting yesterday to compare and only copying files thats was modifed within 24 hours
$srcstr   = "teststrcp1"               # Source storage account name, where already files are there
$srcstrrg = "teststrcp"                # Source storage account resourcegroup name
$srcfs    = "firststrfirstshare"       # Source FileShare name, where already files are there
$desstr   = "teststrcp2"               # Destination storage account name, where need to copy files
$desstrrg = "teststrcp"                # Destination storage account resourcegroup name
$desfs    = "secondstrfirstshare"      # Destination FileShare name, where need to copy files

# Context creation of source storage account that we required to fetch fileshare, files and copy paste as well
$srcstrctx = (Get-AzStorageAccount -ResourceGroupName $srcstrrg -Name $srcstr).Context

# Context creation of destination storage account that we required to paste files
$desstrct  = (Get-AzStorageAccount -ResourceGroupName $desstrrg -Name $desstr).Context

# fetching all items of Azure fileshare
$fsitems   = Get-AZStorageFile -Context $srcstrctx -ShareName $srcfs

# Loop through items and gathering their name, modification date
foreach ($dir in $fsitems) {
    $file     = Get-AZStorageFile -Context $srcstrctx -ShareName $srcfs -Path $dir.Name
    $filename = $file.Name
    $moddate  = $dir.FileProperties.LastModified.DateTime

# if last modified date is less then today then paste this item to destination storage account else do nothing as it is already up to date
     if ($moddate -ge $date) {
         Write-Output "Copying $filename from source storage account $srcstr to destination storage account $desstr"
        Start-AzStorageFileCopy -SrcShareName $srcfs -SrcFilePath $dir.Name -DestShareName $desfs -DestFilePath $dir.Name -Context $srcstrctx -DestContext $desstrct -Force
     } else {
         Write-Output "$filename is Up to Date"
     }
}