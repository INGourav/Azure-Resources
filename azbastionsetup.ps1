<#
Script to install chocolatey on the windows system and install some apps that is needed for Azure
Author : - Gourav Kumar
Reach Me : - gouravxkumar@deloitte.co.uk
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
    Expand-Archive C:\temp\terraform_1.2.4_windows_amd64.zip C:\temp\terraform_1.2.4_windows_amd64 -Verbose -Force
    [System.Environment]::SetEnvironmentVariable('Path', 'C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\CCM;C:\Windows\CCM;C:\Windows\CCM;C:\Program Files (x86)\SafeCom\SafeComPrintClient;C:\temp\terraform_1.2.4_windows_amd64')

}

end{}
