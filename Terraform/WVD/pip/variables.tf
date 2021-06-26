variable "environment" {
  description = "Production, Development, etc"
}

variable "tag_buildby" {
  description = "Racker that built the resource."
}

variable "tag_builddate" {
  description = "Date in ISO-8601 format (yyyymmdd)."
}

variable "pip_count" {
  description = "How many Public IPs to create."
  default     = 1
}

variable "pip_count_start" {
  description = "Start counting from what number."
  default     = 1
}

variable "pip_count_zero_padding" {
  description = "Zero pad by how many columns. A value of 1 effetively means no padding. A value of 2 means 01, 02, 03, etc. A value of 3 means 001, 002, 003, etc. A value of 0 disables number prefixing and only a single resource can be created."
  default     = 0
}

variable "name" {
  description = "Name of the Virtual Network Gateway."
}

variable "pip_rsg" {
  description = "Name of the Resource Group that will contain the Virtual Network Gateway."
}

variable "location" {
  description = "Region to deploy into."
}

variable "pip_sku" {
  description = "Either Basic or Standard."
}

variable "allocation" {
  description = "Either Dynamic or Static."
  default     = "Static"
}