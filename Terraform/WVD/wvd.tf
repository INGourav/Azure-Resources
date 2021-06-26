
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = var.wkspacename
  location            = var.location
  resource_group_name = azurerm_resource_group.wvdwks.name

  friendly_name = var.wkspacename
  description   = "Acceptance Test: Test Workspace Deployed using Terraform"
}


resource "azurerm_virtual_desktop_host_pool" "wvdhp" {
  location            = var.location
  resource_group_name = azurerm_resource_group.hp.name

  name                 = var.hpname
  friendly_name        = var.hpname
  validate_environment = false
  start_vm_on_connect  = true
  #custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  description              = "Acceptance Test: A pooled host pool - pooleddepthfirst"
  type                     = "Pooled"
  maximum_sessions_allowed = 50
  load_balancer_type       = "DepthFirst"
  tags                     = local.common_tags
}


resource "azurerm_virtual_desktop_application_group" "remoteapp" {
  name                = var.appgname
  location            = var.location
  resource_group_name = azurerm_resource_group.hp.name

  type          = "Desktop"
  host_pool_id  = azurerm_virtual_desktop_host_pool.wvdhp.id
  friendly_name = "DesktopAppGroup"
  description   = "Acceptance Test: An application group"
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspacedesktopapp" {
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.remoteapp.id
}