# Input Parameters  
$resourceGroupName ="teststr"  
$storageAccName    ="teststrd"  
$fileShareName     ="teststrdshare"  
 
# Connect to Azure Account  
#Connect-AzAccount   
 
# Function to Lists directories and files  
Function GetFiles  
{  
    Write-Host -ForegroundColor Green "Lists directories and files.."    
    # Get the storage account context   
    $ctx = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccName).Context
    # List directories  
    $directories=Get-AZStorageFile -Context $ctx -ShareName $fileShareName  
    # Loop through directories  
    foreach($directory in $directories)  
    {  
        Write-host -ForegroundColor Magenta " Directory Name: " $directory.Name  
        $files = Get-AZStorageFile -Context $ctx -ShareName $fileShareName -Path $directory.Name | Get-AZStorageFile  
        # Loop through all files and display  
        foreach ($file in $files)  
        {  
            Write-host -ForegroundColor Yellow $file.Name  
        }  
    }  
}  
GetFiles


# Copy Data from one fileshare to another fileshare
https://docs.microsoft.com/en-us/powershell/module/az.storage/get-azstoragefile?view=azps-5.9.0
https://docs.microsoft.com/en-us/powershell/module/az.storage/Start-AzStorageFileCopy?view=azps-5.9.0

$srctx  = (Get-AzStorageAccount -ResourceGroupName "teststrcp" -Name "teststrcp1").Context
$desctx = (Get-AzStorageAccount -ResourceGroupName "teststrcp" -Name "teststrcp2").Context
Start-AzStorageFileCopy -SrcShareName "firststrfirstshare" -SrcFilePath test1.txt -DestShareName "secondstrfirstshare" -DestFilePath "test1.txt" -Context $srctx -DestContext $desctx