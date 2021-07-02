module "advm01" {
  source = ".//vm_module"

  vm_count              = 1
  vm_count_start        = 1
  vm_count_zero_padding = 2 # Set to 0 to create a single server with no number suffix

  vm_rsg_name     = azurerm_resource_group.advm.name
  vm_subnet_id    = azurerm_subnet.ad.id
  vm_name         = "advm-"
  vm_size         = "Standard_B2s"
  vm_disk_sku     = "Premium_LRS"
  vm_os_disk_size = 128

  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2019-Datacenter"
  image_version   = "latest"
  # image_id        = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/LOC-ENV-RSG-CODE-SERVICE/providers/Microsoft.Compute/images/locenvcodeapp-image-20200423110050"
  os_type = "Windows" # Either Windows or Linux

  # Uncomment to define static IPs for the NIC
  #
  # nic_private_ip_allocation_method = "Static"
  # nic_private_ip_address           = ["192.168.50.5"]
  vm_pip_id = [module.pip.outputs[0].id]
  # vm_nic_dns                       = ["dnsname"]
  # vm_nic_accelerate                = false

  # Uncomment to define either an Availability Set or Availability Zone.
  # For zones, define which zones to create the VM(s) in. Will loop in ascending order (eg. 1, 2, 3, 1, 2, 3)
  #
  # vm_avset_id = data.azurerm_availability_set.name.id
  # vm_avzones  = ["1", "2", "3"]

  # Uncomment to define additional data disks.
  # See vm_server_disks.tf to add disks.
  #
  drive_list = var.data_drives

  # Uncomment to set timezone away from default of UTC.
  # Uncomment to enable boot diagnostics.
  # Uncomment to set a custom admin username other than the default <servername>-adm.
  #
  # vm_timezone     = var.vm_timezone
  # vmdiag_sa       = data.azurerm_storage_account.diagnostics.primary_blob_endpoint
  # admin_username  = "custom-name"

  admin_password = random_string.password_vm.result
  location       = var.location
  environment    = "WVD"
  buildby        = "Gourav Kumar"
  builddate      = 20200623
}


variable "data_drives" {
  description = "List of objects that will create additional drives on the VM(s)."
  type = map(object({
    lun                       = number
    caching                   = string
    disk_size_gb              = number
    write_accelerator_enabled = bool
    managed_disk_type         = string
  }))

  default = {
    1 = {
      lun                       = 1
      caching                   = "ReadOnly"
      disk_size_gb              = 32
      write_accelerator_enabled = false
      managed_disk_type         = "Premium_LRS"
    }
    # 2 = {
    #   lun                       = 2
    #   caching                   = "None"
    #   disk_size_gb              = 128
    #   write_accelerator_enabled = false
    #   managed_disk_type         = "Premium_LRS"
    # }
  }
}