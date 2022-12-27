provider "cloudeos" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

output "leafAndHostIPs" {
  value = {
    "Reg2Leaf1EOS1" : module.Region2Leaf1CloudEOS1.intf_private_ips,
    "Reg2Leaf1EOS2" : module.Region2Leaf1CloudEOS2.intf_private_ips,
    "Reg2Leaf2EOS1" : module.Region2Leaf2CloudEOS1.intf_private_ips,
    "Reg2Leaf2EOS2" : module.Region2Leaf2CloudEOS2.intf_private_ips,
    "Reg3Leaf1EOS1" : module.Region3Leaf1CloudEOS1.intf_private_ips,
    "Reg3Leaf1EOS2" : module.Region3Leaf1CloudEOS2.intf_private_ips,
    "Reg3Leaf2EOS1" : module.Region3Leaf2CloudEOS1.intf_private_ips,
    "Reg3Leaf2EOS2" : module.Region3Leaf2CloudEOS2.intf_private_ips,
    "Reg2Leaf1host1" : module.Region2Leaf1host1.intf_private_ips,
    "Reg2Leaf1host2" : module.Region2Leaf1host2.intf_private_ips,
    "Reg2Leaf2Host1" : module.Region2Leaf2host1.intf_private_ips,
    "Reg2Leaf2Host2" : module.Region2Leaf2host2.intf_private_ips,
    "Reg3Leaf1Host1" : module.Region3Leaf1host1.intf_private_ips,
    "Reg3Leaf1Host2" : module.Region3Leaf1host2.intf_private_ips,
    "Reg3Leaf2Host1" : module.Region3Leaf2host1.intf_private_ips,
    "Reg3Leaf2Host2" : module.Region3Leaf2host2.intf_private_ips,
  }
}

//Region2 Leafs
module "Region2Leaf1Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos-aws"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["region2_leaf1_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Region2Leaf1Vpc"
    Cnps = "dev"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Region2Leaf1Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["region2_leaf1_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Region2Leaf1Vpc.region]["zone1"]
    (var.vpc_info["region2_leaf1_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Region2Leaf1Vpc.region]["zone1"]
    (var.vpc_info["region2_leaf1_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.Region2Leaf1Vpc.region]["zone2"]
    (var.vpc_info["region2_leaf1_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.Region2Leaf1Vpc.region]["zone2"]
  }
  subnet_names = {
   (var.vpc_info["region2_leaf1_vpc"]["subnet_cidr"][0]) = "${var.topology}-Region2Leaf1Subnet0"
   (var.vpc_info["region2_leaf1_vpc"]["subnet_cidr"][1]) = "${var.topology}-Region2Leaf1Subnet1"
   (var.vpc_info["region2_leaf1_vpc"]["subnet_cidr"][2]) = "${var.topology}-Region2Leaf1Subnet2"
   (var.vpc_info["region2_leaf1_vpc"]["subnet_cidr"][3]) = "${var.topology}-Region2Leaf1Subnet3"
  }
  vpc_id        = module.Region2Leaf1Vpc.vpc_id[0]
  topology_name = module.Region2Leaf1Vpc.topology_name
  region        = module.Region2Leaf1Vpc.region
}

module "Region2Leaf1CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf1Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Region2Leaf1Vpc.region]
  keypair_name  = var.keypair_name[module.Region2Leaf1Vpc.region]
  vpc_info      = module.Region2Leaf1Vpc.vpc_info
  intf_names = [
    "${var.topology}-Region2Leaf1CloudEOS1Intf0",
    "${var.topology}-Region2Leaf1CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Region2Leaf1CloudEOS1Intf0" = "internal"
    "${var.topology}-Region2Leaf1CloudEOS1Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Region2Leaf1CloudEOS1Intf0" = module.Region2Leaf1Subnet.vpc_subnets[0]
    "${var.topology}-Region2Leaf1CloudEOS1Intf1" = module.Region2Leaf1Subnet.vpc_subnets[1]
  }
  private_ips       = { "0" : [(var.vpc_info["region2_leaf1_vpc"]["interface_ips"][0])], "1" : [(var.vpc_info["region2_leaf1_vpc"]["interface_ips"][1])] }
  availability_zone = var.availability_zone[module.Region2Leaf1Vpc.region]["zone1"]
  region            = module.Region2Leaf1Vpc.region
  tags = {
    "Name" = "${var.topology}-Region2Leaf1CloudEOS1", "autostop" : "no", "autoterminate" : "no"
    "Cnps" = "dev"
  }
  cloud_ha             = "leaf2"
  primary              = true
  iam_instance_profile = var.aws_iam_instance_profile
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Region2Leaf1host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Region2Leaf1Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region2Leaf1Vpc.region]
  subnet_id     = module.Region2Leaf1Subnet.vpc_subnets[1]
  private_ips   = [(var.vpc_info["region2_leaf1_vpc"]["interface_ips"][4])]
  tags = {
    "Name" = "${var.topology}-Region2Leaf1host1", "autostop" : "no", "autoterminate" : "no"
  }
}

module "Region2Leaf1CloudEOS2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf1Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Region2Leaf1Vpc.region]
  keypair_name  = var.keypair_name[module.Region2Leaf1Vpc.region]
  vpc_info      = module.Region2Leaf1Vpc.vpc_info
  intf_names = [
    "${var.topology}-Region2Leaf1CloudEOS2Intf0",
    "${var.topology}-Region2Leaf1CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Region2Leaf1CloudEOS2Intf0" = "internal"
    "${var.topology}-Region2Leaf1CloudEOS2Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Region2Leaf1CloudEOS2Intf0" = module.Region2Leaf1Subnet.vpc_subnets[2]
    "${var.topology}-Region2Leaf1CloudEOS2Intf1" = module.Region2Leaf1Subnet.vpc_subnets[3]
  }
  private_ips       = { "0" : [(var.vpc_info["region2_leaf1_vpc"]["interface_ips"][2])], "1" : [(var.vpc_info["region2_leaf1_vpc"]["interface_ips"][3])] }
  availability_zone = var.availability_zone[module.Region2Leaf1Vpc.region]["zone2"]
  region            = module.Region2Leaf1Vpc.region
  tags = {
    "Name" = "${var.topology}-Region2Leaf1CloudEOS2", "autostop" : "no", "autoterminate" : "no"
    "Cnps" = "dev"
  }
  cloud_ha                   = "leaf2"
  internal_route_table_id    = module.Region2Leaf1CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Region2Leaf1Subnet.vpc_subnets[0]]
  iam_instance_profile       = var.aws_iam_instance_profile
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
  instance_type              = var.instance_type["leaf"]
  licenses                   = var.licenses
  cloudeos_image_offer       = var.cloudeos_image_offer
}

module "Region2Leaf1host2" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Region2Leaf1Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region2Leaf1Vpc.region]
  subnet_id     = module.Region2Leaf1Subnet.vpc_subnets[3]
  private_ips   = [(var.vpc_info["region2_leaf1_vpc"]["interface_ips"][5])]
  tags = {
    "Name" = "${var.topology}-Region2Leaf1host2", "autostop" : "no", "autoterminate" : "no"
  }
}

module "Region2Leaf2Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos-aws"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["region2_leaf2_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Region2Leaf2Vpc"
    Cnps = "prod"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Region2Leaf2Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
   (var.vpc_info["region2_leaf2_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Region2Leaf2Vpc.region]["zone1"]
   (var.vpc_info["region2_leaf2_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Region2Leaf2Vpc.region]["zone1"]
   (var.vpc_info["region2_leaf2_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.Region2Leaf2Vpc.region]["zone2"]
   (var.vpc_info["region2_leaf2_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.Region2Leaf2Vpc.region]["zone2"]
  }
  subnet_names = {
   (var.vpc_info["region2_leaf2_vpc"]["subnet_cidr"][0]) = "${var.topology}-Region2Leaf2Subnet0"
   (var.vpc_info["region2_leaf2_vpc"]["subnet_cidr"][1]) = "${var.topology}-Region2Leaf2Subnet1"
   (var.vpc_info["region2_leaf2_vpc"]["subnet_cidr"][2]) = "${var.topology}-Region2Leaf2Subnet2"
   (var.vpc_info["region2_leaf2_vpc"]["subnet_cidr"][3]) = "${var.topology}-Region2Leaf2Subnet3"
  }
  vpc_id        = module.Region2Leaf2Vpc.vpc_id[0]
  topology_name = module.Region2Leaf2Vpc.topology_name
  region        = module.Region2Leaf2Vpc.region
}

module "Region2Leaf2CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf2Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Region2Leaf2Vpc.region]
  keypair_name  = var.keypair_name[module.Region2Leaf2Vpc.region]
  vpc_info      = module.Region2Leaf2Vpc.vpc_info
  intf_names = [
    "${var.topology}-Region2Leaf2CloudEOS1Intf0",
    "${var.topology}-Region2Leaf2CloudEOS1Intf1"
  ]
  interface_types = {
    "${var.topology}-Region2Leaf2CloudEOS1Intf0" = "internal"
    "${var.topology}-Region2Leaf2CloudEOS1Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Region2Leaf2CloudEOS1Intf0" = module.Region2Leaf2Subnet.vpc_subnets[0]
    "${var.topology}-Region2Leaf2CloudEOS1Intf1" = module.Region2Leaf2Subnet.vpc_subnets[1]
  }
  private_ips       = { "0" : [(var.vpc_info["region2_leaf2_vpc"]["interface_ips"][0])], "1" : [(var.vpc_info["region2_leaf2_vpc"]["interface_ips"][1])] }
  availability_zone = var.availability_zone[module.Region2Leaf2Vpc.region]["zone1"]
  region            = module.Region2Leaf2Vpc.region
  tags = {
    "Name" = "${var.topology}-Region2Leaf2CloudEOS1", "autostop" : "no", "autoterminate" : "no"
    "Cnps" = "prod"
  }
  cloud_ha             = "leaf2"
  iam_instance_profile = var.aws_iam_instance_profile
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Region2Leaf2host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Region2Leaf2Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region2Leaf2Vpc.region]
  subnet_id     = module.Region2Leaf2Subnet.vpc_subnets[1]
  private_ips   = [(var.vpc_info["region2_leaf2_vpc"]["interface_ips"][4])]
  tags = {
    "Name" = "${var.topology}-Region2Leaf2host", "autostop" : "no", "autoterminate" : "no"
  }
}

module "Region2Leaf2CloudEOS2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf2Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Region2Leaf2Vpc.region]
  keypair_name  = var.keypair_name[module.Region2Leaf2Vpc.region]
  vpc_info      = module.Region2Leaf2Vpc.vpc_info
  intf_names = [
    "${var.topology}-Region2Leaf2CloudEOS2Intf0",
    "${var.topology}-Region2Leaf2CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Region2Leaf2CloudEOS2Intf0" = "internal"
    "${var.topology}-Region2Leaf2CloudEOS2Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Region2Leaf2CloudEOS2Intf0" = module.Region2Leaf2Subnet.vpc_subnets[2]
    "${var.topology}-Region2Leaf2CloudEOS2Intf1" = module.Region2Leaf2Subnet.vpc_subnets[3]
  }
  private_ips       = { "0" : [(var.vpc_info["region2_leaf2_vpc"]["interface_ips"][2])], "1" : [(var.vpc_info["region2_leaf2_vpc"]["interface_ips"][3])] }
  availability_zone = var.availability_zone[module.Region2Leaf2Vpc.region]["zone2"]
  region            = module.Region2Leaf2Vpc.region
  tags = {
    "Name" = "${var.topology}-Region2Leaf2CloudEOS2", "autostop" : "no", "autoterminate" : "no"
    "Cnps" = "prod"
  }
  cloud_ha                   = "leaf2"
  internal_route_table_id    = module.Region2Leaf2CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Region2Leaf2Subnet.vpc_subnets[0]]
  iam_instance_profile       = var.aws_iam_instance_profile
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
  instance_type              = var.instance_type["leaf"]
  licenses                   = var.licenses
  cloudeos_image_offer       = var.cloudeos_image_offer
}

module "Region2Leaf2host2" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Region2Leaf2Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region2Leaf2Vpc.region]
  subnet_id     = module.Region2Leaf2Subnet.vpc_subnets[3]
  private_ips   = [(var.vpc_info["region2_leaf2_vpc"]["interface_ips"][5])]
  tags = {
    "Name" = "${var.topology}-Region2Leaf2host", "autostop" : "no", "autoterminate" : "no"
  }
}

//Region3 Leafs

module "Region3Leaf1Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos-aws"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["region3_leaf1_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Region3Leaf1Vpc"
    Cnps = "dev"
  }
  region = var.aws_regions["region3"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Region3Leaf1Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Region3Leaf1Vpc.region]["zone1"]
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][1])  = var.availability_zone[module.Region3Leaf1Vpc.region]["zone1"]
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][2])  = var.availability_zone[module.Region3Leaf1Vpc.region]["zone2"]
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][3])  = var.availability_zone[module.Region3Leaf1Vpc.region]["zone2"]
  }
  subnet_names = {
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][0]) = "${var.topology}-Region3Leaf1Subnet0"
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][1]) = "${var.topology}-Region3Leaf1Subnet1"
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][2]) = "${var.topology}-Region3Leaf1Subnet2"
    (var.vpc_info["region3_leaf1_vpc"]["subnet_cidr"][3]) = "${var.topology}-Region3Leaf1Subnet3"
  }
  vpc_id        = module.Region3Leaf1Vpc.vpc_id[0]
  topology_name = module.Region3Leaf1Vpc.topology_name
  region        = module.Region3Leaf1Vpc.region
}

module "Region3Leaf1CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Region3Leaf1Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Region3Leaf1Vpc.region]
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
    "Name" = "${var.topology}-Region3Leaf1CloudEOS1", "autostop" : "no", "autoterminate" : "no"
    "Cnps" = "dev"
  }
  cloud_ha             = "leaf3"
  primary              = true
  iam_instance_profile = var.aws_iam_instance_profile
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Region3Leaf1host1" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Region3Leaf1Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region3Leaf1Vpc.region]
  subnet_id     = module.Region3Leaf1Subnet.vpc_subnets[1]
  private_ips   = [(var.vpc_info["region3_leaf1_vpc"]["interface_ips"][4])]
  tags = {
    "Name" = "${var.topology}-Region3Leaf1host1", "autostop" : "no", "autoterminate" : "no"
  }
}

module "Region3Leaf1CloudEOS2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Region3Leaf1Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Region3Leaf1Vpc.region]
  keypair_name  = var.keypair_name[module.Region3Leaf1Vpc.region]
  vpc_info      = module.Region3Leaf1Vpc.vpc_info
  intf_names = [
    "${var.topology}-Region3Leaf1CloudEOS2Intf0",
    "${var.topology}-Region3Leaf1CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Region3Leaf1CloudEOS2Intf0" = "internal"
    "${var.topology}-Region3Leaf1CloudEOS2Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Region3Leaf1CloudEOS2Intf0" = module.Region3Leaf1Subnet.vpc_subnets[2]
    "${var.topology}-Region3Leaf1CloudEOS2Intf1" = module.Region3Leaf1Subnet.vpc_subnets[3]
  }
  private_ips       = { "0" : [(var.vpc_info["region3_leaf1_vpc"]["interface_ips"][2])], "1" : [(var.vpc_info["region3_leaf1_vpc"]["interface_ips"][3])] }
  availability_zone = var.availability_zone[module.Region3Leaf1Vpc.region]["zone2"]
  region            = module.Region3Leaf1Vpc.region
  tags = {
    "Name" = "${var.topology}-Region3Leaf1CloudEOS2", "autostop" : "no", "autoterminate" : "no"
    "Cnps" = "dev"
  }
  cloud_ha                   = "leaf3"
  internal_route_table_id    = module.Region3Leaf1CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Region3Leaf1Subnet.vpc_subnets[0]]
  iam_instance_profile       = var.aws_iam_instance_profile
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
  instance_type              = var.instance_type["leaf"]
  licenses                   = var.licenses
  cloudeos_image_offer       = var.cloudeos_image_offer
}

module "Region3Leaf1host2" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Region3Leaf1Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region3Leaf1Vpc.region]
  subnet_id     = module.Region3Leaf1Subnet.vpc_subnets[3]
  private_ips   = [(var.vpc_info["region3_leaf1_vpc"]["interface_ips"][5])]
  tags = {
    "Name" = "${var.topology}-Region3Leaf1host2", "autostop" : "no", "autoterminate" : "no"
  }
}

module "Region3Leaf2Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos-aws"
  role          = "CloudLeaf"
  cidr_block    = [(var.vpc_info["region3_leaf2_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Region3Leaf2Vpc"
    Cnps = "dev"
  }
  region = var.aws_regions["region3"]
  default_ingress_sg_cidrs = var.ingress_allowlist["leaf_vpc"]["default"]
}

module "Region3Leaf2Subnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Region3Leaf2Vpc.region]["zone1"]
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Region3Leaf2Vpc.region]["zone1"]
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.Region3Leaf2Vpc.region]["zone2"]
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.Region3Leaf2Vpc.region]["zone2"]
  }
  subnet_names = {
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][0]) = "${var.topology}-Region3Leaf2Subnet0"
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][1]) = "${var.topology}-Region3Leaf2Subnet1"
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][2]) = "${var.topology}-Region3Leaf2Subnet2"
    (var.vpc_info["region3_leaf2_vpc"]["subnet_cidr"][3]) = "${var.topology}-Region3Leaf2Subnet3"
  }
  vpc_id        = module.Region3Leaf2Vpc.vpc_id[0]
  topology_name = module.Region3Leaf2Vpc.topology_name
  region        = module.Region3Leaf2Vpc.region
}

module "Region3Leaf2CloudEOS1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Region3Leaf2Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Region3Leaf2Vpc.region]
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
    "Name" = "${var.topology}-Region3Leaf2CloudEOS1", "autostop" : "no", "autoterminate" : "no"
    "Cnps" = "dev"
  }
  cloud_ha             = "leaf4"
  iam_instance_profile = var.aws_iam_instance_profile
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["leaf"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "Region3Leaf2host1" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Region3Leaf2Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region3Leaf2Vpc.region]
  subnet_id     = module.Region3Leaf2Subnet.vpc_subnets[1]
  private_ips   = [(var.vpc_info["region3_leaf2_vpc"]["interface_ips"][4])]
  tags = {
    "Name" = "${var.topology}-Region3Leaf2host1", "autostop" : "no", "autoterminate" : "no"
  }
}

module "Region3Leaf2CloudEOS2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudLeaf"
  topology_name = module.Region3Leaf2Vpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Region3Leaf2Vpc.region]
  keypair_name  = var.keypair_name[module.Region3Leaf2Vpc.region]
  vpc_info      = module.Region3Leaf2Vpc.vpc_info
  intf_names = [
    "${var.topology}-Region3Leaf2CloudEOS2Intf0",
    "${var.topology}-Region3Leaf2CloudEOS2Intf1"
  ]
  interface_types = {
    "${var.topology}-Region3Leaf2CloudEOS2Intf0" = "internal"
    "${var.topology}-Region3Leaf2CloudEOS2Intf1" = "private"
  }
  subnetids = {
    "${var.topology}-Region3Leaf2CloudEOS2Intf0" = module.Region3Leaf2Subnet.vpc_subnets[2]
    "${var.topology}-Region3Leaf2CloudEOS2Intf1" = module.Region3Leaf2Subnet.vpc_subnets[3]
  }
  private_ips       = { "0" : [(var.vpc_info["region3_leaf2_vpc"]["interface_ips"][2])], "1" : [(var.vpc_info["region3_leaf2_vpc"]["interface_ips"][3])] }
  availability_zone = var.availability_zone[module.Region3Leaf2Vpc.region]["zone2"]
  region            = module.Region3Leaf2Vpc.region
  tags = {
    "Name" = "${var.topology}-Region3Leaf2CloudEOS2", "autostop" : "no", "autoterminate" : "no"
    "Cnps" = "dev"
  }
  cloud_ha                   = "leaf4"
  internal_route_table_id    = module.Region3Leaf2CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Region3Leaf2Subnet.vpc_subnets[0]]
  iam_instance_profile       = var.aws_iam_instance_profile
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
  instance_type              = var.instance_type["leaf"]
  licenses                   = var.licenses
  cloudeos_image_offer       = var.cloudeos_image_offer
}

module "Region3Leaf2host2" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/cloudeos/aws/host"
  ami           = var.host_amis[module.Region3Leaf2Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region3Leaf2Vpc.region]
  subnet_id     = module.Region3Leaf2Subnet.vpc_subnets[3]
  private_ips   = [(var.vpc_info["region3_leaf2_vpc"]["interface_ips"][5])]
  tags = {
    "Name" = "${var.topology}-Region3Leaf2host2", "autostop" : "no", "autoterminate" : "no"
  }
}
