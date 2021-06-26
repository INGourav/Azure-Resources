variable "environment" {
  description = "Description of the environment the server belongs to (eg. Production)."
}

variable "location" {
  description = "Azure region for the environment."
}

############
# VM Details
############

variable "nic_private_ip_allocation_method" {
  description = "Either Dynamic or Static allocation. Static required nic_private_ip to be set. Dynamic required nic_private_ip to be null."
  default     = "Dynamic"
}

variable "nic_private_ip_address" {
  description = "Private IP to assign the Network Interface Card. Must be set to null if allocation method is Dynamic."
  default     = [null]
}

variable "vm_rsg_name" {
  description = "Resource Group that the VM should go into."
}

variable "vm_name" {
  description = "name for the VMs"
}

variable "vm_size" {
  description = "Size of the VM you want to create"
}

variable "vm_count" {
  description = "Number of VMs to create"
  default     = 1
}

variable "vm_count_zero_padding" {
  description = "Zero pad by how many columns. A value of 1 effetively means no padding. A value of 2 means 01, 02, 03, etc. A value of 3 means 001, 002, 003, etc. A value of 0 disables number prefixing and only a single resource can be created."
  default     = 0
}

variable "vm_count_start" {
  description = "Number to start the count from"
  default     = 1
}

variable "vm_avset_id" {
  description = "Avaialbility Set ID to create the VM in"
  default     = null
}

variable "vm_avzones" {
  description = "Availability Zones to create the VM in"
  default     = []
}

variable "vm_disk_sku" {
  description = "Type of disk to use. Either Standard_LRS or Premium_LRS."
}

variable "vm_timezone" {
  description = "Timezone to set the OS to using Microsoft Tiemzone Index values. See https://support.microsoft.com/en-gb/help/973627/microsoft-time-zone-index-values for values (2nd column)."
  default     = "UTC"
}

variable "os_type" {
  description = "Windows or Linux."
}

variable "image_publisher" {
  description = "Publisher of the OS image."
  default     = ""
}

variable "image_offer" {
  description = "Image offer provided by the publisher."
  default     = ""
}

variable "image_sku" {
  description = "SKU of the image being offered by the publisher."
  default     = ""
}

variable "image_version" {
  description = "Version of the SKU of the image being offered by the publisher."
  default     = "latest"
}

variable "image_id" {
  description = "ID of the image to use if building from an existing image. This takes precedent over a Marketplace image if both are defined."
  default     = ""
}

variable "admin_username" {
  description = "Username for the initial admin user. Leave blank for default of <servername>-adm."
  default     = ""
}

variable "admin_password" {
  description = "password for all VMs"
}

variable "vmdiag_sa" {
  description = "Diagnostics Storage Account endpoint URL"
  default     = ""
}

variable "vm_subnet_id" {
  description = "Subnet ID to attach the VM to."
}

variable "vm_pip_id" {
  description = "Public IP ID to attach to the the Network Interface."
  default     = [null]
}

variable "vm_nic_dns" {
  description = "Internal DNS name to give the NIC"
  default     = [null]
}

variable "vm_os_disk_size" {
  description = "Size of the OS disk."
}

variable "drive_list" {
  description = "List of objects that will create additional drives on the VM(s)."
  type = map(object({
    lun                       = number
    caching                   = string
    disk_size_gb              = number
    write_accelerator_enabled = bool
    managed_disk_type         = string
  }))

  default = {}
}

variable "vm_nic_accelerate" {
  description = "Enable accelerated networking"
  default     = false
}

variable "tag_buildby" {
  description = "Racker that built the resource."
}

variable "tag_builddate" {
  description = "Date in ISO-8601 format (yyyymmdd)."
}

variable "tag_automation_exclude" {
  description = "Automation services to exclude. Comma separated list including Monitoring, Passport, and AntiMalware."
  default     = "None"
}