variable "vnet_name" {
  description = "Name of the vnet to create"
}

variable "rg_name" {
  description = "Default resource group name that the network will be created in."
}

variable "tags" {
  description = "Tags for the vnet"
  type        = map(string)
  default     = {}
}

variable "nsg_name" {
  description = "nsg name"
  default     = ""
}

variable "peer_name" {
  default = "VNETPeering"
}

variable "role" {
  default = ""
}

variable "overlay_connection_type" {
  description = "Overlay connection type: dps/vxlan/dps"
  type        = string
  default     = "dps"
}

variable "peervpccidr" {
  default = ""
}

variable "peerrgname" {
  default = ""
}

variable "peervnetname" {
  default = ""
}
variable "topology_name" {
  default = ""
}
variable "availability_set" {
  default = false
}

variable "clos_name" {
  default = ""
}

variable "wan_name" {
  default = ""
}

variable "topology_id" {
  description = "TF ID of the cloudeos_topology resource"
  default     = ""
}

variable "wan_id" {
  description = "TF ID of the cloudeos_wan resource"
  default     = ""
}

variable "clos_id" {
  description = "TF ID of the cloudeos_clos resource"
  default     = ""
}
