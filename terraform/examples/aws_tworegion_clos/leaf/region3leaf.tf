// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
//=================Region3 Leaf1 CloudEOS1===============================
module "Region3Leaf1Vpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = ["110.2.0.0/16"]
  tags = {
    Name = "${var.topology}-Region3Leaf1Vpc"
    Cnps = "Dev"
  }
  region = var.aws_regions["region3"]
}

module "Region3Leaf1Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
    "110.2.0.0/24" = var.availability_zone[module.Region3Leaf1Vpc.region]["zone1"]
    "110.2.1.0/24" = var.availability_zone[module.Region3Leaf1Vpc.region]["zone1"]
  }
  subnet_names = {
    "110.2.0.0/24" = "${var.topology}-Region3Leaf1Subnet0"
    "110.2.1.0/24" = "${var.topology}-Region3Leaf1Subnet1"
  }
  vpc_id        = module.Region3Leaf1Vpc.vpc_id[0]
  topology_name = module.Region3Leaf1Vpc.topology_name
  region        = module.Region3Leaf1Vpc.region
}

module "Region3Leaf1CloudEOS1" {
  source        = "../../../module/arista/aws/cloudEOS"
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
  private_ips       = { "0" : ["110.2.0.101"], "1" : ["110.2.1.101"] }
  availability_zone = var.availability_zone[module.Region3Leaf1Vpc.region]["zone1"]
  region            = module.Region3Leaf1Vpc.region
  tags = {
    "Name" = "${var.topology}-Region3Leaf1CloudEOS1"
    "Cnps" = "Dev"
  }
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region3Leaf1host1" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/arista/aws/host"
  ami           = var.host_amis[module.Region3Leaf1Vpc.region]
  instance_type = "c5.xlarge"
  keypair_name  = var.keypair_name[module.Region3Leaf1Vpc.region]
  subnet_id     = module.Region3Leaf1Subnet.vpc_subnets[1]
  private_ips   = ["110.2.1.102"]
  tags = {
    "Name" = "${var.topology}-Region3Leaf1host"
  }
}

//=================Region3 Leaf2 CloudEOS1===============================
module "Region3Leaf2Vpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = ["111.2.0.0/16"]
  tags = {
    Name = "${var.topology}-Region3Leaf2Vpc"
    Cnps = "Dev"
  }
  region = var.aws_regions["region3"]
}

module "Region3Leaf2Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
    "111.2.0.0/24" = var.availability_zone[module.Region3Leaf2Vpc.region]["zone1"]
    "111.2.1.0/24" = var.availability_zone[module.Region3Leaf2Vpc.region]["zone1"]
  }
  subnet_names = {
    "111.2.0.0/24" = "${var.topology}-Region3Leaf2Subnet0"
    "111.2.1.0/24" = "${var.topology}-Region3Leaf2Subnet1"
  }
  vpc_id        = module.Region3Leaf2Vpc.vpc_id[0]
  topology_name = module.Region3Leaf2Vpc.topology_name
  region        = module.Region3Leaf2Vpc.region
}

module "Region3Leaf2CloudEOS1" {
  source        = "../../../module/arista/aws/cloudEOS"
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
  private_ips       = { "0" : ["111.2.0.101"], "1" : ["111.2.1.101"] }
  availability_zone = var.availability_zone[module.Region3Leaf2Vpc.region]["zone1"]
  region            = module.Region3Leaf2Vpc.region
  tags = {
    "Name" = "${var.topology}-Region3Leaf2CloudEOS1"
    "Cnps" = "Dev"
  }
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region3Leaf2host1" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/arista/aws/host"
  ami           = var.host_amis[module.Region3Leaf2Vpc.region]
  instance_type = "c5.xlarge"
  keypair_name  = var.keypair_name[module.Region3Leaf2Vpc.region]
  subnet_id     = module.Region3Leaf2Subnet.vpc_subnets[1]
  private_ips   = ["111.2.1.102"]
  tags = {
    "Name" = "${var.topology}-Region3Leaf2host"
  }
}

