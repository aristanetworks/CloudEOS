// Copyright (c) 2021 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.

provider "cloudeos" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

provider "aws" {
  region = var.aws_regions["region2"]
}

locals {
  Edge1 = "${var.topology}-CloudEOSEdge1"
  Edge2 = "${var.topology}-CloudEOSEdge2"
}

// Topology Resources
resource "cloudeos_topology" "topology" {
  topology_name         = var.topology
  bgp_asn               = "65200-65300"             // Range of BGP ASNs used for topology
  vtep_ip_cidr          = var.vtep_ip_cidr          // CIDR block for VTEP IPs on veos
  terminattr_ip_cidr    = var.terminattr_ip_cidr    // Loopback IP range on veos
  dps_controlplane_cidr = var.dps_controlplane_cidr // CIDR block for Dps Control Plane IPs on veos
}

resource "cloudeos_clos" "clos" {
  name              = "${var.topology}-clos"
  topology_name     = cloudeos_topology.topology.topology_name
  cv_container_name = var.clos_cv_container
}

resource "cloudeos_wan" "wan" {
  name              = "${var.topology}-wan"
  topology_name     = cloudeos_topology.topology.topology_name
  cv_container_name = var.wan_cv_container
}

//Region2 Edge VPC and CloudEOS
module "EdgeVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  wan_name      = "${var.topology}-wan"
  role          = "CloudEdge"
  igw_name      = "${var.topology}-VpcIgw"
  cidr_block    = [(var.vpc_info["edge_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-EdgeVpc"
  }
  region      = var.aws_regions["region2"]
  topology_id = cloudeos_topology.topology.tf_id
  wan_id      = cloudeos_wan.wan.tf_id
  clos_id     = cloudeos_clos.clos.tf_id
  default_ingress_sg_cidrs = var.ingress_allowlist["edge_vpc"]["default"]
  ssh_security_group_cidrs = var.ingress_allowlist["edge_vpc"]["ssh"]
}

module "EdgeSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["edge_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.EdgeVpc.region]["zone1"]
    (var.vpc_info["edge_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.EdgeVpc.region]["zone1"]
    (var.vpc_info["edge_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.EdgeVpc.region]["zone2"]
    (var.vpc_info["edge_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.EdgeVpc.region]["zone2"]
  }
  subnet_names = {
    (var.vpc_info["edge_vpc"]["subnet_cidr"][0]) = "${var.topology}-EdgeSubnet0"
    (var.vpc_info["edge_vpc"]["subnet_cidr"][1]) = "${var.topology}-EdgeSubnet1"
    (var.vpc_info["edge_vpc"]["subnet_cidr"][2]) = "${var.topology}-EdgeSubnet2"
    (var.vpc_info["edge_vpc"]["subnet_cidr"][3]) = "${var.topology}-EdgeSubnet3"
  }
  vpc_id        = module.EdgeVpc.vpc_id[0]
  topology_name = module.EdgeVpc.topology_name
  region        = module.EdgeVpc.region
}

module "CloudEOSEdge1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.EdgeVpc.topology_name
  cloudeos_ami  = local.eos_amis[module.EdgeVpc.region]
  keypair_name  = var.keypair_name[module.EdgeVpc.region]
  vpc_info      = module.EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Edge1Intf0", "${var.topology}-Edge1Intf1"]
  interface_types = {
    "${var.topology}-Edge1Intf0" = "public"
    "${var.topology}-Edge1Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Edge1Intf0" = module.EdgeSubnet.vpc_subnets[0]
    "${var.topology}-Edge1Intf1" = module.EdgeSubnet.vpc_subnets[1]
  }
  private_ips       = { "0" : [(var.vpc_info["edge_vpc"]["interface_ips"][0])] , "1" : [(var.vpc_info["edge_vpc"]["interface_ips"][1])] }
  availability_zone = var.availability_zone[module.EdgeVpc.region]["zone1"]
  region            = module.EdgeVpc.region
  tags = {
    "Name" = local.Edge1
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "CloudEOSEdge2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.EdgeVpc.topology_name
  cloudeos_ami  = local.eos_amis[module.EdgeVpc.region]
  keypair_name  = var.keypair_name[module.EdgeVpc.region]
  vpc_info      = module.EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Edge2Intf0", "${var.topology}-Edge2Intf1"]
  interface_types = {
    "${var.topology}-Edge2Intf0" = "public"
    "${var.topology}-Edge2Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Edge2Intf0" = module.EdgeSubnet.vpc_subnets[2]
    "${var.topology}-Edge2Intf1" = module.EdgeSubnet.vpc_subnets[3]
  }
  private_ips       = { "0" : [(var.vpc_info["edge_vpc"]["interface_ips"][2])], "1" : [(var.vpc_info["edge_vpc"]["interface_ips"][3])] }
  availability_zone = var.availability_zone[module.EdgeVpc.region]["zone2"]
  region            = module.EdgeVpc.region
  tags = {
    "Name" = local.Edge2
  }
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  public_route_table_id   = module.CloudEOSEdge1.route_table_public
  internal_route_table_id = module.CloudEOSEdge1.route_table_internal
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}

//Leaf VPCs to TGW
module "Leaf1DevTgwVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["leaf1_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Leaf1DevTgwVpc"
    Cnps = "dev"
  }
  region      = var.aws_regions["region2"]
  vpc_peering = false
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf1DevSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
   (var.vpc_info["leaf1_vpc"]["subnet_cidr"][0])  = var.availability_zone[module.Leaf1DevTgwVpc.region]["zone1"]
  }
  subnet_names = {
    (var.vpc_info["leaf1_vpc"]["subnet_cidr"][0]) = "${var.topology}-Leaf1Subnet0"
  }
  vpc_id        = module.Leaf1DevTgwVpc.vpc_id[0]
  topology_name = module.Leaf1DevTgwVpc.topology_name
  region        = module.Leaf1DevTgwVpc.region
}

module "TgwDevLeaf1host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[var.aws_regions["region2"]]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[var.aws_regions["region2"]]
  subnet_id     = module.Leaf1DevSubnet.vpc_subnets[0]
  private_ips   = [(var.vpc_info["leaf1_vpc"]["interface_ips"][0])]
  tags = {
    "Name" = "${var.topology}-TgwLeaf1DevHost1"
  }
}

module "Leaf2ProdTgwVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["leaf2_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Leaf2ProdTgwVpc"
    Cnps = "prod"
  }
  region      = var.aws_regions["region2"]
  vpc_peering = false
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf2ProdTgwSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["leaf2_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Leaf2ProdTgwVpc.region]["zone1"]
  }
  subnet_names = {
    (var.vpc_info["leaf2_vpc"]["subnet_cidr"][0]) = "${var.topology}-Leaf2Subnet0"
  }
  vpc_id        = module.Leaf2ProdTgwVpc.vpc_id[0]
  topology_name = module.Leaf2ProdTgwVpc.topology_name
  region        = module.Leaf2ProdTgwVpc.region
}

module "TgwProdLeaf4host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[var.aws_regions["region2"]]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[var.aws_regions["region2"]]
  subnet_id     = module.Leaf2ProdTgwSubnet.vpc_subnets[0]
  private_ips   = [(var.vpc_info["leaf2_vpc"]["interface_ips"][0])]
  tags = {
    "Name" = "${var.topology}-TgwLeaf2ProdHost1"
  }
}

//TGW, TGW VPC attachments and VPN
module "tgw" {
  source        = "../../../module/cloudeos/aws/tgw"
  cnps          = ["dev", "prod"]
  cloudeos_cnps = false
  region        = var.aws_regions["region2"]
  tags = {
    "Name" = "${var.topology}-tgw"
  }
}

module "tgwDev" {
  source                = "../../../module/cloudeos/aws/tgwcnps"
  tgw_id                = module.tgw.tgw_id
  router_info           = [module.CloudEOSEdge1.router_info, module.CloudEOSEdge2.router_info]
  cnps                  = module.tgw.tgw_cnps[0]
  cnps_route_table_info = module.tgw.tgw_rttable_id[0]
  bandwidth_gbps        = 1
  vpc_id                = module.EdgeVpc.vpc_id[0]
  region                = var.aws_regions["region2"]
  vpc_attach_vpcs       = [module.Leaf1DevTgwVpc.vpc_id[0]]
  vpc_attach_subnets    = [module.Leaf1DevSubnet.vpc_subnets[0]]
  create_vpn            = false // An external script will create GRE tunnel
}

module "tgwProd" {
  source                = "../../../module/cloudeos/aws/tgwcnps"
  tgw_id                = module.tgw.tgw_id
  cnps                  = module.tgw.tgw_cnps[1]
  router_info           = [module.CloudEOSEdge1.router_info, module.CloudEOSEdge2.router_info]
  cnps_route_table_info = module.tgw.tgw_rttable_id[1]
  bandwidth_gbps        = 2
  vpc_id                = module.EdgeVpc.vpc_id[0]
  region                = var.aws_regions["region2"]
  vpc_attach_vpcs       = [module.Leaf2ProdTgwVpc.vpc_id[0]]
  vpc_attach_subnets    = [module.Leaf2ProdTgwSubnet.vpc_subnets[0]]
  create_vpn            = false // An external script will create GRE tunnel
}

// Point default route to TGW in order to be able to route traffic to and from host VPCs
data "aws_route_table" "Leaf1DevTgwRt" {
  vpc_id = module.Leaf1DevTgwVpc.vpc_id[0]
}

resource "aws_route" "Leaf1DevTgwRoute" {
  route_table_id            = data.aws_route_table.Leaf1DevTgwRt.id
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id = module.tgw.tgw_id
}

data "aws_route_table" "Leaf2ProdTgwRt" {
  vpc_id = module.Leaf2ProdTgwVpc.vpc_id[0]
}

resource "aws_route" "Leaf2ProdTgwRoute" {
  route_table_id            = data.aws_route_table.Leaf2ProdTgwRt.id
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id = module.tgw.tgw_id
}

// Outputs for use in Creating AWS Connect
output python_path {
  value = { "python_path" : "/usr/bin/python3" }
}
output cvaas_server {
  value = { "cvaas_server": var.cvaas["server"] }
}
output cvaas_service_account_token {
  value = { "cvaas_service_account_token": var.cvaas["service_token"] }
}
output connect_vpc_subnet_id {
  value = { "Edge1": module.EdgeSubnet.vpc_subnets[1], "Edge2": module.EdgeSubnet.vpc_subnets[3] }
}
output connect_vpc_subnet_route_table_id {
  value = { "Edge1": module.CloudEOSEdge1.route_table_internal, "Edge2": module.CloudEOSEdge2.route_table_internal }
}
output underlay_ip {
  value = { "Edge1": element(tolist(lookup(module.CloudEOSEdge1.intf_private_ips, lookup(module.CloudEOSEdge1.intfname_to_id, "${var.topology}-Edge1Intf1"))), 0),
            "Edge2": element(tolist(lookup(module.CloudEOSEdge2.intf_private_ips, lookup(module.CloudEOSEdge2.intfname_to_id, "${var.topology}-Edge2Intf1"))), 0) }
}
output bgp_asn {
  value = { "Edge1": module.CloudEOSEdge1.router_info[2], "Edge2": module.CloudEOSEdge2.router_info[2] }
}
output bgp_peering_cidr {
  value = { "Edge1": { "dev": "169.254.6.0/29", "prod": "169.254.6.8/29" }, "Edge2": { "dev": "169.254.6.16/29", "prod": "169.254.6.32/29" } }
}

output aws_region {
  value = { "aws_region": module.EdgeVpc.region }
}
output connect_vpc_id {
  value = { "connect_vpc_id": module.EdgeVpc.vpc_info[0][0] }
}
output tgw_id {
  value = { "tgw_id": module.tgw.tgw_id }
}
output tgw_cidr {
  value = { "tgw_cidr": "1.1.1.0/24" }
}
output tag_prefix {
  value = { "tag_prefix": "tgw-connect-exp" }
}
output segments {
  value = { "segments": module.tgw.tgw_cnps }
}
output tgw_route_table_id {
  value = { "tgw_route_table_id" : { "dev": module.tgw.tgw_rttable_id[0], "prod": module.tgw.tgw_rttable_id[1] } }
}
output EdgeNames {
  value = { "Edge1" : local.Edge1, "Edge2" : local.Edge2 }
}
