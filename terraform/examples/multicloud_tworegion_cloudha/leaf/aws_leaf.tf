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
  cidr_block    = ["10.7.0/16"]
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
    "10.7.0.0/24" = var.availability_zone[module.Region2Leaf1Vpc.region]["zone1"]
    "10.7.1.0/24" = var.availability_zone[module.Region2Leaf1Vpc.region]["zone1"]
    "10.7.2.0/24" = var.availability_zone[module.Region2Leaf1Vpc.region]["zone2"]
    "10.7.3.0/24" = var.availability_zone[module.Region2Leaf1Vpc.region]["zone2"]
  }
  subnet_names = {
    "10.7.0.0/24" = "${var.topology}-Region2Leaf1Subnet0"
    "10.7.1.0/24" = "${var.topology}-Region2Leaf1Subnet1"
    "10.7.2.0/24" = "${var.topology}-Region2Leaf1Subnet2"
    "10.7.3.0/24" = "${var.topology}-Region2Leaf1Subnet3"
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
  private_ips       = { "0" : ["10.7.0.101"], "1" : ["10.7.1.101"] }
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
  private_ips   = ["10.7.1.102"]
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
  private_ips       = { "0" : ["10.7.2.101"], "1" : ["10.7.3.101"] }
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
  private_ips   = ["10.7.3.102"]
  tags = {
    "Name" = "${var.topology}-Region2Leaf1host2", "autostop" : "no", "autoterminate" : "no"
  }
}

module "Region2Leaf2Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos-aws"
  role          = "CloudLeaf"
  cidr_block    = ["10.8.0.0/16"]
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
    "10.8.0.0/24" = var.availability_zone[module.Region2Leaf2Vpc.region]["zone1"]
    "10.8.1.0/24" = var.availability_zone[module.Region2Leaf2Vpc.region]["zone1"]
    "10.8.2.0/24" = var.availability_zone[module.Region2Leaf2Vpc.region]["zone2"]
    "10.8.3.0/24" = var.availability_zone[module.Region2Leaf2Vpc.region]["zone2"]
  }
  subnet_names = {
    "10.8.0.0/24" = "${var.topology}-Region2Leaf2Subnet0"
    "10.8.1.0/24" = "${var.topology}-Region2Leaf2Subnet1"
    "10.8.2.0/24" = "${var.topology}-Region2Leaf2Subnet2"
    "10.8.3.0/24" = "${var.topology}-Region2Leaf2Subnet3"
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
  private_ips       = { "0" : ["10.8.0.101"], "1" : ["10.8.1.101"] }
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
  private_ips   = ["10.8.1.102"]
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
  private_ips       = { "0" : ["10.8.2.101"], "1" : ["10.8.3.101"] }
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
  private_ips   = ["10.8.3.102"]
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
  cidr_block    = ["10.9.0.0/16"]
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
    "10.9.0.0/24" = var.availability_zone[module.Region3Leaf1Vpc.region]["zone1"]
    "10.9.1.0/24" = var.availability_zone[module.Region3Leaf1Vpc.region]["zone1"]
    "10.9.2.0/24" = var.availability_zone[module.Region3Leaf1Vpc.region]["zone2"]
    "10.9.3.0/24" = var.availability_zone[module.Region3Leaf1Vpc.region]["zone2"]
  }
  subnet_names = {
    "10.9.0.0/24" = "${var.topology}-Region3Leaf1Subnet0"
    "10.9.1.0/24" = "${var.topology}-Region3Leaf1Subnet1"
    "10.9.2.0/24" = "${var.topology}-Region3Leaf1Subnet2"
    "10.9.3.0/24" = "${var.topology}-Region3Leaf1Subnet3"
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
  private_ips       = { "0" : ["10.9.0.101"], "1" : ["10.9.1.101"] }
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
  private_ips   = ["10.9.1.102"]
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
  private_ips       = { "0" : ["10.9.2.101"], "1" : ["10.9.3.101"] }
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
  private_ips   = ["10.9.3.102"]
  tags = {
    "Name" = "${var.topology}-Region3Leaf1host2", "autostop" : "no", "autoterminate" : "no"
  }
}

module "Region3Leaf2Vpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos-aws"
  role          = "CloudLeaf"
  cidr_block    = ["10.10.0.0/16"]
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
    "10.10.0.0/24" = var.availability_zone[module.Region3Leaf2Vpc.region]["zone1"]
    "10.10.1.0/24" = var.availability_zone[module.Region3Leaf2Vpc.region]["zone1"]
    "10.10.2.0/24" = var.availability_zone[module.Region3Leaf2Vpc.region]["zone2"]
    "10.10.3.0/24" = var.availability_zone[module.Region3Leaf2Vpc.region]["zone2"]
  }
  subnet_names = {
    "10.10.0.0/24" = "${var.topology}-Region3Leaf2Subnet0"
    "10.10.1.0/24" = "${var.topology}-Region3Leaf2Subnet1"
    "10.10.2.0/24" = "${var.topology}-Region3Leaf2Subnet2"
    "10.10.3.0/24" = "${var.topology}-Region3Leaf2Subnet3"
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
  private_ips       = { "0" : ["10.10.0.101"], "1" : ["10.10.1.101"] }
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
  private_ips   = ["10.10.1.102"]
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
  private_ips       = { "0" : ["10.10.2.101"], "1" : ["10.10.3.101"] }
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
  private_ips   = ["10.10.3.102"]
  tags = {
    "Name" = "${var.topology}-Region3Leaf2host2", "autostop" : "no", "autoterminate" : "no"
  }
}
