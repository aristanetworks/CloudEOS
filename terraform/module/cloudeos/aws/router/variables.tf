// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
/* Used in cloudeos_router_config resource */
variable "cv_container" {
  description = "container to which cvp should add this device"
  default     = ""
  type        = string
}

variable "instance_type" {
  default = "c5.xlarge"
  type    = string
}

/* Used by cloudeos_router_config, aws_network_interface and cloudeos_router_status */
variable "vpc_id" {
  description = "vpc id"
  type        = string
  default     = ""
}

variable "vpc_info" {
  default = []
}

/* Used by aws_instance */
variable "cloudeos_ami" {
}

variable tags {
  description = "A mapping of tags to assign to the resource"
}

variable "keypair_name" {
}

variable "intf_names" {
  type = list(string)
}

variable "subnetids" {
  type = map(string)
}

variable "vm_name" {
  default = ""
}

variable "igw_id" {
  default = ""
}

variable "sg_id" {
  default = ""
}

variable "private_ips" {
  default = {}
}

variable "filename" {
  default = "../userdata/eos_ipsec_config.tpl"
}

variable "interface_types" {
  description = "Interface types"
  type        = map(string)
}

variable "cloud_ha" {
  description = "Cloud HA name. Must be same between HA pairs and unique within VPC."
  default     = ""
}

variable "primary_internal_subnetids" {
  description = "Internal subnet IDs of Cloud HA primary node"
  type        = list(string)
  default     = []
}

variable "availability_zone" {
  description = "Availability zone in which the CloudEOS instance is created."
}

variable "role" {
  description = "One of CloudLeaf/CloudEdge/CloudSpine"
  default     = ""
}

variable "peer_connection_id" {
  default = ""
}

variable "peer" {
  default = false
}

variable "public_route_table_id" {
  default = ""
}

variable "internal_route_table_id" {
  default = ""
}

variable "peerroutetableid1" {
  default = []
}

variable "peervpccidr" {
  default = ""
}

variable "topology_name" {
  default = ""
}

variable "primary" {
  default = false
}

variable "region" {
  default = ""
}

variable "is_rr" {
  default = false
}

variable "existing_userdata" {
  default = false
}

variable "iam_instance_profile" {
  description = "Name of the IAM profile the instance is referring to"
  type        = string
  default     = ""
}
variable "peer_vpc_account_info" {
  description = "Peer VPCs account Info"
  //0: cross_account_peering, 1: aws_access_key, 2:aws_secret_key, 3:aws_session_token
  default = [false, "", "", "", ""]
}

variable "intra_az_ha" {
  description = "Support for CloudHA when both Routers are using the same Private subnet"
  default     = false
}
