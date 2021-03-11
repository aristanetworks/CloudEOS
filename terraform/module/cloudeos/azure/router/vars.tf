variable "cloud_provider" {
  description = "aws, azure or gcp"
  type        = string
  default     = "azure"
}

variable "cv_container" {
  description = "container to which cvp should add this device"
  default     = ""
  type        = string
}

variable "instance_type" {
  default = "Sandard_D3_v2"
  type    = string
}

variable "intf_names" {
  description = "A list of interfaces on the VM"
  type        = list(string)
}

variable "vm_names" {
  description = "Names of the VMs to be created."
  type        = list(string)
  default     = []
}

variable "disk_name" {
  description = "Network security group name"
}

variable "subnetids" {
  description = "Map of interfaces to SubnetIds"
  type        = map(string)
}

variable "storage_name" {
  description = "Name of the storage block"
}

variable "vnet_name" {
  description = "Name of the vnet"
  default     = ""
}

variable "vnet_id" {
  description = "Vnet unique identifier"
  default     = ""
}

variable "rg_location" {
  description = "Location of the resource group"
  default     = ""
}

variable "rg_name" {
  description = "Name of the resource group"
  default     = ""
}

variable "nsg_id" {
  default     = ""
  description = "Network security group id"
}

variable "publicip_name" {
  description = "public IP Name"
  default     = ""
}

variable "availability_zone" {
  description = "availability zone"
  default     = []
}

variable "availability_set_id" {
  default     = ""
  description = "Availability set id"
}

variable "routetable_name" {
  description = "route table name"
}

variable "route_name" {
  description = "route name"
}

variable "interface_types" {
  description = "interface type map"
  type        = map(string)
}

variable "private_ips" {
  description = "List of interface IPs. First IP in the list will be considered as primary."
  default = {}
}
variable "tags" {
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "role" {
  description = "CloudLeaf/CloudEdge/CloudSpine"
  default     = ""
}

variable "peer_connection_id" {
  default = ""
}

variable "cloud_ha" {
  default = ""
}

variable "primary" {
  default = "false"
}

variable "filename" {
  default = "../userdata/eos_ipsec_config.tpl"
}

variable "topology_name" {
  default = ""
}

variable "is_rr" {
  default = false
}

variable "vpc_info" {
  default = []
}

variable "cloudeos_image_version" {
  description = "CloudEOS Image version"
}

variable "cloudeos_image_name" {
  description = "CloudEOS Image sku"
}

variable "cloudeos_image_offer" {
  description = "CloudEOS Image sku"
}


variable "existing_userdata" {
  default = false
}

variable "admin_username" {}
variable "admin_password" {}
variable "ilb_intf" {
  default = ""
}
variable "backend_pool" {
  default = ""
}

variable "frontend_ilb_ip" {
  default = ""
}

variable "vm_size" {
  default = "Standard_D2_v2"
}