# Set the paths
$originalFolder = "G:\PowerShell\testing\path\"
$newFolder = "G:\PowerShell\testing\pathNEW"
$old_name ="pathOLD"
$original_folder_name = "pathold"

# Check path
$testpath = Test-Path -path $originalFolder
if ($true -eq $testpath) {
    # Create a copy of the original folder
    Copy-Item -Path $originalFolder -Destination $newFolder -Recurse
    Start-Sleep -Seconds 5
    
    # Rename the original folder to "wwwrootOLD"
    Rename-Item -Path $originalFolder -NewName $old_name
     
    # Rename the new folder to "wwwroot"
    Rename-Item -Path $newFolder -NewName $original_folder_name
}else {
    Write-Output "Path not found"
}
