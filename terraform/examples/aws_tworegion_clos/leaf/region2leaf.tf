// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
//=================Region2 Leaf1 CloudEOS1===============================
module "Region2Leaf1Vpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name = module.globals.topology
  clos_name     = "${module.globals.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = ["101.2.0.0/16"]
  tags = {
    Name = "${module.globals.topology}-Region2Leaf1Vpc"
    Cnps = "Dev"
  }
  region = module.globals.aws_regions["region2"]
}

module "Region2Leaf1Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
    "101.2.0.0/24" = lookup(module.globals.availability_zone[module.Region2Leaf1Vpc.region], "zone1", "")
    "101.2.1.0/24" = lookup(module.globals.availability_zone[module.Region2Leaf1Vpc.region], "zone1", "")
  }
  subnet_names = {
    "101.2.0.0/24" = "${module.globals.topology}-Region2Leaf1Subnet0"
    "101.2.1.0/24" = "${module.globals.topology}-Region2Leaf1Subnet1"
  }
  vpc_id        = module.Region2Leaf1Vpc.vpc_id[0]
  topology_name = module.Region2Leaf1Vpc.topology_name
  region        = module.Region2Leaf1Vpc.region
}

module "Region2Leaf1CloudEOS1" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf1Vpc.topology_name
  cloudeos_ami  = module.globals.eos_amis[module.Region2Leaf1Vpc.region]
  keypair_name  = module.globals.keypair_name[module.Region2Leaf1Vpc.region]
  vpc_info      = module.Region2Leaf1Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Region2Leaf1CloudEOS1Intf0",
    "${module.globals.topology}-Region2Leaf1CloudEOS1Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Region2Leaf1CloudEOS1Intf0" = "internal"
    "${module.globals.topology}-Region2Leaf1CloudEOS1Intf1" = "private"
  }
  subnetids = {
    "${module.globals.topology}-Region2Leaf1CloudEOS1Intf0" = module.Region2Leaf1Subnet.vpc_subnets[0]
    "${module.globals.topology}-Region2Leaf1CloudEOS1Intf1" = module.Region2Leaf1Subnet.vpc_subnets[1]
  }
  private_ips       = { "0" : ["101.2.0.101"], "1" : ["101.2.1.101"] }
  availability_zone = lookup(module.globals.availability_zone[module.Region2Leaf1Vpc.region], "zone1", "")
  region            = module.Region2Leaf1Vpc.region
  tags = {
    "Name" = "${module.globals.topology}-Region2Leaf1CloudEOS1"
    "Cnps" = "Dev"
  }
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region2Leaf1host1" {
  region        = module.globals.aws_regions["region2"]
  source        = "../../../module/arista/aws/host"
  ami           = module.globals.host_amis[module.Region2Leaf1Vpc.region]
  instance_type = "c5.xlarge"
  keypair_name  = module.globals.keypair_name[module.Region2Leaf1Vpc.region]
  subnet_id     = module.Region2Leaf1Subnet.vpc_subnets[1]
  private_ips   = ["101.2.1.102"]
  tags = {
    "Name" = "${module.globals.topology}-Region2Leaf1host"
  }
}

//=================Region2 Leaf2 CloudEOS1===============================
module "Region2Leaf2Vpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name = module.globals.topology
  clos_name     = "${module.globals.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = ["102.2.0.0/16"]
  tags = {
    Name = "${module.globals.topology}-Region2Leaf2Vpc"
    Cnps = "Prod"
  }
  region = module.globals.aws_regions["region2"]
}

module "Region2Leaf2Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
    "102.2.0.0/24" = lookup(module.globals.availability_zone[module.Region2Leaf2Vpc.region], "zone1", "")
    "102.2.1.0/24" = lookup(module.globals.availability_zone[module.Region2Leaf2Vpc.region], "zone1", "")
  }
  subnet_names = {
    "102.2.0.0/24" = "${module.globals.topology}-Region2Leaf2Subnet0"
    "102.2.1.0/24" = "${module.globals.topology}-Region2Leaf2Subnet1"
  }
  vpc_id        = module.Region2Leaf2Vpc.vpc_id[0]
  topology_name = module.Region2Leaf2Vpc.topology_name
  region        = module.Region2Leaf2Vpc.region
}

module "Region2Leaf2CloudEOS1" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf2Vpc.topology_name
  cloudeos_ami  = module.globals.eos_amis[module.Region2Leaf2Vpc.region]
  keypair_name  = module.globals.keypair_name[module.Region2Leaf2Vpc.region]
  vpc_info      = module.Region2Leaf2Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Region2Leaf2CloudEOS1Intf0",
    "${module.globals.topology}-Region2Leaf2CloudEOS1Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Region2Leaf2CloudEOS1Intf0" = "internal"
    "${module.globals.topology}-Region2Leaf2CloudEOS1Intf1" = "private"
  }
  subnetids = {
    "${module.globals.topology}-Region2Leaf2CloudEOS1Intf0" = module.Region2Leaf2Subnet.vpc_subnets[0]
    "${module.globals.topology}-Region2Leaf2CloudEOS1Intf1" = module.Region2Leaf2Subnet.vpc_subnets[1]
  }
  private_ips       = { "0" : ["102.2.0.101"], "1" : ["102.2.1.101"] }
  availability_zone = lookup(module.globals.availability_zone[module.Region2Leaf2Vpc.region], "zone1", "")
  region            = module.Region2Leaf2Vpc.region
  tags = {
    "Name" = "${module.globals.topology}-Region2Leaf2CloudEOS1"
    "Cnps" = "Prod"
  }
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region2Leaf2host1" {
  region        = module.globals.aws_regions["region2"]
  source        = "../../../module/arista/aws/host"
  ami           = module.globals.host_amis[module.Region2Leaf2Vpc.region]
  instance_type = "c5.xlarge"
  keypair_name  = module.globals.keypair_name[module.Region2Leaf2Vpc.region]
  subnet_id     = module.Region2Leaf2Subnet.vpc_subnets[1]
  private_ips   = ["102.2.1.102"]
  tags = {
    "Name" = "${module.globals.topology}-Region2Leaf2host"
  }
}
