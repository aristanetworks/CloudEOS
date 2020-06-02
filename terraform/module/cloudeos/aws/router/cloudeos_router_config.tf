// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
locals {
  private_ip = [for i in values(var.private_ips) : i[0]]
}

resource "cloudeos_router_config" "router" {
  count             = length(values(var.subnetids)) != 0 && var.topology_name != "" ? 1 : 0
  cloud_provider    = "aws"
  topology_name     = var.topology_name // ListTopology will get us clos_name, wan_name
  role              = var.role
  cnps              = lookup(var.tags, "Cnps", "")
  vpc_id            = var.vpc_info[0][0] //ListVpc will get us the router role and region
  tags              = var.tags           //tags should have the router name
  region            = var.region
  is_rr             = var.is_rr
  ami               = var.cloudeos_ami
  key_name          = var.keypair_name
  availability_zone = var.availability_zone
  intf_name         = var.intf_names
  //Only sending the first IP address of the list.
  intf_private_ip = local.private_ip
  intf_type       = values(var.interface_types)
}
