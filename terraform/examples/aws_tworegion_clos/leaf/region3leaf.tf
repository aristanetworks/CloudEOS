// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
//=================Region3 Leaf1 CloudEOS1===============================
module "Region3Leaf1Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["region3_leaf1_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Region3Leaf1Vpc"
    Cnps = "dev"
  }
  region = var.aws_regions["region3"]
}

module "Region3Leaf1Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Region3Leaf1Vpc.region]["zone1"]
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Region3Leaf1Vpc.region]["zone1"]
  }
  subnet_names = {
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][0]) = "${var.topology}-Region3Leaf1Subnet0"
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][1]) = "${var.topology}-Region3Leaf1Subnet1"
  }
  vpc_id        = module.Region3Leaf1Vpc.vpc_id[0]
  topology_name = module.Region3Leaf1Vpc.topology_name
  region        = module.Region3Leaf1Vpc.region
}

module "Region3Leaf1CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Region3Leaf1Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region3Leaf1Vpc.region]
  keypair_name  = var.keypair_name[module.Region3Leaf1Vpc.region]
  vpc_info      = module.Region3Leaf1Vpc.vpc_info
  intf_names = [
    "${var.topology}-Region3Leaf1CloudEOS1Intf0",
    "${var.topology}-Region3Leaf1CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Region3Leaf1CloudEOS1Intf0" = "internal"
    "${var.topology}-Region3Leaf1CloudEOS1Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Region3Leaf1CloudEOS1Intf0" = module.Region3Leaf1Subnet.vpc_subnets[0]
    "${var.topology}-Region3Leaf1CloudEOS1Intf1" = module.Region3Leaf1Subnet.vpc_subnets[1]
  }
  private_ips       = { "0" : [(var.vpc_info["region3_leaf1_vpc"]["interface_ips"][0])], "1" : [(var.vpc_info["region3_leaf1_vpc"]["interface_ips"][1])] }
  availability_zone = var.availability_zone[module.Region3Leaf1Vpc.region]["zone1"]
  region            = module.Region3Leaf1Vpc.region
  tags = {
    "Name" = "${var.topology}-Region3Leaf1CloudEOS1"
    "Cnps" = "dev"
  }
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
  instance_type = var.instance_type["leaf"]
}

module "Region3Leaf1host1" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Region3Leaf1Vpc.region]
  instance_type = "c5.xlarge"
  keypair_name  = var.keypair_name[module.Region3Leaf1Vpc.region]
  subnet_id     = module.Region3Leaf1Subnet.vpc_subnets[1]
  private_ips   = [(var.vpc_info["region3_leaf1_vpc"]["interface_ips"][2])]
  tags = {
    "Name" = "${var.topology}-Region3Leaf1host"
  }
}

//=================Region3 Leaf2 CloudEOS1===============================
module "Region3Leaf2Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["region3_leaf2_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Region3Leaf2Vpc"
    Cnps = "dev"
  }
  region = var.aws_regions["region3"]
}

module "Region3Leaf2Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Region3Leaf2Vpc.region]["zone1"]
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Region3Leaf2Vpc.region]["zone1"]
  }
  subnet_names = {
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][0]) = "${var.topology}-Region3Leaf2Subnet0"
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][1]) = "${var.topology}-Region3Leaf2Subnet1"
  }
  vpc_id        = module.Region3Leaf2Vpc.vpc_id[0]
  topology_name = module.Region3Leaf2Vpc.topology_name
  region        = module.Region3Leaf2Vpc.region
}

module "Region3Leaf2CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Region3Leaf2Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region3Leaf2Vpc.region]
  keypair_name  = var.keypair_name[module.Region3Leaf2Vpc.region]
  vpc_info      = module.Region3Leaf2Vpc.vpc_info
  intf_names = [
    "${var.topology}-Region3Leaf2CloudEOS1Intf0",
    "${var.topology}-Region3Leaf2CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Region3Leaf2CloudEOS1Intf0" = "internal"
    "${var.topology}-Region3Leaf2CloudEOS1Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Region3Leaf2CloudEOS1Intf0" = module.Region3Leaf2Subnet.vpc_subnets[0]
    "${var.topology}-Region3Leaf2CloudEOS1Intf1" = module.Region3Leaf2Subnet.vpc_subnets[1]
  }
  private_ips       = { "0" : [(var.vpc_info["region3_leaf2_vpc"]["interface_ips"][0])], "1" : [(var.vpc_info["region3_leaf2_vpc"]["interface_ips"][1])] }
  availability_zone = var.availability_zone[module.Region3Leaf2Vpc.region]["zone1"]
  region            = module.Region3Leaf2Vpc.region
  tags = {
    "Name" = "${var.topology}-Region3Leaf2CloudEOS1"
    "Cnps" = "dev"
  }
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
  instance_type = var.instance_type["leaf"]
}

module "Region3Leaf2host1" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Region3Leaf2Vpc.region]
  instance_type = "c5.xlarge"
  keypair_name  = var.keypair_name[module.Region3Leaf2Vpc.region]
  subnet_id     = module.Region3Leaf2Subnet.vpc_subnets[1]
  private_ips   = [(var.vpc_info["region3_leaf2_vpc"]["interface_ips"][2])]
  tags = {
    "Name" = "${var.topology}-Region3Leaf2host"
  }
}

