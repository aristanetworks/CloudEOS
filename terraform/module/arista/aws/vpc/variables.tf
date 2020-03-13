// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
variable "tags" {
  description = "Tags for the new VPC"
  type        = map(string)
  default     = {}
}

variable "cidr_block" {
  description = "CIDR block"
  type        = list(string)
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

variable "overlay_connection_type" {
  description = "Overlay connection type: dps/vxlan/ipsec"
  type        = string
  default     = "dps"
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