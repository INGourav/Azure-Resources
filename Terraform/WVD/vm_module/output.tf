output "nic" {
  value = azurerm_network_interface.loc-env-vm-nic
}

output "vm" {
  value = azurerm_virtual_machine.loc-env-vm
}