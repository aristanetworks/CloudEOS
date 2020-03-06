variable "tags" {
  description = "Tags for the new VPC"
  type        = map(string)
  default     = {}
}

variable "cidr_block" {
  description = "CIDR block"
  type        = list(string)
  default = []
}

variable "igw_name" {
  description = "Name of the internet gw"
  default = ""
}

variable "create_vpc" {
  default = true
}

variable "create_igw" {
  default = false
}

variable "role" {
  description = "CloudEdge/CloudSpine/CloudLeaf"
  type = string
  default = ""
}

variable "peer_vpc_id" {
  default = ""
}

variable "region" {
  default = ""
}

variable "topology_name" {
  default = ""
}

variable "clos_name" {
  default = ""
}

variable "wan_name" {
  default = ""
}

variable "igw_id" {
  description = "Internet Gateway ID"
  default = ""
}
variable "sg_id" {
  description = "Security group ID"
  default = ""
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default = ""
}
variable "vpc_id" {
  default = ""
}
