resource "azurerm_network_interface" "loc-env-vm-nic" {
  count = var.vm_count_zero_padding == 0 ? 1 : var.vm_count

  name                          = var.vm_count_zero_padding == 0 ? join("", [var.vm_name, "-nic"]) : join("", [var.vm_name, format(join("", ["%0", var.vm_count_zero_padding, "d"]), count.index + var.vm_count_start), "-nic"])
  location                      = var.location
  resource_group_name           = var.vm_rsg_name
  enable_accelerated_networking = var.vm_nic_accelerate
  internal_dns_name_label       = element(var.vm_nic_dns, count.index)

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = var.nic_private_ip_allocation_method
    private_ip_address            = element(var.nic_private_ip_address, count.index)
    public_ip_address_id          = element(var.vm_pip_id, count.index)
  }

  tags = {
    Environment = var.environment
    BuildBy     = var.buildby
    BuildDate   = var.builddate
  }
}

resource "azurerm_virtual_machine" "loc-env-vm" {
  count = var.vm_count_zero_padding == 0 ? 1 : var.vm_count

  name                  = var.vm_count_zero_padding == 0 ? var.vm_name : join("", [var.vm_name, format(join("", ["%0", var.vm_count_zero_padding, "d"]), count.index + var.vm_count_start)])
  location              = var.location
  resource_group_name   = var.vm_rsg_name
  network_interface_ids = [element(azurerm_network_interface.loc-env-vm-nic.*.id, count.index)]
  vm_size               = var.vm_size

  availability_set_id = var.vm_avset_id
  zones               = length(var.vm_avzones) > 0 && var.vm_avset_id == null ? [element(var.vm_avzones, count.index)] : null

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  dynamic "storage_image_reference" {
    for_each = var.image_id == "" ? [1] : []
    content {
      publisher = var.image_publisher
      offer     = var.image_offer
      sku       = var.image_sku
      version   = var.image_version
    }
  }

  dynamic "storage_image_reference" {
    for_each = var.image_id != "" ? [1] : []
    content {
      id = var.image_id
    }
  }

  storage_os_disk {
    name              = var.vm_count_zero_padding == 0 ? join("", [var.vm_name, "-osdisk"]) : join("", [var.vm_name, format(join("", ["%0", var.vm_count_zero_padding, "d"]), count.index + var.vm_count_start), "-osdisk"])
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.vm_disk_sku
    disk_size_gb      = var.vm_os_disk_size
  }

  dynamic "storage_data_disk" {
    for_each = var.drive_list
    content {
      name                      = var.vm_count_zero_padding == 0 ? join("", [var.vm_name, "-data", format("%02d", storage_data_disk.value["lun"])]) : join("", [var.vm_name, format(join("", ["%0", var.vm_count_zero_padding, "d"]), count.index + var.vm_count_start), "-data", format("%02d", storage_data_disk.value["lun"])])
      caching                   = storage_data_disk.value["caching"]
      create_option             = "Empty"
      disk_size_gb              = storage_data_disk.value["disk_size_gb"]
      lun                       = storage_data_disk.value["lun"]
      write_accelerator_enabled = storage_data_disk.value["write_accelerator_enabled"]
      managed_disk_type         = storage_data_disk.value["managed_disk_type"]
    }
  }

  os_profile {
    computer_name  = var.vm_count_zero_padding == 0 ? lower(var.vm_name) : join("", [lower(var.vm_name), format(join("", ["%0", var.vm_count_zero_padding, "d"]), count.index + var.vm_count_start)])
    admin_username = var.admin_username == "" && var.vm_count_zero_padding > 0 ? join("", [lower(var.vm_name), format(join("", ["%0", var.vm_count_zero_padding, "d"]), count.index + var.vm_count_start), "-adm"]) : var.admin_username == "" && var.vm_count_zero_padding == 0 ? join("", [lower(var.vm_name), "-adm"]) : var.admin_username
    admin_password = var.admin_password
  }

  dynamic "os_profile_windows_config" {
    for_each = var.os_type == "Windows" ? [1] : []
    content {
      provision_vm_agent = true
      timezone           = var.vm_timezone
    }
  }

  dynamic "os_profile_linux_config" {
    for_each = var.os_type == "Linux" ? [1] : []
    content {
      disable_password_authentication = false
    }
  }

  boot_diagnostics {
    enabled     = var.vmdiag_sa == "" ? false : true
    storage_uri = var.vmdiag_sa
  }

  tags = {
    Environment             = var.environment
    BuildBy                 = var.buildby
    BuildDate               = var.builddate
  }
}