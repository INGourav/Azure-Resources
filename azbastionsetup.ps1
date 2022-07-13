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
    Start-Sleep -Seconds 14
    Expand-Archive C:\temp\terraform_1.2.4_windows_amd64.zip C:\temp\terraform_1.2.4_windows_amd64 -Verbose -Force
    Start-Sleep -Seconds 14
    [System.Environment]::SetEnvironmentVariable('Path', 'C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\Program Files\dotnet\;C:\Program Files (x86)\dotnet\;C:\ProgramData\chocolatey\bin;C:\Program Files\Microsoft VS Code\bin;C:\Program Files\Git\cmd;C:\Users\tfvmtestrg\AppData\Local\Microsoft\WindowsApps;C:\temp\terraform_1.2.4_windows_amd64')

}

end{}
