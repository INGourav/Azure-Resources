
### Create new VNET ###
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetname
  location            = var.location
  resource_group_name = azurerm_resource_group.vnetrg.name
  address_space       = var.vnet_address_space
  tags                = local.common_tags
}


resource "azurerm_subnet" "wvd" {
  name                 = var.wvd_subnet_name
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.wvd_subnet_range
  #network_security_group_id = "${azurerm_network_security_group.ngx.id}"
}

resource "azurerm_subnet" "ad" {
  name                 = var.ad_subnet_name
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.ad_subnet_range
  #network_security_group_id = "${azurerm_network_security_group.ngx.id}"
}