// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
provider "cloudeos" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}
resource "cloudeos_topology" "topology" {
  topology_name         = var.topology
  bgp_asn               = "65000-65100"             // Range of BGP ASN’s used for topology
  vtep_ip_cidr          = var.vtep_ip_cidr          // CIDR block for VTEP IPs on cloudeos
  terminattr_ip_cidr    = var.terminattr_ip_cidr    // Loopback IP range on cloudeos
  dps_controlplane_cidr = var.dps_controlplane_cidr // CIDR block for Dps Control Plane IPs on cloudeos
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


//=================Region2 Edge CloudEOS1===============================
module "Region2EdgeVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = cloudeos_topology.topology.topology_name
  clos_name     = cloudeos_clos.clos.name
  wan_name      = cloudeos_wan.wan.name
  role          = "CloudEdge"
  igw_name      = "${var.topology}-Region2VpcIgw"
  cidr_block    = ["100.2.0.0/16"]
  tags = {
    Name = "${var.topology}-Region2EdgeVpc"
  }
  region = var.aws_regions["region2"]
}

module "Region2EdgeSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    "100.2.0.0/24" = var.availability_zone[module.Region2EdgeVpc.region]["zone1"]
    "100.2.1.0/24" = var.availability_zone[module.Region2EdgeVpc.region]["zone1"]
    "100.2.2.0/24" = var.availability_zone[module.Region2EdgeVpc.region]["zone2"]
    "100.2.3.0/24" = var.availability_zone[module.Region2EdgeVpc.region]["zone2"]
    "100.2.4.0/24" = var.availability_zone[module.Region2EdgeVpc.region]["zone1"]
  }
  subnet_names = {
    "100.2.0.0/24" = "${var.topology}-Region2EdgeSubnet0"
    "100.2.1.0/24" = "${var.topology}-Region2EdgeSubnet1"
    "100.2.2.0/24" = "${var.topology}-Region2EdgeSubnet2"
    "100.2.3.0/24" = "${var.topology}-Region2EdgeSubnet3"
    "100.2.4.0/24" = "${var.topology}-RRSubnet1"
  }
  vpc_id        = module.Region2EdgeVpc.vpc_id[0]
  topology_name = module.Region2EdgeVpc.topology_name
  region        = module.Region2EdgeVpc.region
}

module "Region2CloudEOSEdge1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.Region2EdgeVpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region2EdgeVpc.region]
  keypair_name  = var.keypair_name[module.Region2EdgeVpc.region]
  vpc_info      = module.Region2EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Region2Edge1Intf0", "${var.topology}-Region2Edge1Intf1"]
  interface_types = {
    "${var.topology}-Region2Edge1Intf0" = "public"
    "${var.topology}-Region2Edge1Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Region2Edge1Intf0" = module.Region2EdgeSubnet.vpc_subnets[0]
    "${var.topology}-Region2Edge1Intf1" = module.Region2EdgeSubnet.vpc_subnets[1]
  }
  private_ips       = { "0" : ["100.2.0.101"], "1" : ["100.2.1.101"] }
  availability_zone = var.availability_zone[module.Region2EdgeVpc.region]["zone1"]
  region            = module.Region2EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-Region2CloudEOSEdge1"
  }
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "CloudEOSRR1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.Region2EdgeVpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region2EdgeVpc.region]
  keypair_name  = var.keypair_name[module.Region2EdgeVpc.region]
  vpc_info      = module.Region2EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-RRIntf0"]
  interface_types = {
    "${var.topology}-RRIntf0" = "public"
  }
  subnetids = {
    "${var.topology}-RRIntf0" = module.Region2EdgeSubnet.vpc_subnets[4]
  }
  private_ips = {
    "0" : ["100.2.4.101"]
  }
  availability_zone = var.availability_zone[module.Region2EdgeVpc.region]["zone1"]
  region            = module.Region2EdgeVpc.region
  tags = {
    "Name"           = "${var.topology}-CloudEosRR1"
    "RouteReflector" = "True"
  }
  is_rr    = true
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region2CloudEOSEdge2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.Region2EdgeVpc.topology_name
  cloudeos_ami = var.eos_amis[module.Region2EdgeVpc.region]
  keypair_name = var.keypair_name[module.Region2EdgeVpc.region]
  vpc_info      = module.Region2EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Region2Edge2Intf0", "${var.topology}-Region2Edge2Intf1"]
  interface_types = {
    "${var.topology}-Region2Edge2Intf0" = "public"
    "${var.topology}-Region2Edge2Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Region2Edge2Intf0" = module.Region2EdgeSubnet.vpc_subnets[2]
    "${var.topology}-Region2Edge2Intf1" = module.Region2EdgeSubnet.vpc_subnets[3]
  }
  private_ips       = { "0" : ["100.2.2.101"], "1" : ["100.2.3.101"] }
  availability_zone = var.availability_zone[module.Region2EdgeVpc.region]["zone2"]
  region            = module.Region2EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-Region2CloudEOSEdge2"
  }
  filename = "../../../userdata/eos_ipsec_config.tpl"
  public_route_table_id = module.Region2CloudEOSEdge1.route_table_public
  internal_route_table_id = module.Region2CloudEOSEdge1.route_table_internal
}


//Region3
module "Region3EdgeVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = cloudeos_topology.topology.topology_name
  clos_name     = cloudeos_clos.clos.name
  wan_name      = cloudeos_wan.wan.name
  role          = "CloudEdge"
  igw_name      = "${var.topology}-Region3VpcIgw"
  cidr_block    = ["100.3.0.0/16"]
  tags = {
    Name = "${var.topology}-Region3EdgeVpc"
  }
  region = var.aws_regions["region3"]
}

module "Region3EdgeSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    "100.3.0.0/24" = var.availability_zone[module.Region3EdgeVpc.region]["zone1"]
    "100.3.1.0/24" = var.availability_zone[module.Region3EdgeVpc.region]["zone1"]
    "100.3.2.0/24" = var.availability_zone[module.Region3EdgeVpc.region]["zone2"]
    "100.3.3.0/24" = var.availability_zone[module.Region3EdgeVpc.region]["zone2"]
  }
  subnet_names = {
    "100.3.0.0/24" = "${var.topology}-Region3EdgeSubnet0"
    "100.3.1.0/24" = "${var.topology}-Region3EdgeSubnet1"
    "100.3.2.0/24" = "${var.topology}-Region3EdgeSubnet2"
    "100.3.3.0/24" = "${var.topology}-Region3EdgeSubnet3"
  }
  vpc_id        = module.Region3EdgeVpc.vpc_id[0]
  topology_name = module.Region3EdgeVpc.topology_name
  region        = module.Region3EdgeVpc.region
}

module "Region3CloudEOSEdge1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.Region3EdgeVpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region3EdgeVpc.region]
  keypair_name  = var.keypair_name[module.Region3EdgeVpc.region]
  vpc_info      = module.Region3EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Region3Edge1Intf0", "${var.topology}-Region3Edge1Intf1"]
  interface_types = {
    "${var.topology}-Region3Edge1Intf0" = "public"
    "${var.topology}-Region3Edge1Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Region3Edge1Intf0" = module.Region3EdgeSubnet.vpc_subnets[0]
    "${var.topology}-Region3Edge1Intf1" = module.Region3EdgeSubnet.vpc_subnets[1]
  }
  private_ips       = { "0" : ["100.3.0.101"], "1" : ["100.3.1.101"] }
  availability_zone = var.availability_zone[module.Region3EdgeVpc.region]["zone1"]
  region            = module.Region3EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-Region3CloudEOSEdge1"
  }
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

