variable "rg_name" {
  type = string
  description = "Name of rg."
}

variable "location" {
  type = string
  description = "Location of rg and all the resources in the module."
}

variable "vnet_name" {
  type = string
  description = "Name of vnet."
}

variable "vnet_address" {
  type = string
  description = "Address of vnet."
}

variable "subnet_name" {
  type = string
  description = "Name of subnet."
}

variable "subnet_address" {
  type = string
  description = "Address of subnet."
}

variable "vm_name" {
  type = string
  description = "Name of vm."
}

variable "nic_name" {
  type = string
  description = "Name of nic."
}

variable "public_ip_name" {
  type = string
  description = "Name of public ip."
}
