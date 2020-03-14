// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
//=================Region3 Edge CloudEOS1===============================
module "Region3EdgeVpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  wan_name      = "${var.topology}-wan"
  role          = "CloudEdge"
  igw_name      = "${var.topology}-Region3VpcIgw"
  cidr_block    = ["100.3.0.0/16"]
  tags = {
    Name = "${var.topology}-Region3EdgeVpc"
  }
  region = var.aws_regions["region3"]
}

module "Region3EdgeSubnet" {
  source = "../../../module/arista/aws/subnet"
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
  source        = "../../../module/arista/aws/cloudEOS"
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

/*
module "Region3CloudEOSEdge2" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudEdge"
  topology_name = module.Region3EdgeVpc.topology_name
  cloudeos_ami = var.eos_amis[module.Region3EdgeVpc.region]
  keypair_name = var.keypair_name[module.Region3EdgeVpc.region]
  vpc_info      = module.Region3EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Region3Edge2Intf0", "${var.topology}-Region3Edge2Intf1"]
  interface_types = {
    "${var.topology}-Region3Edge2Intf0" = "public"
    "${var.topology}-Region3Edge2Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Region3Edge2Intf0" = module.Region3EdgeSubnet.vpc_subnets[2]
    "${var.topology}-Region3Edge2Intf1" = module.Region3EdgeSubnet.vpc_subnets[3]
  }
  private_ips       = { "0" : ["100.3.2.101"], "1" : ["100.3.3.101"] }
  availability_zone = lookup( var.availability_zone[module.Region3EdgeVpc.region]["zone2", "" )
  region            = module.Region3EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-Region3CloudEOSEdge2"
  }
  filename = "../../../userdata/eos_ipsec_config.tpl"
  public_route_table_id = module.Region3CloudEOSEdge1.route_table_public
  internal_route_table_id = module.Region3CloudEOSEdge1.route_table_internal
}
*/
