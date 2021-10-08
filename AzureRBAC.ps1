<# How to run

.\RBAC_Role_Assignment.ps1 -resource 'resourcename' -role 'RoleName' -email 'User Sign In Email'

#>


Param(
    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the Resource Name")]
    [Alias('ResourceName')]
    [ValidateNotNullOrEmpty()]
    [string]$resource,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the Role type")]
    [Alias('Role Name')]
    [ValidateNotNullOrEmpty()]
    [string]$role,

    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the Sign in Email")]
    [Alias('EmailAddress')]
    [ValidateNotNullOrEmpty()]
    [string]$email

)


$rid = (Get-AzResource -Name $resource).ResourceId


New-AzRoleAssignment -SignInName $email -Scope $rid -RoleDefinitionName $role -Verbose
