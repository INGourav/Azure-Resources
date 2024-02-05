# Set the paths
$originalFolder = "C:\inetpub\wwwroot"
$newFolder = "C:\inetpub\wwwrootNEW"
$oldFolder = "C:\inetpub\wwwrootOLD"
$old_name ="wwwrootOLD"
$original_folder_name = "wwwroot"
$path = "C:\inetpub\wwwroot"
 
Test-Path -path $path
 
# Create a copy of the original folder
Copy-Item -Path $originalFolder -Destination $newFolder -Recurse
 
# Rename the original folder to "wwwrootOLD"
Rename-Item -Path $originalFolder -NewName $old_name
 
# Rename the new folder to "wwwroot"
Rename-Item -Path $newFolder -NewName $original_folder_name
