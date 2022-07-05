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
    "Leaf1EOS2" : module.Leaf1CloudEOS2.intf_private_ips,
    "Leaf2EOS1" : module.Leaf2CloudEOS1.intf_private_ips,
    "Leaf2EOS2" : module.Leaf2CloudEOS2.intf_private_ips,
    "Leaf2EOS1" : module.Leaf2CloudEOS1.intf_private_ips,
    "Leaf2EOS2" : module.Leaf2CloudEOS2.intf_private_ips,
    "Leaf3EOS1" : module.Leaf3CloudEOS1.intf_private_ips,
    "Leaf3EOS2" : module.Leaf3CloudEOS2.intf_private_ips,
    "Leaf4EOS1" : module.Leaf4CloudEOS1.intf_private_ips,
    "Leaf4EOS2" : module.Leaf4CloudEOS2.intf_private_ips,
    "Leaf1Host1" : module.Leaf1host1.intf_private_ips,
    "Leaf2Host1" : module.Leaf2host1.intf_private_ips,
    "Leaf3Host1" : module.Leaf3host1.intf_private_ips,
    "Leaf4Host1" : module.Leaf4host1.intf_private_ips,
  }
}
//================= Leaf1 CloudEOS1===============================
module "Leaf1Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["leaf1_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Leaf1Vpc"
    Cnps = "dev"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf1Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["leaf1_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Leaf1Vpc.region]["zone1"]
    (var.vpc_info["leaf1_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Leaf1Vpc.region]["zone1"]
    (var.vpc_info["leaf1_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.Leaf1Vpc.region]["zone2"]
    (var.vpc_info["leaf1_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.Leaf1Vpc.region]["zone2"]
  }
  subnet_names = {
    (var.vpc_info["leaf1_vpc"]["subnet_cidr"][0]) = "${var.topology}-Leaf1Subnet0"
    (var.vpc_info["leaf1_vpc"]["subnet_cidr"][1])= "${var.topology}-Leaf1Subnet1"
    (var.vpc_info["leaf1_vpc"]["subnet_cidr"][2]) = "${var.topology}-Leaf1Subnet2"
    (var.vpc_info["leaf1_vpc"]["subnet_cidr"][3]) = "${var.topology}-Leaf1Subnet3"
  }
  vpc_id        = module.Leaf1Vpc.vpc_id[0]
  topology_name = module.Leaf1Vpc.topology_name
  region        = module.Leaf1Vpc.region
}

module "Leaf1CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf1Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Leaf1Vpc.region]
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
  private_ips       = { "0" : ([var.vpc_info["leaf1_vpc"]["interface_ips"][0]]), "1" : ([var.vpc_info["leaf1_vpc"]["interface_ips"][1]]) }
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
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Leaf1CloudEOS2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf1Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Leaf1Vpc.region]
  keypair_name  = var.keypair_name[module.Leaf1Vpc.region]
  vpc_info      = module.Leaf1Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf1CloudEOS2Intf0",
    "${var.topology}-Leaf1CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf1CloudEOS2Intf0" = "internal"
    "${var.topology}-Leaf1CloudEOS2Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Leaf1CloudEOS2Intf0" = module.Leaf1Subnet.vpc_subnets[2]
    "${var.topology}-Leaf1CloudEOS2Intf1" = module.Leaf1Subnet.vpc_subnets[3]
  }
  private_ips       = { "0" : ([var.vpc_info["leaf1_vpc"]["interface_ips"][2]]), "1" : ([var.vpc_info["leaf1_vpc"]["interface_ips"][3]]) }
  availability_zone = var.availability_zone[module.Leaf1Vpc.region]["zone2"]
  region            = module.Leaf1Vpc.region
  tags = {
    "Name" = "${var.topology}-Leaf1CloudEOS2"
    "Cnps" = "dev"
  }
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
  cloud_ha                   = "leaf1"
  iam_instance_profile       = "awslogs2"
  internal_route_table_id    = module.Leaf1CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Leaf1Subnet.vpc_subnets[0]]
  intra_az_ha                = true
  instance_type              = var.instance_type["leaf"]
  licenses                   = var.licenses
  cloudeos_image_offer       = var.cloudeos_image_offer
}

module "Leaf1host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Leaf1Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Leaf1Vpc.region]
  subnet_id     = module.Leaf1Subnet.vpc_subnets[1]
  private_ips   = [(var.vpc_info["leaf1_vpc"]["interface_ips"][4])]
  tags = {
    "Name" = "${var.topology}-Leaf1devhost"  }
}

// Leaf2
module "Leaf2Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["leaf2_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Leaf2Vpc"
    Cnps = "prod"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf2Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["leaf2_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Leaf2Vpc.region]["zone1"]
    (var.vpc_info["leaf2_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Leaf2Vpc.region]["zone1"]
    (var.vpc_info["leaf2_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.Leaf2Vpc.region]["zone2"]
    (var.vpc_info["leaf2_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.Leaf2Vpc.region]["zone2"]
  }
  subnet_names = {
    (var.vpc_info["leaf2_vpc"]["subnet_cidr"][0]) = "${var.topology}-Leaf2Subnet0"
    (var.vpc_info["leaf2_vpc"]["subnet_cidr"][1]) = "${var.topology}-Leaf2Subnet1"
    (var.vpc_info["leaf2_vpc"]["subnet_cidr"][2]) = "${var.topology}-Leaf2Subnet2"
    (var.vpc_info["leaf2_vpc"]["subnet_cidr"][3]) = "${var.topology}-Leaf2Subnet3"
  }
  vpc_id        = module.Leaf2Vpc.vpc_id[0]
  topology_name = module.Leaf2Vpc.topology_name
  region        = module.Leaf2Vpc.region
}

module "Leaf2CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf2Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Leaf2Vpc.region]
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
  private_ips       = { "0" : ([var.vpc_info["leaf2_vpc"]["interface_ips"][0]]), "1" : ([var.vpc_info["leaf2_vpc"]["interface_ips"][1]]) }
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
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Leaf2CloudEOS2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf2Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Leaf2Vpc.region]
  keypair_name  = var.keypair_name[module.Leaf2Vpc.region]
  vpc_info      = module.Leaf2Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf2CloudEOS2Intf0",
    "${var.topology}-Leaf2CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf2CloudEOS2Intf0" = "internal"
    "${var.topology}-Leaf2CloudEOS2Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Leaf2CloudEOS2Intf0" = module.Leaf2Subnet.vpc_subnets[2]
    "${var.topology}-Leaf2CloudEOS2Intf1" = module.Leaf2Subnet.vpc_subnets[3]
  }
  private_ips       = { "0" : ([var.vpc_info["leaf2_vpc"]["interface_ips"][2]]), "1" : ([var.vpc_info["leaf2_vpc"]["interface_ips"][3]]) }
  availability_zone = var.availability_zone[module.Leaf2Vpc.region]["zone2"]
  region            = module.Leaf2Vpc.region
  tags = {
    "Name" = "${var.topology}-Leaf2CloudEOS2"
    "Cnps" = "prod"
  }
  internal_route_table_id    = module.Leaf2CloudEOS1.route_table_internal
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
  instance_type              = var.instance_type["leaf"]
  cloud_ha                   = "leaf2"
  iam_instance_profile       = "awslogs2"
  primary_internal_subnetids = [module.Leaf2Subnet.vpc_subnets[0]]
  licenses                   = var.licenses
  cloudeos_image_offer       = var.cloudeos_image_offer
}

module "Leaf2host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Leaf2Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Leaf2Vpc.region]
  subnet_id     = module.Leaf2Subnet.vpc_subnets[1]
  private_ips   = [(var.vpc_info["leaf2_vpc"]["interface_ips"][4])]
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
  cidr_block    = [(var.vpc_info["leaf3_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Leaf3Vpc"
    Cnps = "dev"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf3Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["leaf3_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Leaf3Vpc.region]["zone1"]
    (var.vpc_info["leaf3_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Leaf3Vpc.region]["zone1"]
    (var.vpc_info["leaf3_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.Leaf3Vpc.region]["zone2"]
    (var.vpc_info["leaf3_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.Leaf3Vpc.region]["zone2"]
  }
  subnet_names = {
    (var.vpc_info["leaf3_vpc"]["subnet_cidr"][0]) = "${var.topology}-Leaf3Subnet0"
    (var.vpc_info["leaf3_vpc"]["subnet_cidr"][1]) = "${var.topology}-Leaf3Subnet1"
    (var.vpc_info["leaf3_vpc"]["subnet_cidr"][2]) = "${var.topology}-Leaf3Subnet2"
    (var.vpc_info["leaf3_vpc"]["subnet_cidr"][3]) = "${var.topology}-Leaf3Subnet3"
  }
  vpc_id        = module.Leaf3Vpc.vpc_id[0]
  topology_name = module.Leaf3Vpc.topology_name
  region        = module.Leaf3Vpc.region
}

module "Leaf3CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf3Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Leaf3Vpc.region]
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
  private_ips       = { "0" : [(var.vpc_info["leaf3_vpc"]["interface_ips"][0])] , "1" : [(var.vpc_info["leaf3_vpc"]["interface_ips"][1])] }
  availability_zone = var.availability_zone[module.Leaf3Vpc.region]["zone1"]
  region            = module.Leaf3Vpc.region
  tags = {
    "Name" = "${var.topology}-Leaf3CloudEOS1"
    "Cnps" = "dev"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Leaf3CloudEOS2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf3Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Leaf3Vpc.region]
  keypair_name  = var.keypair_name[module.Leaf3Vpc.region]
  vpc_info      = module.Leaf3Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf3CloudEOS2Intf0",
    "${var.topology}-Leaf3CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf3CloudEOS2Intf0" = "internal"
    "${var.topology}-Leaf3CloudEOS2Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Leaf3CloudEOS2Intf0" = module.Leaf3Subnet.vpc_subnets[2]
    "${var.topology}-Leaf3CloudEOS2Intf1" = module.Leaf3Subnet.vpc_subnets[3]
  }
  private_ips       = { "0" : [(var.vpc_info["leaf3_vpc"]["interface_ips"][2])], "1" : [(var.vpc_info["leaf3_vpc"]["interface_ips"][3])] }
  availability_zone = var.availability_zone[module.Leaf3Vpc.region]["zone2"]
  region            = module.Leaf3Vpc.region
  tags = {
    "Name" = "${var.topology}-Leaf3CloudEOS2"
    "Cnps" = "dev"
  }
  internal_route_table_id = module.Leaf3CloudEOS1.route_table_internal
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  instance_type           = var.instance_type["leaf"]
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}

module "Leaf3host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Leaf3Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Leaf3Vpc.region]
  subnet_id     = module.Leaf3Subnet.vpc_subnets[1]
  private_ips   = [(var.vpc_info["leaf3_vpc"]["interface_ips"][4])]
  tags = {
    "Name" = "${var.topology}-Leaf3devHost"
  }

}

//Leaf4
module "Leaf4Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["leaf4_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Leaf4Vpc"
    Cnps = "prod"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf4Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["leaf4_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Leaf4Vpc.region]["zone1"]
    (var.vpc_info["leaf4_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Leaf4Vpc.region]["zone1"]
    (var.vpc_info["leaf4_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.Leaf4Vpc.region]["zone2"]
    (var.vpc_info["leaf4_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.Leaf4Vpc.region]["zone2"]
  }
  subnet_names = {
    (var.vpc_info["leaf4_vpc"]["subnet_cidr"][0]) = "${var.topology}-Leaf4Subnet0"
    (var.vpc_info["leaf4_vpc"]["subnet_cidr"][1]) = "${var.topology}-Leaf4Subnet1"
    (var.vpc_info["leaf4_vpc"]["subnet_cidr"][2]) = "${var.topology}-Leaf4Subnet2"
    (var.vpc_info["leaf4_vpc"]["subnet_cidr"][3]) = "${var.topology}-Leaf4Subnet3"
  }
  vpc_id        = module.Leaf4Vpc.vpc_id[0]
  topology_name = module.Leaf4Vpc.topology_name
  region        = module.Leaf4Vpc.region
}

module "Leaf4CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf4Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Leaf4Vpc.region]
  keypair_name  = var.keypair_name[module.Leaf4Vpc.region]
  vpc_info      = module.Leaf4Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf4CloudEOS1Intf0",
    "${var.topology}-Leaf4CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf4CloudEOS1Intf0" = "internal"
    "${var.topology}-Leaf4CloudEOS1Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Leaf4CloudEOS1Intf0" = module.Leaf4Subnet.vpc_subnets[0]
    "${var.topology}-Leaf4CloudEOS1Intf1" = module.Leaf4Subnet.vpc_subnets[1]
  }
  private_ips       = { "0" : [(var.vpc_info["leaf4_vpc"]["interface_ips"][0])], "1" : [(var.vpc_info["leaf4_vpc"]["interface_ips"][1])] }
  availability_zone = var.availability_zone[module.Leaf4Vpc.region]["zone1"]
  region            = module.Leaf4Vpc.region
  tags = {
    "Name" = "${var.topology}-Leaf4CloudEOS1"
    "Cnps" = "prod"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Leaf4CloudEOS2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Leaf4Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Leaf4Vpc.region]
  keypair_name  = var.keypair_name[module.Leaf4Vpc.region]
  vpc_info      = module.Leaf4Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf4CloudEOS2Intf0",
    "${var.topology}-Leaf4CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf4CloudEOS2Intf0" = "internal"
    "${var.topology}-Leaf4CloudEOS2Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Leaf4CloudEOS2Intf0" = module.Leaf4Subnet.vpc_subnets[2]
    "${var.topology}-Leaf4CloudEOS2Intf1" = module.Leaf4Subnet.vpc_subnets[3]
  }
  private_ips       = { "0" : [(var.vpc_info["leaf4_vpc"]["interface_ips"][2])], "1" : [(var.vpc_info["leaf4_vpc"]["interface_ips"][3])] }
  availability_zone = var.availability_zone[module.Leaf4Vpc.region]["zone2"]
  region            = module.Leaf4Vpc.region
  tags = {
    "Name" = "${var.topology}-Leaf4CloudEOS2"
    "Cnps" = "prod"
  }
  internal_route_table_id = module.Leaf4CloudEOS1.route_table_internal
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  instance_type           = var.instance_type["leaf"]
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}
module "Leaf4host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Leaf4Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Leaf4Vpc.region]
  subnet_id     = module.Leaf4Subnet.vpc_subnets[1]
  private_ips   = [(var.vpc_info["leaf4_vpc"]["interface_ips"][4])]
  tags = {
    "Name" = "${var.topology}-Leaf4prodHost"
  }
}

/*
//Leaf5
module "Leaf5Vpc" {
  source         = "../../../module/cloudeos/aws/vpc"
  topology_name  = var.topology
  clos_name      = "${var.topology}-clos"
  role           = "CloudLeaf"
  cidr_block     = ["10.5.0.0/16"]
  tags = {
    Name = "${var.topology}-Leaf5Vpc"
    Cnps = "prod"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf5Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
     "10.5.0.0/24" = var.availability_zone[module.Leaf5Vpc.region]["zone1"]
     "10.5.1.0/24" = var.availability_zone[module.Leaf5Vpc.region]["zone1"]
     "10.5.2.0/24" = var.availability_zone[module.Leaf5Vpc.region]["zone2"]
     "10.5.3.0/24" = var.availability_zone[module.Leaf5Vpc.region]["zone2"]
  }
  subnet_names = {
     "10.5.0.0/24" = "${var.topology}-Leaf5Subnet0"
     "10.5.1.0/24" = "${var.topology}-Leaf5Subnet1"
     "10.5.2.0/24" = "${var.topology}-Leaf5Subnet2"
     "10.5.3.0/24" = "${var.topology}-Leaf5Subnet3"
   }
  vpc_id = module.Leaf5Vpc.vpc_id[0]
  topology_name = module.Leaf5Vpc.topology_name
  region = module.Leaf5Vpc.region
}

module "Leaf5CloudEOS1" {
  source = "../../../module/cloudeos/aws/router"
  role = "CloudLeaf"
  topology_name = module.Leaf5Vpc.topology_name
  cloudeos_ami = local.eos_amis[module.Leaf5Vpc.region]
  keypair_name = var.keypair_name[module.Leaf5Vpc.region]
  vpc_info = module.Leaf5Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf5CloudEOS1Intf0",
    "${var.topology}-Leaf5CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf5CloudEOS1Intf0" = "internal"
    "${var.topology}-Leaf5CloudEOS1Intf1" = "private"
  }
  subnetids  = {
      "${var.topology}-Leaf5CloudEOS1Intf0" = module.Leaf5Subnet.vpc_subnets[0]
      "${var.topology}-Leaf5CloudEOS1Intf1" = module.Leaf5Subnet.vpc_subnets[1]
  }
  private_ips = {"0": ["10.5.0.101"], "1": ["10.5.1.101"]}
  availability_zone = var.availability_zone[module.Leaf5Vpc.region]["zone1"]
  region            = module.Leaf5Vpc.region
  tags = {
         "Name" = "${var.topology}-Leaf5CloudEOS1"
         "Cnps" = "prod"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Leaf5CloudEOS2" {
  source = "../../../module/cloudeos/aws/router"
  role = "CloudLeaf"
  topology_name = module.Leaf5Vpc.topology_name
  cloudeos_ami = local.eos_amis[module.Leaf5Vpc.region]
  keypair_name = var.keypair_name[module.Leaf5Vpc.region]
  vpc_info = module.Leaf5Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf5CloudEOS2Intf0",
    "${var.topology}-Leaf5CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf5CloudEOS2Intf0" = "internal"
    "${var.topology}-Leaf5CloudEOS2Intf1" = "private"
  }
  subnetids  = {
      "${var.topology}-Leaf5CloudEOS2Intf0" = module.Leaf5Subnet.vpc_subnets[2]
      "${var.topology}-Leaf5CloudEOS2Intf1" = module.Leaf5Subnet.vpc_subnets[3]
  }
  private_ips = {"0": ["10.5.2.101"], "1": ["10.5.3.101"]}
  availability_zone = var.availability_zone[module.Leaf5Vpc.region]["zone2"]
  region            = module.Leaf5Vpc.region
  tags = {
         "Name" = "${var.topology}-Leaf5CloudEOS2"
         "Cnps" = "prod"
  }
  internal_route_table_id = module.Leaf5CloudEOS1.route_table_internal
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  instance_type           = var.instance_type["leaf"]
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}

//Leaf6
module "Leaf6Vpc" {
  source         = "../../../module/cloudeos/aws/vpc"
  topology_name  = var.topology
  clos_name      = "${var.topology}-clos"
  role           = "CloudLeaf"
  cidr_block     = ["10.6.0.0/16"]
  tags = {
    Name = "${var.topology}-Leaf6Vpc"
    Cnps = "prod"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf6Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
     "10.6.0.0/24" = var.availability_zone[module.Leaf6Vpc.region]["zone1"]
     "10.6.1.0/24" = var.availability_zone[module.Leaf6Vpc.region]["zone1"]
     "10.6.2.0/24" = var.availability_zone[module.Leaf6Vpc.region]["zone2"]
     "10.6.3.0/24" = var.availability_zone[module.Leaf6Vpc.region]["zone2"]
  }
  subnet_names = {
     "10.6.0.0/24" = "${var.topology}-Leaf6Subnet0"
     "10.6.1.0/24" = "${var.topology}-Leaf6Subnet1"
     "10.6.2.0/24" = "${var.topology}-Leaf6Subnet2"
     "10.6.3.0/24" = "${var.topology}-Leaf6Subnet3"
   }
  vpc_id = module.Leaf6Vpc.vpc_id[0]
  topology_name = module.Leaf6Vpc.topology_name
  region = module.Leaf6Vpc.region
}

module "Leaf6CloudEOS1" {
  source = "../../../module/cloudeos/aws/router"
  role = "CloudLeaf"
  topology_name = module.Leaf6Vpc.topology_name
  cloudeos_ami = local.eos_amis[module.Leaf6Vpc.region]
  keypair_name = var.keypair_name[module.Leaf6Vpc.region]
  vpc_info = module.Leaf6Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf6CloudEOS1Intf0",
    "${var.topology}-Leaf6CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf6CloudEOS1Intf0" = "internal"
    "${var.topology}-Leaf6CloudEOS1Intf1" = "private"
  }
  subnetids  = {
      "${var.topology}-Leaf6CloudEOS1Intf0" = module.Leaf6Subnet.vpc_subnets[0]
      "${var.topology}-Leaf6CloudEOS1Intf1" = module.Leaf6Subnet.vpc_subnets[1]
  }
  private_ips = {"0": ["10.6.0.101"], "1": ["10.6.1.101"]}
  availability_zone = var.availability_zone[module.Leaf6Vpc.region]["zone1"]
  region            = module.Leaf6Vpc.region
  tags = {
         "Name" = "${var.topology}-Leaf6CloudEOS1"
         "Cnps" = "prod"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Leaf6CloudEOS2" {
  source = "../../../module/cloudeos/aws/router"
  role = "CloudLeaf"
  topology_name = module.Leaf6Vpc.topology_name
  cloudeos_ami = local.eos_amis[module.Leaf6Vpc.region]
  keypair_name = var.keypair_name[module.Leaf6Vpc.region]
  vpc_info = module.Leaf6Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf6CloudEOS2Intf0",
    "${var.topology}-Leaf6CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf6CloudEOS2Intf0" = "internal"
    "${var.topology}-Leaf6CloudEOS2Intf1" = "private"
  }
  subnetids  = {
      "${var.topology}-Leaf6CloudEOS2Intf0" = module.Leaf6Subnet.vpc_subnets[2]
      "${var.topology}-Leaf6CloudEOS2Intf1" = module.Leaf6Subnet.vpc_subnets[3]
  }
  private_ips = {"0": ["10.6.2.101"], "1": ["10.6.3.101"]}
  availability_zone = var.availability_zone[module.Leaf6Vpc.region]["zone2"]
  region            = module.Leaf6Vpc.region
  tags = {
         "Name" = "${var.topology}-Leaf6CloudEOS2"
         "Cnps" = "prod"
  }
  internal_route_table_id = module.Leaf6CloudEOS1.route_table_internal
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  instance_type           = var.instance_type["leaf"]
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}
//Leaf7
module "Leaf7Vpc" {
  source         = "../../../module/cloudeos/aws/vpc"
  topology_name  = var.topology
  clos_name      = "${var.topology}-clos"
  role           = "CloudLeaf"
  cidr_block     = ["10.7.0.0/16"]
  tags = {
    Name = "${var.topology}-Leaf7Vpc"
    Cnps = "prod"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf7Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
     "10.7.0.0/24" = var.availability_zone[module.Leaf7Vpc.region]["zone1"]
     "10.7.1.0/24" = var.availability_zone[module.Leaf7Vpc.region]["zone1"]
     "10.7.2.0/24" = var.availability_zone[module.Leaf7Vpc.region]["zone2"]
     "10.7.3.0/24" = var.availability_zone[module.Leaf7Vpc.region]["zone2"]
  }
  subnet_names = {
     "10.7.0.0/24" = "${var.topology}-Leaf7Subnet0"
     "10.7.1.0/24" = "${var.topology}-Leaf7Subnet1"
     "10.7.2.0/24" = "${var.topology}-Leaf7Subnet2"
     "10.7.3.0/24" = "${var.topology}-Leaf7Subnet3"
   }
  vpc_id = module.Leaf7Vpc.vpc_id[0]
  topology_name = module.Leaf7Vpc.topology_name
  region = module.Leaf7Vpc.region
}

module "Leaf7CloudEOS1" {
  source = "../../../module/cloudeos/aws/router"
  role = "CloudLeaf"
  topology_name = module.Leaf7Vpc.topology_name
  cloudeos_ami = local.eos_amis[module.Leaf7Vpc.region]
  keypair_name = var.keypair_name[module.Leaf7Vpc.region]
  vpc_info = module.Leaf7Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf7CloudEOS1Intf0",
    "${var.topology}-Leaf7CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf7CloudEOS1Intf0" = "internal"
    "${var.topology}-Leaf7CloudEOS1Intf1" = "private"
  }
  subnetids  = {
      "${var.topology}-Leaf7CloudEOS1Intf0" = module.Leaf7Subnet.vpc_subnets[0]
      "${var.topology}-Leaf7CloudEOS1Intf1" = module.Leaf7Subnet.vpc_subnets[1]
  }
  private_ips = {"0": ["10.7.0.101"], "1": ["10.7.1.101"]}
  availability_zone = var.availability_zone[module.Leaf7Vpc.region]["zone1"]
  region            = module.Leaf7Vpc.region
  tags = {
         "Name" = "${var.topology}-Leaf7CloudEOS1"
         "Cnps" = "prod"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Leaf7CloudEOS2" {
  source = "../../../module/cloudeos/aws/router"
  role = "CloudLeaf"
  topology_name = module.Leaf7Vpc.topology_name
  cloudeos_ami = local.eos_amis[module.Leaf7Vpc.region]
  keypair_name = var.keypair_name[module.Leaf7Vpc.region]
  vpc_info = module.Leaf7Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf7CloudEOS2Intf0",
    "${var.topology}-Leaf7CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf7CloudEOS2Intf0" = "internal"
    "${var.topology}-Leaf7CloudEOS2Intf1" = "private"
  }
  subnetids  = {
      "${var.topology}-Leaf7CloudEOS2Intf0" = module.Leaf7Subnet.vpc_subnets[2]
      "${var.topology}-Leaf7CloudEOS2Intf1" = module.Leaf7Subnet.vpc_subnets[3]
  }
  private_ips = {"0": ["10.7.2.101"], "1": ["10.7.3.101"]}
  availability_zone = var.availability_zone[module.Leaf7Vpc.region]["zone2"]
  region            = module.Leaf7Vpc.region
  tags = {
         "Name" = "${var.topology}-Leaf7CloudEOS2"
         "Cnps" = "prod"
  }
  internal_route_table_id = module.Leaf7CloudEOS1.route_table_internal
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  instance_type           = var.instance_type["leaf"]
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}
//Leaf8
module "Leaf8Vpc" {
  source         = "../../../module/cloudeos/aws/vpc"
  topology_name  = var.topology
  clos_name      = "${var.topology}-clos"
  role           = "CloudLeaf"
  cidr_block     = ["10.8.0.0/16"]
  tags = {
    Name = "${var.topology}-Leaf8Vpc"
    Cnps = "prod"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf8Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
     "10.8.0.0/24" = var.availability_zone[module.Leaf8Vpc.region]["zone1"]
     "10.8.1.0/24" = var.availability_zone[module.Leaf8Vpc.region]["zone1"]
     "10.8.2.0/24" = var.availability_zone[module.Leaf8Vpc.region]["zone2"]
     "10.8.3.0/24" = var.availability_zone[module.Leaf8Vpc.region]["zone2"]
  }
  subnet_names = {
     "10.8.0.0/24" = "${var.topology}-Leaf8Subnet0"
     "10.8.1.0/24" = "${var.topology}-Leaf8Subnet1"
     "10.8.2.0/24" = "${var.topology}-Leaf8Subnet2"
     "10.8.3.0/24" = "${var.topology}-Leaf8Subnet3"
   }
  vpc_id = module.Leaf8Vpc.vpc_id[0]
  topology_name = module.Leaf8Vpc.topology_name
  region = module.Leaf8Vpc.region
}

module "Leaf8CloudEOS1" {
  source = "../../../module/cloudeos/aws/router"
  role = "CloudLeaf"
  topology_name = module.Leaf8Vpc.topology_name
  cloudeos_ami = local.eos_amis[module.Leaf8Vpc.region]
  keypair_name = var.keypair_name[module.Leaf8Vpc.region]
  vpc_info = module.Leaf8Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf8CloudEOS1Intf0",
    "${var.topology}-Leaf8CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf8CloudEOS1Intf0" = "internal"
    "${var.topology}-Leaf8CloudEOS1Intf1" = "private"
  }
  subnetids  = {
      "${var.topology}-Leaf8CloudEOS1Intf0" = module.Leaf8Subnet.vpc_subnets[0]
      "${var.topology}-Leaf8CloudEOS1Intf1" = module.Leaf8Subnet.vpc_subnets[1]
  }
  private_ips = {"0": ["10.8.0.101"], "1": ["10.8.1.101"]}
  availability_zone = var.availability_zone[module.Leaf8Vpc.region]["zone1"]
  region            = module.Leaf8Vpc.region
  tags = {
         "Name" = "${var.topology}-Leaf8CloudEOS1"
         "Cnps" = "prod"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Leaf8CloudEOS2" {
  source = "../../../module/cloudeos/aws/router"
  role = "CloudLeaf"
  topology_name = module.Leaf8Vpc.topology_name
  cloudeos_ami = local.eos_amis[module.Leaf8Vpc.region]
  keypair_name = var.keypair_name[module.Leaf8Vpc.region]
  vpc_info = module.Leaf8Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf8CloudEOS2Intf0",
    "${var.topology}-Leaf8CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf8CloudEOS2Intf0" = "internal"
    "${var.topology}-Leaf8CloudEOS2Intf1" = "private"
  }
  subnetids  = {
      "${var.topology}-Leaf8CloudEOS2Intf0" = module.Leaf8Subnet.vpc_subnets[2]
      "${var.topology}-Leaf8CloudEOS2Intf1" = module.Leaf8Subnet.vpc_subnets[3]
  }
  private_ips = {"0": ["10.8.2.101"], "1": ["10.8.3.101"]}
  availability_zone = var.availability_zone[module.Leaf8Vpc.region]["zone2"]
  region            = module.Leaf8Vpc.region
  tags = {
         "Name" = "${var.topology}-Leaf8CloudEOS2"
         "Cnps" = "prod"
  }
  internal_route_table_id = module.Leaf8CloudEOS1.route_table_internal
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  instance_type           = var.instance_type["leaf"]
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}
//Leaf9
module "Leaf9Vpc" {
  source         = "../../../module/cloudeos/aws/vpc"
  topology_name  = var.topology
  clos_name      = "${var.topology}-clos"
  role           = "CloudLeaf"
  cidr_block     = ["10.9.0.0/16"]
  tags = {
    Name = "${var.topology}-Leaf9Vpc"
    Cnps = "prod"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Leaf9Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
     "10.9.0.0/24" = var.availability_zone[module.Leaf9Vpc.region]["zone1"]
     "10.9.1.0/24" = var.availability_zone[module.Leaf9Vpc.region]["zone1"]
     "10.9.2.0/24" = var.availability_zone[module.Leaf9Vpc.region]["zone2"]
     "10.9.3.0/24" = var.availability_zone[module.Leaf9Vpc.region]["zone2"]
  }
  subnet_names = {
     "10.9.0.0/24" = "${var.topology}-Leaf9Subnet0"
     "10.9.1.0/24" = "${var.topology}-Leaf9Subnet1"
     "10.9.2.0/24" = "${var.topology}-Leaf9Subnet2"
     "10.9.3.0/24" = "${var.topology}-Leaf9Subnet3"
   }
  vpc_id = module.Leaf9Vpc.vpc_id[0]
  topology_name = module.Leaf9Vpc.topology_name
  region = module.Leaf9Vpc.region
}

module "Leaf9CloudEOS1" {
  source = "../../../module/cloudeos/aws/router"
  role = "CloudLeaf"
  topology_name = module.Leaf9Vpc.topology_name
  cloudeos_ami = local.eos_amis[module.Leaf9Vpc.region]
  keypair_name = var.keypair_name[module.Leaf9Vpc.region]
  vpc_info = module.Leaf9Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf9CloudEOS1Intf0",
    "${var.topology}-Leaf9CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf9CloudEOS1Intf0" = "internal"
    "${var.topology}-Leaf9CloudEOS1Intf1" = "private"
  }
  subnetids  = {
      "${var.topology}-Leaf9CloudEOS1Intf0" = module.Leaf9Subnet.vpc_subnets[0]
      "${var.topology}-Leaf9CloudEOS1Intf1" = module.Leaf9Subnet.vpc_subnets[1]
  }
  private_ips = {"0": ["10.9.0.101"], "1": ["10.9.1.101"]}
  availability_zone = var.availability_zone[module.Leaf9Vpc.region]["zone1"]
  region            = module.Leaf9Vpc.region
  tags = {
         "Name" = "${var.topology}-Leaf9CloudEOS1"
         "Cnps" = "prod"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Leaf9CloudEOS2" {
  source = "../../../module/cloudeos/aws/router"
  role = "CloudLeaf"
  topology_name = module.Leaf9Vpc.topology_name
  cloudeos_ami = local.eos_amis[module.Leaf9Vpc.region]
  keypair_name = var.keypair_name[module.Leaf9Vpc.region]
  vpc_info = module.Leaf9Vpc.vpc_info
  intf_names = [
    "${var.topology}-Leaf9CloudEOS2Intf0",
    "${var.topology}-Leaf9CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Leaf9CloudEOS2Intf0" = "internal"
    "${var.topology}-Leaf9CloudEOS2Intf1" = "private"
  }
  subnetids  = {
      "${var.topology}-Leaf9CloudEOS2Intf0" = module.Leaf9Subnet.vpc_subnets[2]
      "${var.topology}-Leaf9CloudEOS2Intf1" = module.Leaf9Subnet.vpc_subnets[3]
  }
  private_ips = {"0": ["10.9.2.101"], "1": ["10.9.3.101"]}
  availability_zone = var.availability_zone[module.Leaf9Vpc.region]["zone2"]
  region            = module.Leaf9Vpc.region
  tags = {
         "Name" = "${var.topology}-Leaf9CloudEOS2"
         "Cnps" = "prod"
  }
  internal_route_table_id = module.Leaf9CloudEOS1.route_table_internal
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  instance_type           = var.instance_type["leaf"]
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}
*/
