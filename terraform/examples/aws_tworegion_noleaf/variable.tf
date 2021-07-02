// Copyright (c) 2021 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
variable "topology" {}
variable "keypair_name" {}
variable "cvaas" {}
variable "instance_type" {}
variable "aws_regions" {}
variable "eos_amis" {}
variable "availability_zone" {}
variable "host_amis" {}
variable "vtep_ip_cidr" {}
variable "terminattr_ip_cidr" {}
variable "dps_controlplane_cidr" {}
variable "clos_cv_container" {}
variable "wan_cv_container" {}
// SW-VPC variables
variable "east1_edge_cidr_block" {}
variable "east1_edge_subnet0" {}
variable "east1_edge_subnet1" {}
variable "east1_edge_subnet2" {}
variable "east1_edge_subnet3" {}
variable "east1_edge_intf0" {}
variable "east1_edge_intf1" {}

variable "east2_edge_cidr_block" {}
variable "east2_edge_subnet0" {}
variable "east2_edge_subnet1" {}
variable "east2_edge_subnet2" {}
variable "east2_edge_subnet3" {}
variable "east2_edge1_intf0" {}
variable "east2_edge1_intf1" {}
variable "east2_edge2_intf0" {}
variable "east2_edge2_intf1" {}

variable "west1_rr_cidr_block" {}
variable "west1_rr_subnet0" {}
variable "west1_rr_intf0" {}
