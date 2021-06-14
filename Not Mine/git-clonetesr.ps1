
Function Find-GitRepository {

<#
.SYNOPSIS
Find Git repositories
.DESCRIPTION
Use this command to find Git repositories in the specified folder. It is assumed that you have the Git command line tools already installed.
.PARAMETER Path
The top level path to search.
.EXAMPLE
PS C:\> Find-GitRepository -path D:\Projects

Repository             Branch LastAuthor     LastLog             
----------             ------ ----------     -------             
D:\Projects\Excalibur  master jdhitsolutions 4/17/2016 9:59:02 AM
D:\Projects\PiedPiper  bug    jdhitsolutions 5/16/2016 1:15:03 PM
D:\Projects\PSMagic    master jdhitsolutions 5/11/2016 1:27:35 PM
D:\Projects\ProjectX   dev    jdhitsolutions 4/12/2016 4:49:30 PM

.NOTES
NAME        :  Find-GitRepository
VERSION     :  1.0.0   
LAST UPDATED:  5/17/2016
AUTHOR      :  Jeff Hicks (@JeffHicks)

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
.LINK
https://gist.github.com/jdhitsolutions/ba3295167ccc997b7714e1f2a2777405
.INPUTS
[string]
.OUTPUTS
[pscustomobject]
#>

[cmdletbinding()]
Param(
[Parameter(
Position = 0,
HelpMessage = "The top level path to search"
)]
[ValidateScript({
if (Test-Path $_) {
   $True
}
else {
   Throw "Cannot validate path $_"
}
})]    
[string]$Path = "."
)

Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
Write-Verbose "[PROCESS] Searching $(Convert-Path -path $path) for Git repositories"

Get-ChildItem -path $Path -Hidden -filter .git -Recurse | 
Select-Object @{Name="Repository";Expression={Convert-Path $_.PSParentPath}},
@{Name ="Branch";Expression = {
 #save current location
 Push-Location
 #change location to the repository
 Set-Location -Path (Convert-Path -path ($_.psparentPath))
 #get current branch with out the leading asterisk
 (git branch).where({$_ -match "\*"}).Substring(2)
 
}},
@{Name="LastAuthor";Expression = { git log --date=local --format=%an -1 }},
 @{Name="LastLog";Expression = {
  (git log --date=iso --format=%ad -1 ) -as [datetime]
 #change back to original location
 Pop-Location
 }}

Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"

} #end function