variable "vnet_name" {
  description = "Name of the vnet to create"
}

variable "vnet_id" {
  description = "Vnet unique identifier"
}

variable "rg_name" {
  description = "Default resource group name that the network will be created in."
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
}

variable "cloud_provider" {
  description = "aws, azure or gcp"
  type        = string
  default     = "azure"
}

variable "topology_name" {
  default = ""
}