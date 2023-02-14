output "nsg_id" {
    value = azurerm_network_security_group.nsg.id
}

output "nsg_name" {
    value = azurerm_network_security_group.nsg.name
}

output "name" {
  value = {
      for id in keys(var.subnet_name) : id => azurerm_subnet.hubsubnets[id].id
  }
}

output "vnetname_out" {
    value = azurerm_virtual_network.vnet.name
}

output "location" {
    value = azurerm_virtual_network.vnet.location
}

output "addresspace" {
    value = azurerm_virtual_network.vnet.address_space
}
