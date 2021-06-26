resource "azurerm_network_security_group" "adnsg" {
  name                = "${var.ad_subnet_name}-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.vnetrg.name

  tags = local.common_tags

  ### Inbound ##

  security_rule {
    name                       = "Allow_RDP_SSH_INBOUND"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "4421", "3389", "5986"]
    source_address_prefix      = "*"
    destination_address_prefix = var.ad_subnet_range_nsg
    description                = "Allow access for RDP and SSH"
  }

}

### NSG Association ###
resource "azurerm_subnet_network_security_group_association" "ngx" {
  network_security_group_id = azurerm_network_security_group.adnsg.id
  subnet_id                 = azurerm_subnet.ad.id
}