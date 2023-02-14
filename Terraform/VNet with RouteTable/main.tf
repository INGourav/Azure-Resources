resource "azurerm_resource_group" "networkrg" {
  name     = var.resource-group-name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetname
  location            = var.location
  resource_group_name = var.rgname
  address_space       = var.cidr
}

resource "azurerm_subnet" "hubsubnets" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  for_each             = var.subnet_name
  name                 = each.value.name
  address_prefixes     = each.value.cidr
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsgname
  location            = azurerm_virtual_network.vnet.location
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name

  lifecycle {
    ignore_changes = [tags]
  }
  security_rule {
    name                       = "test001"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgadd" {
  for_each                  = azurerm_subnet.hubsubnets
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_route_table" "rt" {
  name                          = var.routetablename
  location                      = azurerm_virtual_network.vnet.location
  resource_group_name           = azurerm_virtual_network.vnet.resource_group_name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = "10.1.0.0/16"
    next_hop_type  = "VnetLocal"
  }

  tags = {
    environment = "githubcode"
  }
}

resource "azurerm_subnet_route_table_association" "rtadd" {
  for_each       = azurerm_subnet.hubsubnets
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.rt.id
}
