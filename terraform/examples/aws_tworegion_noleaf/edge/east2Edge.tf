// Copyright (c) 2021 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
//=================East2 Edge CloudEOS1===============================
module "East2EdgeVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = module.globals.topology
  clos_name     = "${module.globals.topology}-clos"
  wan_name      = "${module.globals.topology}-wan"
  role          = "CloudEdge"
  igw_name      = "${module.globals.topology}-East2VpcIgw"
  cidr_block    = [(var.vpc_info["east2_edge1_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${module.globals.topology}-East2EdgeVpc"
  }
  region = module.globals.aws_regions["region3"]
  default_ingress_sg_cidrs = var.ingress_allowlist["edge_vpc"]["default"]
  ssh_security_group_cidrs = var.ingress_allowlist["edge_vpc"]["ssh"]
}

module "East2EdgeSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["east2_edge1_vpc"]["subnet_cidr"][0] ) = lookup(module.globals.availability_zone[module.East2EdgeVpc.region], "zone1", "")
    (var.vpc_info["east2_edge1_vpc"]["subnet_cidr"][1] ) = lookup(module.globals.availability_zone[module.East2EdgeVpc.region], "zone1", "")
    (var.vpc_info["east2_edge1_vpc"]["subnet_cidr"][2] ) = lookup(module.globals.availability_zone[module.East2EdgeVpc.region], "zone2", "")
    (var.vpc_info["east2_edge1_vpc"]["subnet_cidr"][3] ) = lookup(module.globals.availability_zone[module.East2EdgeVpc.region], "zone2", "")
  }
  subnet_names = {
    (var.vpc_info["east2_edge1_vpc"]["subnet_cidr"][0] ) = "${module.globals.topology}-East2EdgeSubnet0"
    (var.vpc_info["east2_edge1_vpc"]["subnet_cidr"][1] ) = "${module.globals.topology}-East2EdgeSubnet1"
    (var.vpc_info["east2_edge1_vpc"]["subnet_cidr"][2] ) = "${module.globals.topology}-East2EdgeSubnet2"
    (var.vpc_info["east2_edge1_vpc"]["subnet_cidr"][3] ) = "${module.globals.topology}-East2EdgeSubnet3"
  }
  vpc_id        = module.East2EdgeVpc.vpc_id[0]
  topology_name = module.East2EdgeVpc.topology_name
  region        = module.East2EdgeVpc.region
}

module "East2CloudEOSEdge1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.East2EdgeVpc.topology_name
  cloudeos_ami  = module.globals.eos_amis[module.East2EdgeVpc.region]
  keypair_name  = module.globals.keypair_name[module.East2EdgeVpc.region]
  vpc_info      = module.East2EdgeVpc.vpc_info
  intf_names    = ["${module.globals.topology}-East2Edge1Intf0", "${module.globals.topology}-East2Edge1Intf1"]
  interface_types = {
    "${module.globals.topology}-East2Edge1Intf0" = "public"
    "${module.globals.topology}-East2Edge1Intf1" = "internal"
  }
  subnetids = {
    "${module.globals.topology}-East2Edge1Intf0" = module.East2EdgeSubnet.vpc_subnets[0]
    "${module.globals.topology}-East2Edge1Intf1" = module.East2EdgeSubnet.vpc_subnets[1]
  }
  private_ips       = { "0" : [ (var.vpc_info["east2_edge1_vpc"]["interface_ips"][0])], "1" : [(var.vpc_info["east2_edge1_vpc"]["interface_ips"][1])]}
  availability_zone = lookup(module.globals.availability_zone[module.East2EdgeVpc.region], "zone1", "")
  region            = module.East2EdgeVpc.region
  tags = {
    "Name" = "${module.globals.topology}-East2CloudEOSEdge1"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["edge"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "East2CloudEOSEdge2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.East2EdgeVpc.topology_name
  cloudeos_ami  = module.globals.eos_amis[module.East2EdgeVpc.region]
  keypair_name  = module.globals.keypair_name[module.East2EdgeVpc.region]
  vpc_info      = module.East2EdgeVpc.vpc_info
  intf_names    = ["${module.globals.topology}-East2Edge2Intf0", "${module.globals.topology}-East2Edge2Intf1"]
  interface_types = {
    "${module.globals.topology}-East2Edge2Intf0" = "public"
    "${module.globals.topology}-East2Edge2Intf1" = "internal"
  }
  subnetids = {
    "${module.globals.topology}-East2Edge2Intf0" = module.East2EdgeSubnet.vpc_subnets[2]
    "${module.globals.topology}-East2Edge2Intf1" = module.East2EdgeSubnet.vpc_subnets[3]
  }
  private_ips       = { "0" : [(var.vpc_info["east2_edge1_vpc"]["interface_ips"][2])], "1" : [(var.vpc_info["east2_edge1_vpc"]["interface_ips"][3])] }
  availability_zone = lookup(module.globals.availability_zone[module.East2EdgeVpc.region], "zone2", "")
  region            = module.East2EdgeVpc.region
  tags = {
    "Name" = "${module.globals.topology}-East2CloudEOSEdge2"
  }
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  public_route_table_id   = module.East2CloudEOSEdge1.route_table_public
  internal_route_table_id = module.East2CloudEOSEdge1.route_table_internal
  instance_type           = var.instance_type["edge"]
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}
