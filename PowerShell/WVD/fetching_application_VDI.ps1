<#
This will create 2 files in C:\temp. one computername.csv with list of apps and computername.csv with list of groups that have remote access to the machine
#>
if (!([Diagnostics.Process]::GetCurrentProcess().Path -match '\\syswow64\\')) {
    $unistallPath = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"
    $unistallWow6432Path = "\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\"
    @(
        if (Test-Path "HKLM:$unistallWow6432Path" ) { Get-ChildItem "HKLM:$unistallWow6432Path" }
        if (Test-Path "HKLM:$unistallPath" ) { Get-ChildItem "HKLM:$unistallPath" }
        if (Test-Path "HKCU:$unistallWow6432Path") { Get-ChildItem "HKCU:$unistallWow6432Path" }
        if (Test-Path "HKCU:$unistallPath" ) { Get-ChildItem "HKCU:$unistallPath" }
    ) |
    ForEach-Object { Get-ItemProperty $_.PSPath } |
    Where-Object {
        $_.DisplayName -and !$_.SystemComponent -and !$_.ReleaseType -and !$_.ParentKeyName -and ($_.UninstallString -or $_.NoRemove)
    } |
    Sort-Object DisplayName | Select-Object DisplayName |
    export-csv c:\temp\$env:COMPUTERNAME.csv
    Get-LocalGroupMember -Group "remote desktop users" | Out-File c:\util\$env:COMPUTERNAME.txt
}
else {
    "You are running 32-bit Powershell on 64-bit system. Please run 64-bit Powershell instead." | Write-Host -ForegroundColor Red
}







################## Version 2 for needs ################################




$item = Get-Content -path c:\util\vazss.csv

#$item = "vazss242"

foreach ($compname in $item) {
    ​​​​​​​Invoke-Command -ComputerName $compname -ScriptBlock { ​​​​​​​
        if (!([Diagnostics.Process]::GetCurrentProcess().Path -match '\\syswow64\\')) {
            ​​​​​​​$unistallPath = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"
            $unistallWow6432Path = "\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\"

            @(

                if (Test-Path "HKLM:$unistallWow6432Path" ) { ​​​​​​​ Get-ChildItem "HKLM:$unistallWow6432Path" }​​​​​​​
                if (Test-Path "HKLM:$unistallPath" ) { ​​​​​​​ Get-ChildItem "HKLM:$unistallPath" }​​​​​​​
                if (Test-Path "HKCU:$unistallWow6432Path") { ​​​​​​​ Get-ChildItem "HKCU:$unistallWow6432Path" }​​​​​​​
                if (Test-Path "HKCU:$unistallPath" ) { ​​​​​​​ Get-ChildItem "HKCU:$unistallPath" }​​​​​​​

            ) |

            ForEach-Object { ​​​​​​​ Get-ItemProperty $_.PSPath }​​​​​​​ |
            Where-Object { ​​​​​​​
                $_.DisplayName -and !$_.SystemComponent -and !$_.ReleaseType -and !$_.ParentKeyName -and ($_.UninstallString -or $_.NoRemove)
            }​​​​​​​ |
            Sort-Object DisplayName | Select-Object DisplayName |
            export-csv c:\util\$env:COMPUTERNAME.csv

        }​​​​​​​else
        { ​​​​​​​

            "You are running 32-bit Powershell on 64-bit system. Please run 64-bit Powershell instead." | Write-Host -ForegroundColor Red
        }​​​​​​​
    }​​​​​​​

    Copy-Item -path [file://$compname/c$/util/$compname.csv]\\$compname\c$\util\$compname.csv -Destination \\filesshare\Misc\appcap\
    remove-Item -path [file://$compname/c$/util/$compname.csv]\\$compname\c$\util\$compname.csv

}​​​​​​​