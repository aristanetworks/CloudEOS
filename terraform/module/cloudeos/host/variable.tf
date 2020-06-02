variable "rg_location" {
  description = "Location of the resource group"
  type = string
}

variable "rg_name" {
  description = "Name of the resource group"
  type = string
}

variable "intf_name" {
  type = string
}

variable "zone" {
  description = "Zone for the host VM"
  default = 2
}

variable "subnet_id" {
  type = string
}

variable "private_ip" {
  type = string
}

variable "tags" {
  type = map
  default = {}
}

variable "disk_name" {
  type = string
}