variable "resourcegroupname" {
  type        = string
  description = "Name of the Virtual Network ResourceGroup"
  default     = "demovnetrg"
}

variable "vnetname" {
  type        = string
  description = "Name of the Virtual Network"
  default     = "demovnet"
}

variable "location" {
  type        = string
  description = "The location of the deployment"
  default     = "uk south"
}

variable "cidr" {
  type        = list(string)
  description = "CIDR block of the Vnet"
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type = map(object({
    name = string
    cidr = list(string)
  }))
  default = {
    "subnet1" = {
      name = "subnet1"
      cidr = ["10.0.1.0/24"]
    },
    "subnet2" = {
      name = "subnet2"
      cidr = ["10.0.2.0/24"]
    }
  }
}

variable "nsgname" {
  type        = string
  description = "NSG name for subnet"
  default     = "demonsg"
}

variable "routetablename" {
  type        = string
  description = "NSG name for route table"
  default     = "demort"
}

variable "routename" {
  type        = string
  description = "Name of the route for route table"
  default     = "route1"
}

variable "routeaddressprefix" {
  type        = string
  description = "Address prefix for route table"
  default     = "10.1.0.0/16"
}

variable "nexthop" {
  type        = string
  description = "Next hop for route table"
  default     = "VnetLocal"
}
