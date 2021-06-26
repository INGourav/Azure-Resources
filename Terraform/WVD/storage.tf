resource "azurerm_storage_account" "fsstr" {
  name                     = var.fsstrname
  resource_group_name      = azurerm_resource_group.strrg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags
}