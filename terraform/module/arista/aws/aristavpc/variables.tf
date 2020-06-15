variable "tags" {
  description = "Tags for the new VPC"
  type        = map(string)
  default     = {}
}

variable "cidr_block" {
  description = "CIDR block"
  type        = list(string)
  default     = []
}

variable "igw_name" {
  description = "Name of the internet gw"
  default     = ""
}

variable "create_vpc" {
  default = true
}

variable "create_igw" {
  default = false
}

variable "role" {
  description = "CloudEdge/CloudSpine/CloudLeaf"
  type        = string
  default     = ""
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
  default     = ""
}
variable "sg_id" {
  description = "Security group ID"
  default     = ""
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = ""
}
variable "vpc_id" {
  default = ""
}

variable "sg_default_id" {
  default = ""
}

variable "peer_access_key" {
  description = "Access Key for the Peer VPC"
  default     = ""
}

variable "peer_secret_key" {
  description = "Secret Key for the Peer VPC"
  default     = ""
}

variable "peer_session_token" {
  description = "Session token for the Peer VPC"
  default     = ""
}

variable "cross_account_peering" {
  description = "Enable Cross account peering"
  default     = false
}

variable "peer_owner_id" {
  description = "Peer VPC Owners Account ID"
  default     = ""
}
