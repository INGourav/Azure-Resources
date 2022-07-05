<#
About the script, this can export the terraform statefile resources information in a spreadsheet (a comma separated file)

Autor : - Gourav Kumar
Version : - 1.0.0
How to run  : - save the script and navigate to the same location/directory and use the below command to run the script, make sure we pass the location along with the name of the statefile.

.\statefile.ps1 -location 'C:\Statefilereading\terraform.tfstate' -ErrorAction SilentlyContinue

Here in 'C:\Statefilereading\terraform.tfstate'  , C:\Statefilereading\ is the location where statefile exist and terraform.tfstate is the state file name
#>

Param(
    [parameter (Mandatory = $True, ValueFromPipeLine = $True, HelpMessage = "Provide the Resource Name")]
    [Alias('Terraform state file location file')]
    [ValidateNotNullOrEmpty()]
    [string]$location

)

$statefile = (Get-Content -Raw -Path .\aws_terraform.tfstate | ConvertFrom-json).resources
$provider = $statefile.provider

if ($provider -eq 'provider["registry.terraform.io/hashicorp/azurerm"]') {

foreach($resource in $statefile)
{
    $fileinfo = New-Object psobject
    $fileinfo | Add-Member -MemberType NoteProperty -Name "Resource Mode" -Value $resource.mode
    $fileinfo | Add-Member -MemberType NoteProperty -Name "Resource Type" -Value $resource.type
    $fileinfo | Add-Member -MemberType NoteProperty -Name "Resource Name" -Value $resource.instances.attributes.name
    $fileinfo | Add-Member -MemberType NoteProperty -Name "Resource Location" -Value $resource.instances.attributes.location
    $fileinfo | Add-Member -MemberType NoteProperty -Name "Resource RG" -Value $resource.instances.attributes.resource_group_name

    # $fileinfo | Add-Member -MemberType NoteProperty -Name "TFRefName" -Value $resource.name
    # $fileinfo | Add-Member -MemberType NoteProperty -Name "ResourcesDsependencies" -Value ($resource.instances.dependencies -join ' , ')
    # $fileinfo | fl

    $fileinfo | Export-Csv C:\Temp\AzureStatefileinfo.csv -Append -NoTypeInformation

  }
} if ($provider -eq 'provider["registry.terraform.io/hashicorp/aws"]') {

foreach($resource in $statefile)
{
    $fileinfo = New-Object psobject
    $fileinfo | Add-Member -MemberType NoteProperty -Name "Resource Mode" -Value $resource.mode
    $fileinfo | Add-Member -MemberType NoteProperty -Name "Resource Type" -Value $resource.type
    $fileinfo | Add-Member -MemberType NoteProperty -Name "Resource Name" -Value $resource.instances.attributes.name
    $fileinfo | fl

    $fileinfo | Export-Csv C:\Temp\AWSStatefileinfo.csv -Append -NoTypeInformation

  }
}
