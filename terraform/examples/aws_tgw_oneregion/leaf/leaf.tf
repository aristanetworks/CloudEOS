// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
provider "cloudeos" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}
output "leafAndHostIPs" {
  value = {
    "Leaf1EOS1" : module.Leaf1CloudEOS1.intf_private_ips,
    "Leaf2EOS1" : module.Leaf2CloudEOS1.intf_private_ips,
    "Leaf2EOS1" : module.Leaf2CloudEOS1.intf_private_ips,
    "Leaf3EOS1" : module.Leaf3CloudEOS1.intf_private_ips,
    "Leaf1Host1" : module.Leaf1host1.intf_private_ips,
    "Leaf2Host1" : module.Leaf2host1.intf_private_ips,
    "Leaf3Host1" : module.Leaf3host1.intf_private_ips,
  }
}
//================= Leaf1 CloudEOS1===============================
module "Leaf1Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = ["101.1.0.0/16"]
  tags = {
    Name = "${var.topology}-Leaf1Vpc"
    Cnps = "dev"
  }
  region = var.aws_regions["region2"]
}

module "Leaf1Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    "101.1.0.0/24" = var.availability_zone[module.Leaf1Vpc.region]["zone1"]
    "101.1.1.0/24" = var.availability_zone[module.Leaf1Vpc.region]["zone1"]
  }
  subnet_names = {
    "101.1.0.0/24" = "${var.topology}-Leaf1Subnet0"
    "101.1.1.0/24" = "${var.topology}-Leaf1Subnet1"
  }
  vpc_id        = module.Leaf1Vpc.vpc_id[0]
  topology_name = module.Leaf1Vpc.topology_name
  region        = module.Leaf1Vpc.region
}

module "Leaf1CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf1Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Leaf1Vpc.region]
  keypair_name  = var.keypair_name[module.Leaf1Vpc.region]
  vpc_info      = module.Leaf1Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf1CloudEOS1Intf0",
    "${var.topology}-Leaf1CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf1CloudEOS1Intf0" = "internal"
    "${var.topology}-Leaf1CloudEOS1Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Leaf1CloudEOS1Intf0" = module.Leaf1Subnet.vpc_subnets[0]
    "${var.topology}-Leaf1CloudEOS1Intf1" = module.Leaf1Subnet.vpc_subnets[1]
  }
  private_ips       = { "0" : ["101.1.0.101"], "1" : ["101.1.1.101"] }
  availability_zone = var.availability_zone[module.Leaf1Vpc.region]["zone1"]
  region            = module.Leaf1Vpc.region
  tags = {
    "Name" = "${var.topology}-Leaf1CloudEOS1"
    "Cnps" = "dev"
  }
  cloud_ha             = "leaf1"
  primary              = true
  iam_instance_profile = "awslogs2"
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
}

module "Leaf1host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Leaf1Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Leaf1Vpc.region]
  subnet_id     = module.Leaf1Subnet.vpc_subnets[1]
  private_ips   = ["101.1.1.102"]
  tags = {
    "Name" = "${var.topology}-Leaf1devhost"
  }
}

// Leaf2
module "Leaf2Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = ["101.2.0.0/16"]
  tags = {
    Name = "${var.topology}-Leaf2Vpc"
    Cnps = "prod"
  }
  region = var.aws_regions["region2"]
}

module "Leaf2Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    "101.2.0.0/24" = var.availability_zone[module.Leaf2Vpc.region]["zone1"]
    "101.2.1.0/24" = var.availability_zone[module.Leaf2Vpc.region]["zone1"]
  }
  subnet_names = {
    "101.2.0.0/24" = "${var.topology}-Leaf2Subnet0"
    "101.2.1.0/24" = "${var.topology}-Leaf2Subnet1"
  }
  vpc_id        = module.Leaf2Vpc.vpc_id[0]
  topology_name = module.Leaf2Vpc.topology_name
  region        = module.Leaf2Vpc.region
}

module "Leaf2CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf2Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Leaf2Vpc.region]
  keypair_name  = var.keypair_name[module.Leaf2Vpc.region]
  vpc_info      = module.Leaf2Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf2CloudEOS1Intf0",
    "${var.topology}-Leaf2CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf2CloudEOS1Intf0" = "internal"
    "${var.topology}-Leaf2CloudEOS1Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Leaf2CloudEOS1Intf0" = module.Leaf2Subnet.vpc_subnets[0]
    "${var.topology}-Leaf2CloudEOS1Intf1" = module.Leaf2Subnet.vpc_subnets[1]
  }
  private_ips       = { "0" : ["101.2.0.101"], "1" : ["101.2.1.101"] }
  availability_zone = var.availability_zone[module.Leaf2Vpc.region]["zone1"]
  region            = module.Leaf2Vpc.region
  tags = {
    "Name" = "${var.topology}-Leaf2CloudEOS1"
    "Cnps" = "prod"
  }
  primary              = true
  cloud_ha             = "leaf2"
  iam_instance_profile = "awslogs2"
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
}

module "Leaf2host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Leaf2Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Leaf2Vpc.region]
  subnet_id     = module.Leaf2Subnet.vpc_subnets[1]
  private_ips   = ["101.2.1.102"]
  tags = {
    "Name" = "${var.topology}-Leaf2prodhost1"
  }
}

//Leaf3
module "Leaf3Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = ["101.3.0.0/16"]
  tags = {
    Name = "${var.topology}-Leaf3Vpc"
    Cnps = "dev"
  }
  region = var.aws_regions["region2"]
}

module "Leaf3Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    "101.3.0.0/24" = var.availability_zone[module.Leaf3Vpc.region]["zone1"]
    "101.3.1.0/24" = var.availability_zone[module.Leaf3Vpc.region]["zone1"]
  }
  subnet_names = {
    "101.3.0.0/24" = "${var.topology}-Leaf3Subnet0"
    "101.3.1.0/24" = "${var.topology}-Leaf3Subnet1"
  }
  vpc_id        = module.Leaf3Vpc.vpc_id[0]
  topology_name = module.Leaf3Vpc.topology_name
  region        = module.Leaf3Vpc.region
}

module "Leaf3CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf3Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Leaf3Vpc.region]
  keypair_name  = var.keypair_name[module.Leaf3Vpc.region]
  vpc_info      = module.Leaf3Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf3CloudEOS1Intf0",
    "${var.topology}-Leaf3CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf3CloudEOS1Intf0" = "internal"
    "${var.topology}-Leaf3CloudEOS1Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Leaf3CloudEOS1Intf0" = module.Leaf3Subnet.vpc_subnets[0]
    "${var.topology}-Leaf3CloudEOS1Intf1" = module.Leaf3Subnet.vpc_subnets[1]
  }
  private_ips       = { "0" : ["101.3.0.101"], "1" : ["101.3.1.101"] }
  availability_zone = var.availability_zone[module.Leaf3Vpc.region]["zone1"]
  region            = module.Leaf3Vpc.region
  tags = {
    "Name" = "${var.topology}-Leaf3CloudEOS1"
    "Cnps" = "dev"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
}

module "Leaf3host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Leaf3Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Leaf3Vpc.region]
  subnet_id     = module.Leaf3Subnet.vpc_subnets[1]
  private_ips   = ["101.3.1.102"]
  tags = {
    "Name" = "${var.topology}-Leaf3devHost"
  }
}

module "TgwLeaf3host1" {
  region        = var.tgwLeafHosts["leaf3"]["region"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[var.tgwLeafHosts["leaf3"]["region"]]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[var.tgwLeafHosts["leaf3"]["region"]]
  subnet_id     = var.tgwLeafHosts["leaf3"]["subnetids"][1]
  private_ips   = ["103.2.1.102"]
  tags = {
    "Name" = "${var.topology}-TgwLeaf3Host1"
  }
}

module "TgwLeaf4host1" {
  region        = var.tgwLeafHosts["leaf4"]["region"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[var.tgwLeafHosts["leaf4"]["region"]]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[var.tgwLeafHosts["leaf4"]["region"]]
  subnet_id     = var.tgwLeafHosts["leaf4"]["subnetids"][1]
  private_ips   = ["104.2.1.102"]
  tags = {
    "Name" = "${var.topology}-TgwLeaf4Host1"
  }
}
