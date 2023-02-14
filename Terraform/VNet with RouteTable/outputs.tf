output "vnetname_out" {
    value = azurerm_virtual_network.vnet.name
}

output "vnet_location" {
    value = azurerm_virtual_network.vnet.location
}

output "vnet_addresspace" {
    value = azurerm_virtual_network.vnet.address_space
}
    
output "subnet_name" {
  value = {
      for id in keys(var.subnet_name) : id => azurerm_subnet.hubsubnets[id].id
  }
}
    
output "nsg_name" {
    value = azurerm_network_security_group.nsg.name
}
    
output "nsg_id" {
    value = azurerm_network_security_group.nsg.id
}
