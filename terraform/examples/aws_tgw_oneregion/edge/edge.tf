// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
provider "cloudeos" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

provider "aws" {
  region = "us-east-1"
}

resource "cloudeos_topology" "topology" {
  topology_name         = var.topology
  bgp_asn               = "65200-65300"             // Range of BGP ASN’s used for topology
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

module "EdgeVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  wan_name      = "${var.topology}-wan"
  role          = "CloudEdge"
  igw_name      = "${var.topology}-VpcIgw"
  cidr_block    = ["100.2.0.0/16"]
  tags = {
    Name = "${var.topology}-EdgeVpc"
  }
  region = var.aws_regions["region2"]
  topology_id = cloudeos_topology.topology.tf_id
  wan_id = cloudeos_wan.wan.tf_id
  clos_id = cloudeos_clos.clos.tf_id
}

module "EdgeSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    "100.2.0.0/24" = var.availability_zone[module.EdgeVpc.region]["zone1"]
    "100.2.1.0/24" = var.availability_zone[module.EdgeVpc.region]["zone1"]
    "100.2.2.0/24" = var.availability_zone[module.EdgeVpc.region]["zone2"]
    "100.2.3.0/24" = var.availability_zone[module.EdgeVpc.region]["zone2"]
  }
  subnet_names = {
    "100.2.0.0/24" = "${var.topology}-EdgeSubnet0"
    "100.2.1.0/24" = "${var.topology}-EdgeSubnet1"
    "100.2.2.0/24" = "${var.topology}-EdgeSubnet2"
    "100.2.3.0/24" = "${var.topology}-EdgeSubnet3"
  }
  vpc_id        = module.EdgeVpc.vpc_id[0]
  topology_name = module.EdgeVpc.topology_name
  region        = module.EdgeVpc.region
}

output EdgePublicIPs {
  value = { "Edge1" : module.CloudEOSEdge1.eip_public, "Edge2" : module.CloudEOSEdge2.eip_public }
}
output edgePrivateIps {
  value = { "Edge1" : module.CloudEOSEdge1.intf_private_ips, "Edge2" : module.CloudEOSEdge2.intf_private_ips }
}

module "CloudEOSEdge1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.EdgeVpc.topology_name
  cloudeos_ami  = var.eos_amis[module.EdgeVpc.region]
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
  private_ips       = { "0" : ["100.2.0.101"], "1" : ["100.2.1.101"] }
  availability_zone = var.availability_zone[module.EdgeVpc.region]["zone1"]
  region            = module.EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-CloudEOSEdge1"
  }
  primary            = true
  filename           = "../../../userdata/eos_ipsec_config.tpl"
  remote_vpn_gateway = true
}

module "CloudEOSEdge2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.EdgeVpc.topology_name
  cloudeos_ami  = var.eos_amis[module.EdgeVpc.region]
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
  private_ips       = { "0" : ["100.2.2.101"], "1" : ["100.2.3.101"] }
  availability_zone = var.availability_zone[module.EdgeVpc.region]["zone2"]
  region            = module.EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-CloudEOSEdge2"
  }
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  public_route_table_id   = module.CloudEOSEdge1.route_table_public
  internal_route_table_id = module.CloudEOSEdge1.route_table_internal
  remote_vpn_gateway      = true
}

module "tgwDev" {
  source                = "../../../module/cloudeos/aws/tgwcnps"
  tgw_id                = "tgw-0a5856fd8cb6fbee6"
  router_info           = [module.CloudEOSEdge1.router_info, module.CloudEOSEdge2.router_info]
  cnps                  = "dev"
  cnps_route_table_info = "tgw-rtb-088aa72341af9060b"
  bandwidth_gbps        = 1
  vpc_id                = module.EdgeVpc.vpc_id[0]
}

module "tgwProd" {
  source                = "../../../module/cloudeos/aws/tgwcnps"
  tgw_id                = "tgw-0a5856fd8cb6fbee6"
  cnps                  = "prod"
  router_info           = [module.CloudEOSEdge1.router_info, module.CloudEOSEdge2.router_info]
  cnps_route_table_info = "tgw-rtb-0fc080c48a90432a1"
  bandwidth_gbps        = 2
  vpc_id                = module.EdgeVpc.vpc_id[0]
}
