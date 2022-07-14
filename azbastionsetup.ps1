<#
Script to install chocolatey on the windows system and install some apps that is needed for Azure
Author : - Gourav Kumar
Reach Me : - gouravin@outlook.com
Version : - 1.0.1
#>

    Set-ExecutionPolicy Bypass -Scope Process -Force;
    
    # Installation of Terraform on the machine

    Invoke-WebRequest 'https://releases.hashicorp.com/terraform/1.2.4/terraform_1.2.4_windows_amd64.zip' -OutFile C:\temp\terraform_1.2.4_windows_amd64.zip -Verbose
    Start-Sleep -Seconds 5;
#     Expand-Archive C:\temp\terraform_1.2.4_windows_amd64.zip C:\temp\terraform_1.2.4_windows_amd64 -Verbose -Force
    Expand-Archive C:\temp\terraform_1.2.4_windows_amd64.zip C:\Windows\system32 -Verbose -Force
    Start-Sleep -Seconds 5;
    
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) -Verbose
    Start-Sleep -Seconds 5;

    # Installation of apps (Pycharm, vscode, git, and drwaio)

    choco install pycharm -y --force;
    Start-Sleep -Seconds 5;
    choco install vscode -y --force;
    Start-Sleep -Seconds 5;
    choco install git -y --force;
    Start-Sleep -Seconds 5;
    choco install drawio -y --force;
    Start-Sleep -Seconds 5;

   # setting env vars
   
#     $path = (Get-Item -Path Env:\Path).Value
#     Start-Sleep -Seconds 5;
#     $newpath = $path + 'C:\Temp\terraform_1.2.4_windows_amd64'
#     Start-Sleep -Seconds 5;
#     Set-Item -Path Env:\Path -Value $newpath

