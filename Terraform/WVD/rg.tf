resource "azurerm_resource_group" "advm" {
  name     = var.adrg
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "vm" {
  name     = var.hprg
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "wvdwks" {
  name     = var.wvdwksrg
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "hp" {
  name     = var.hprg
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "vnetrg" {
  name     = var.vnetrg
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "strrg" {
  name     = var.strrg
  location = var.location
  tags     = local.common_tags
}