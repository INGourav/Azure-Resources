locals {
  common_tags = {
    BuildDate   = 20200623
    Environment = "WVD"
    BuildBy     = "Gourav Kumar"
  }
}

variable "location" {
  description = "Location of WVD resources"
  default     = "eastus2"
}

variable "vnetrg" {
  default = "vnet-rg"
}

variable "hprg" {
  default = "wvd-hp-ag-rg"
}

variable "wvdwksrg" {
  default = "wvd-wks-rg"
}
variable "vmrg" {
  default = "wvd-vm-rg"
}

variable "adrg" {
  default = "ad-vm-rg"
}

variable "strrg" {
  default = "str-wvd-rg"
}

variable "vnetname" {
  default = "wvd-vnet01"
}


variable "vnet_address_space" {
  description = "address range for vnet."
  default     = ["10.0.0.0/16"]
}

variable "wvd_subnet_name" {
  description = "Name of the wvd subnet"
  default     = "wvdsubnet"
}

variable "wvd_subnet_range" {
  description = "IP range for wvd subnet"
  default     = ["10.0.0.0/24"]
}

variable "ad_subnet_name" {
  description = "Name of the wvd subnet"
  default     = "adsubnet"
}

variable "ad_subnet_range" {
  description = "IP range for wvd subnet"
  default     = ["10.0.1.0/24"]
}

variable "ad_subnet_range_nsg" {
  description = "IP range for wvd subnet nsg as string needed"
  default     = "10.0.1.0/24"
}

variable "fsstrname" {
  description = "Name of the file share storage name"
  default     = "wvdtestfsag01"
}

variable "hpname" {
  default = "wvdhp01"
}

variable "appgname" {
  default = "wvdag01"
}

variable "wkspacename" {
  default = "wvdws01"
}

