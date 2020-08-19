// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
provider "aws" {
  region = var.region
}

provider "aws" {
  alias      = "peer"
  region     = var.region
  access_key = var.peer_vpc_account_info[1]
  secret_key = var.peer_vpc_account_info[2]
  token      = var.peer_vpc_account_info[3]
}

locals {
  private_intfs           = length(aws_network_interface.allIntfs.*.id) > 0 ? matchkeys(aws_network_interface.allIntfs.*.id, values(var.interface_types), ["private"]) : []
  route_table_id          = length(aws_route_table.route_table_public.*.id) > 0 ? aws_route_table.route_table_public[0].id : var.public_route_table_id
  internal_route_table_id = length(aws_route_table.route_table_internal.*.id) > 0 ? aws_route_table.route_table_internal[0].id : var.internal_route_table_id
  private_subnets         = length(aws_network_interface.allIntfs.*.subnet_id) > 0 ? matchkeys(aws_network_interface.allIntfs.*.subnet_id, values(var.interface_types), ["private"]) : []
  public_subnets          = length(aws_network_interface.allIntfs.*.subnet_id) > 0 ? matchkeys(aws_network_interface.allIntfs.*.subnet_id, values(var.interface_types), ["public"]) : []
  internal_subnets        = length(aws_network_interface.allIntfs.*.subnet_id) > 0 ? matchkeys(aws_network_interface.allIntfs.*.subnet_id, values(var.interface_types), ["internal"]) : []
  local_vpc_cidr          = var.vpc_info != [] ? var.vpc_info[4][0] : ""
  vpc_id                  = var.vpc_info != [] ? length(var.vpc_info[0]) > 0 ? var.vpc_info[0][0] : var.vpc_id : var.vpc_id
  sg_id                   = var.vpc_info != [] ? length(var.vpc_info[2]) > 0 ? var.vpc_info[2] : [var.sg_id] : [var.sg_id]
  igw_id                  = var.vpc_info != [] ? length(var.vpc_info[1]) > 0 ? var.vpc_info[1][0] : var.igw_id : var.igw_id
  peering_id              = var.vpc_info != [] ? length(var.vpc_info[3]) > 0 ? var.vpc_info[3][0] : var.peer_connection_id : var.peer_connection_id
  peer_vpc_cidr           = var.vpc_info != [] ? length(var.vpc_info[6]) > 0 ? var.vpc_info[6][0] : "0.0.0.0/0" : "0.0.0.0/0"
  public_intf_num         = length(matchkeys(keys(var.interface_types), values(var.interface_types), ["public"]))
  private_intf_num        = length(matchkeys(keys(var.interface_types), values(var.interface_types), ["private"]))
  internal_intf_num       = length(matchkeys(keys(var.interface_types), values(var.interface_types), ["internal"]))
  sg_default_id           = var.vpc_info != [] ? length(var.vpc_info[7]) > 0 ? var.vpc_info[7] : [var.sg_id] : [var.sg_id]
}

resource "aws_eip" "eip" {
  count             = local.public_intf_num
  vpc               = true
  network_interface = aws_network_interface.allIntfs.*.id[index(var.intf_names, matchkeys(keys(var.interface_types), values(var.interface_types), ["public"])[count.index])]
  depends_on        = [aws_instance.cloudeosVm]
}

resource "aws_network_interface" "allIntfs" {
  count             = length(var.intf_names)
  subnet_id         = values(var.subnetids)[count.index]
  source_dest_check = false
  security_groups   = count.index == 0 ? local.sg_id : null
  private_ips       = lookup(var.private_ips, tostring(count.index), null)
}

resource "aws_route_table" "route_table_public" {
  count  = var.primary && var.is_rr == false ? local.public_intf_num : 0
  vpc_id = local.vpc_id
}

resource "aws_route_table" "route_table_private" {
  count  = var.role != "none" && local.private_intf_num > 0 ? 1 : 0
  vpc_id = local.vpc_id
}

resource "aws_route" "lan_default_route" {
  count                  = local.private_intf_num
  route_table_id         = aws_route_table.route_table_private[0].id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = local.private_intfs[count.index]
}

resource "aws_route_table" "route_table_internal" {
  count  = var.primary ? local.internal_intf_num : 0
  vpc_id = local.vpc_id
}

resource "aws_route" "wan_default_route" {
  count                     = var.primary && var.is_rr == false ? var.topology_name != "" ? local.public_intf_num : var.peervpccidr != "" ? local.public_intf_num : 0 : 0
  destination_cidr_block    = var.topology_name != "" ? local.peer_vpc_cidr : var.peervpccidr
  route_table_id            = local.route_table_id
  gateway_id                = var.role == "CloudEdge" ? local.igw_id : null
  vpc_peering_connection_id = var.role == "CloudLeaf" ? local.peering_id : null
}

resource "aws_route" "internal_default_route" {
  count                     = var.primary && var.role == "CloudLeaf" ? var.topology_name != "" ? local.internal_intf_num : var.peervpccidr != "" ? local.internal_intf_num : 0 : 0
  destination_cidr_block    = var.topology_name != "" ? local.peer_vpc_cidr : var.peervpccidr
  route_table_id            = local.internal_route_table_id
  vpc_peering_connection_id = local.peering_id
}

//Every Private Interface has its own route table. We associate different routes to every route table
//based on the next hop Private ENI.
resource "aws_route_table_association" "route_map_private" {
  count          = var.intra_az_ha == false ? local.private_intf_num : 0
  route_table_id = aws_route_table.route_table_private.*.id[count.index]
  subnet_id      = local.private_subnets[count.index]
}

//Internal interfaces on a Leaf will only create a route table for the primary. For secondary cloudeos
//instances, we use the route table created by the primary cloudeos. But, we still need to associate the
//route table to the subnet.
//RR shouldn't have an internal Interface
resource "aws_route_table_association" "route_map_internal" {
  count          = var.intra_az_ha == false ? local.internal_intf_num : 0
  route_table_id = local.internal_route_table_id
  subnet_id      = local.internal_subnets[count.index]
}

resource "aws_route_table_association" "route_map_public" {
  //count = var.role != "none" ? length(matchkeys(keys(var.interface_types), values(var.interface_types), ["public", "internal"])) : 0
  count          = var.role != "none" && var.is_rr == false ? local.public_intf_num : 0
  route_table_id = local.route_table_id
  subnet_id      = local.public_subnets[count.index]
}
/*
data "template_file" "user_data" {
  template = file(var.filename)
  vars = {
    ip            = length(matchkeys(keys(var.interface_types), values(var.interface_types), ["public"])) > 0 ? aws_eip.eip[0].public_ip : ""
    vmname        = length([for i,z in var.tags: i if i == "Name"]) > 0 ? var.tags["Name"] : ""
    password      = "arastra1234!"
    tunnelip      = var.tunnelip
  }
}
*/

data "template_file" "user_data_precreated" {
  count    = var.existing_userdata == true ? 1 : 0
  template = file(var.filename)
}

data "template_file" "user_data_specific" {
  count    = var.existing_userdata == false ? 1 : 0
  template = file(var.filename)
  vars = {
    bootstrap_cfg = cloudeos_router_config.router[0].bootstrap_cfg
  }
}

resource "aws_instance" "cloudeosVm" {
  ami                                  = var.cloudeos_ami
  availability_zone                    = var.availability_zone
  instance_type                        = var.instance_type
  instance_initiated_shutdown_behavior = "stop"
  key_name                             = var.keypair_name

  network_interface {
    network_interface_id = aws_network_interface.allIntfs[0].id
    device_index         = 0
  }
  user_data = var.existing_userdata == false ? data.template_file.user_data_specific[0].rendered : data.template_file.user_data_precreated[0].rendered
  //user_data = cloudeos_router_config.router[0].bootstrap_cfg
  tags                 = var.tags
  iam_instance_profile = var.iam_instance_profile
}

resource "aws_network_interface_attachment" "secondary_intf" {
  count                = length(var.intf_names) - 1
  instance_id          = aws_instance.cloudeosVm.id
  network_interface_id = aws_network_interface.allIntfs.*.id[count.index + 1]
  device_index         = count.index + 1
  depends_on           = [aws_instance.cloudeosVm]
}

//Only supporting hub-spoke for now. With full-mesh we would need a different way of figuring out the count.
resource "aws_route" "peering_route_cross" {
  provider = aws.peer
  count    = var.role == "CloudLeaf" && var.primary && var.peer_vpc_account_info[0] == true ? var.topology_name != "" ? 1 : var.peerroutetableid1 != [] ? 1 : 0 : 0
  //route_table_id = var.topology_name != "" ? tolist(cloudeos_router_config.router[0].peerroutetableid1)[count.index] : var.peerroutetableid1[count.index]
  route_table_id            = tolist(cloudeos_router_config.router[0].peerroutetableid1)[0]
  destination_cidr_block    = local.local_vpc_cidr
  vpc_peering_connection_id = local.peering_id
}

resource "aws_route" "peering_route" {
  count = var.role == "CloudLeaf" && var.primary && var.peer_vpc_account_info[0] == false ? var.topology_name != "" ? 1 : var.peerroutetableid1 != [] ? 1 : 0 : 0
  //route_table_id = var.topology_name != "" ? tolist(cloudeos_router_config.router[0].peerroutetableid1)[count.index] : var.peerroutetableid1[count.index]
  route_table_id            = tolist(cloudeos_router_config.router[0].peerroutetableid1)[0]
  destination_cidr_block    = local.local_vpc_cidr
  vpc_peering_connection_id = local.peering_id
}

//RR Specific Resources
resource "aws_route_table" "rr_route_table_public" {
  count  = var.is_rr == true && var.role == "CloudEdge" && var.primary ? 1 : 0
  vpc_id = local.vpc_id
}

resource "aws_route" "rr_wan_default_route" {
  count                  = var.is_rr && var.role == "CloudEdge" && var.primary ? 1 : 0
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.rr_route_table_public[0].id
  gateway_id             = local.igw_id
}

resource "aws_route_table_association" "rr_route_map_public" {
  count          = var.is_rr == true && var.role == "CloudEdge" ? local.public_intf_num : 0
  route_table_id = aws_route_table.rr_route_table_public[0].id
  subnet_id      = local.public_subnets[count.index]
}

resource "aws_vpc_endpoint" "endpoint" {
  count               = (var.cloud_ha != "" && var.primary == false) ? 1 : 0
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = local.sg_default_id
  subnet_ids          = concat(var.primary_internal_subnetids, local.internal_subnets)
  private_dns_enabled = true
}

resource "aws_customer_gateway" "routerVpnGw" {
  count      = var.remote_vpn_gateway ? 1 : 0
  bgp_asn    = cloudeos_router_status.router[0].router_bgp_asn
  ip_address = cloudeos_router_status.router[0].public_ip
  type       = "ipsec.1"

  tags = {
    Name = format("Customer GW: %v", cloudeos_router_status.router[0].public_ip)
  }
}
