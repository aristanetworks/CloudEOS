// Copyright (c) 2021 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
//=================East1 Edge CloudEOS1===============================
module "East1EdgeVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = module.globals.topology
  clos_name     = "${module.globals.topology}-clos"
  wan_name      = "${module.globals.topology}-wan"
  role          = "CloudEdge"
  igw_name      = "${module.globals.topology}-East1VpcIgw"
  cidr_block    = [(var.vpc_info["east1_edge1_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${module.globals.topology}-East1EdgeVpc"
  }
  region = module.globals.aws_regions["region2"]
}

module "East1EdgeSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["east1_edge1_vpc"]["subnet_cidr"][0] ) = lookup(module.globals.availability_zone[module.East1EdgeVpc.region], "zone1", "")
    (var.vpc_info["east1_edge1_vpc"]["subnet_cidr"][1] ) = lookup(module.globals.availability_zone[module.East1EdgeVpc.region], "zone1", "")
    (var.vpc_info["east1_edge1_vpc"]["subnet_cidr"][2] ) = lookup(module.globals.availability_zone[module.East1EdgeVpc.region], "zone2", "")
    (var.vpc_info["east1_edge1_vpc"]["subnet_cidr"][3] ) = lookup(module.globals.availability_zone[module.East1EdgeVpc.region], "zone2", "")
  }
  subnet_names = {
    (var.vpc_info["east1_edge1_vpc"]["subnet_cidr"][0] ) = "${module.globals.topology}-East1EdgeSubnet0"
    (var.vpc_info["east1_edge1_vpc"]["subnet_cidr"][1] ) = "${module.globals.topology}-East1EdgeSubnet1"
    (var.vpc_info["east1_edge1_vpc"]["subnet_cidr"][2] ) = "${module.globals.topology}-East1EdgeSubnet2"
    (var.vpc_info["east1_edge1_vpc"]["subnet_cidr"][3] ) = "${module.globals.topology}-East1EdgeSubnet3"
  }
  vpc_id        = module.East1EdgeVpc.vpc_id[0]
  topology_name = module.East1EdgeVpc.topology_name
  region        = module.East1EdgeVpc.region
}

module "East1CloudEOSEdge1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.East1EdgeVpc.topology_name
  cloudeos_ami  = module.globals.eos_amis[module.East1EdgeVpc.region]
  keypair_name  = module.globals.keypair_name[module.East1EdgeVpc.region]
  vpc_info      = module.East1EdgeVpc.vpc_info
  intf_names    = ["${module.globals.topology}-East1Edge1Intf0", "${module.globals.topology}-East1Edge1Intf1"]
  interface_types = {
    "${module.globals.topology}-East1Edge1Intf0" = "public"
    "${module.globals.topology}-East1Edge1Intf1" = "internal"
  }
  subnetids = {
    "${module.globals.topology}-East1Edge1Intf0" = module.East1EdgeSubnet.vpc_subnets[0]
    "${module.globals.topology}-East1Edge1Intf1" = module.East1EdgeSubnet.vpc_subnets[1]
  }
  private_ips       = { "0" : [ (var.vpc_info["east1_edge1_vpc"]["interface_ips"][0]) ], "1" : [(var.vpc_info["east1_edge1_vpc"]["interface_ips"][1])] }
  availability_zone = lookup(module.globals.availability_zone[module.East1EdgeVpc.region], "zone1", "")
  region            = module.East1EdgeVpc.region
  tags = {
    "Name" = "${module.globals.topology}-East1CloudEOSEdge1"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["edge"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}
