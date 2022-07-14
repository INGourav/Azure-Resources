<#
Script to install chocolatey on the windows system and install some apps that is needed for Azure
Author : - Gourav Kumar
Reach Me : - gouravin@outlook.com
Version : - 1.0.1
#>

begin {
    # Installation of choco

    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) -Verbose

    # Installation of apps (Pycharm, vscode, git, and drwaio)

    choco install pycharm -y --force;
    choco install vscode -y --force;
    choco install git -y --force;
    choco install drawio -y --force;

    # Installation of Terraform on the machine

    Invoke-WebRequest 'https://releases.hashicorp.com/terraform/1.2.4/terraform_1.2.4_windows_amd64.zip' -OutFile C:\temp\terraform_1.2.4_windows_amd64.zip -Verbose
    Start-Sleep -Seconds 10
    Expand-Archive C:\temp\terraform_1.2.4_windows_amd64.zip C:\temp\terraform_1.2.4_windows_amd64 -Verbose -Force
    Start-Sleep -Seconds 10
    $path = (Get-Item -Path Env:\Path).Value
    $newpath = $path + 'C:\Temp\terraform_1.2.4_windows_amd64'
    Set-Item -Path Env:\Path -Value $newpath
}

end{}
