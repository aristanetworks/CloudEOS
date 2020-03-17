provider "arista" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_username            = var.cvaas["username"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

//Region2 Leafs
module "Region2Leaf1Vpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = ["101.2.0.0/16"]
  tags = {
    Name = "${var.topology}-Region2Leaf1Vpc"
    Cnps = "Dev"
  }
  region = var.aws_regions["region2"]
}

module "Region2Leaf1Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
    "101.2.0.0/24" = var.availability_zone[module.Region2Leaf1Vpc.region]["zone1"]
    "101.2.1.0/24" = var.availability_zone[module.Region2Leaf1Vpc.region]["zone1"]
    "101.2.2.0/24" = var.availability_zone[module.Region2Leaf1Vpc.region]["zone2"]
    "101.2.3.0/24" = var.availability_zone[module.Region2Leaf1Vpc.region]["zone2"]
  }
  subnet_names = {
    "101.2.0.0/24" = "${var.topology}-Region2Leaf1Subnet0"
    "101.2.1.0/24" = "${var.topology}-Region2Leaf1Subnet1"
    "101.2.2.0/24" = "${var.topology}-Region2Leaf1Subnet2"
    "101.2.3.0/24" = "${var.topology}-Region2Leaf1Subnet3"
  }
  vpc_id        = module.Region2Leaf1Vpc.vpc_id[0]
  topology_name = module.Region2Leaf1Vpc.topology_name
  region        = module.Region2Leaf1Vpc.region
}

module "Region2Leaf1CloudEOS1" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf1Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region2Leaf1Vpc.region]
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
  private_ips       = { "0" : ["101.2.0.101"], "1" : ["101.2.1.101"] }
  availability_zone = var.availability_zone[module.Region2Leaf1Vpc.region]["zone1"]
  region            = module.Region2Leaf1Vpc.region
  tags = {
    "Name" = "${var.topology}-Region2Leaf1CloudEOS1"
    "Cnps" = "Dev"
  }
  cloud_ha             = "leaf2"
  primary              = true
  iam_instance_profile = var.aws_iam_instance_profile
  filename             = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region2Leaf1host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/arista/aws/host"
  ami           = var.host_amis[module.Region2Leaf1Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region2Leaf1Vpc.region]
  subnet_id     = module.Region2Leaf1Subnet.vpc_subnets[1]
  private_ips   = ["101.2.1.102"]
  tags = {
    "Name" = "${var.topology}-Region2Leaf1host1"
  }
}

module "Region2Leaf1CloudEOS2" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf1Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region2Leaf1Vpc.region]
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
  private_ips       = { "0" : ["101.2.2.101"], "1" : ["101.2.3.101"] }
  availability_zone = var.availability_zone[module.Region2Leaf1Vpc.region]["zone2"]
  region            = module.Region2Leaf1Vpc.region
  tags = {
    "Name" = "${var.topology}-Region2Leaf1CloudEOS2"
    "Cnps" = "Dev"
  }
  cloud_ha                   = "leaf2"
  internal_route_table_id    = module.Region2Leaf1CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Region2Leaf1Subnet.vpc_subnets[0]]
  iam_instance_profile       = var.aws_iam_instance_profile
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region2Leaf1host2" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/arista/aws/host"
  ami           = var.host_amis[module.Region2Leaf1Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region2Leaf1Vpc.region]
  subnet_id     = module.Region2Leaf1Subnet.vpc_subnets[3]
  private_ips   = ["101.2.3.102"]
  tags = {
    "Name" = "${var.topology}-Region2Leaf1host2"
  }
}

module "Region2Leaf2Vpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  role          = "CloudLeaf"
  cidr_block    = ["102.2.0.0/16"]
  tags = {
    Name = "${var.topology}-Region2Leaf2Vpc"
    Cnps = "Prod"
  }
  region = var.aws_regions["region2"]
}

module "Region2Leaf2Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
    "102.2.0.0/24" = var.availability_zone[module.Region2Leaf2Vpc.region]["zone1"]
    "102.2.1.0/24" = var.availability_zone[module.Region2Leaf2Vpc.region]["zone1"]
    "102.2.2.0/24" = var.availability_zone[module.Region2Leaf2Vpc.region]["zone2"]
    "102.2.3.0/24" = var.availability_zone[module.Region2Leaf2Vpc.region]["zone2"]
  }
  subnet_names = {
    "102.2.0.0/24" = "${var.topology}-Region2Leaf2Subnet0"
    "102.2.1.0/24" = "${var.topology}-Region2Leaf2Subnet1"
    "102.2.2.0/24" = "${var.topology}-Region2Leaf2Subnet2"
    "102.2.3.0/24" = "${var.topology}-Region2Leaf2Subnet3"
  }
  vpc_id        = module.Region2Leaf2Vpc.vpc_id[0]
  topology_name = module.Region2Leaf2Vpc.topology_name
  region        = module.Region2Leaf2Vpc.region
}

module "Region2Leaf2CloudEOS1" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf2Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region2Leaf2Vpc.region]
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
  private_ips       = { "0" : ["102.2.0.101"], "1" : ["102.2.1.101"] }
  availability_zone = var.availability_zone[module.Region2Leaf2Vpc.region]["zone1"]
  region            = module.Region2Leaf2Vpc.region
  tags = {
    "Name" = "${var.topology}-Region2Leaf2CloudEOS1"
    "Cnps" = "Prod"
  }
  cloud_ha = "leaf2"
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region2Leaf2host1" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/arista/aws/host"
  ami           = var.host_amis[module.Region2Leaf2Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region2Leaf2Vpc.region]
  subnet_id     = module.Region2Leaf2Subnet.vpc_subnets[1]
  private_ips   = ["102.2.1.102"]
  tags = {
    "Name" = "${var.topology}-Region2Leaf2host"
  }
}

module "Region2Leaf2CloudEOS2" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf2Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region2Leaf2Vpc.region]
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
  private_ips       = { "0" : ["102.2.2.101"], "1" : ["102.2.3.101"] }
  availability_zone = var.availability_zone[module.Region2Leaf2Vpc.region]["zone2"]
  region            = module.Region2Leaf2Vpc.region
  tags = {
    "Name" = "${var.topology}-Region2Leaf2CloudEOS2"
    "Cnps" = "Prod"
  }
  cloud_ha                   = "leaf2"
  internal_route_table_id    = module.Region2Leaf2CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Region2Leaf2Subnet.vpc_subnets[0]]
  iam_instance_profile       = var.aws_iam_instance_profile
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region2Leaf2host2" {
  region        = var.aws_regions["region2"]
  source        = "../../../module/arista/aws/host"
  ami           = var.host_amis[module.Region2Leaf2Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region2Leaf2Vpc.region]
  subnet_id     = module.Region2Leaf2Subnet.vpc_subnets[3]
  private_ips   = ["102.2.3.102"]
  tags = {
    "Name" = "${var.topology}-Region2Leaf2host"
  }
}

//Region3 Leafs

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
    "110.2.2.0/24" = var.availability_zone[module.Region3Leaf1Vpc.region]["zone2"]
    "110.2.3.0/24" = var.availability_zone[module.Region3Leaf1Vpc.region]["zone2"]
  }
  subnet_names = {
    "110.2.0.0/24" = "${var.topology}-Region3Leaf1Subnet0"
    "110.2.1.0/24" = "${var.topology}-Region3Leaf1Subnet1"
    "110.2.2.0/24" = "${var.topology}-Region3Leaf1Subnet2"
    "110.2.3.0/24" = "${var.topology}-Region3Leaf1Subnet3"
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
  cloud_ha             = "leaf3"
  primary              = true
  iam_instance_profile = var.aws_iam_instance_profile
  filename             = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region3Leaf1host1" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/arista/aws/host"
  ami           = var.host_amis[module.Region3Leaf1Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region3Leaf1Vpc.region]
  subnet_id     = module.Region3Leaf1Subnet.vpc_subnets[1]
  private_ips   = ["110.2.1.102"]
  tags = {
    "Name" = "${var.topology}-Region3Leaf1host1"
  }
}

module "Region3Leaf1CloudEOS2" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudLeaf"
  topology_name = module.Region3Leaf1Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region3Leaf1Vpc.region]
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
  private_ips       = { "0" : ["110.2.2.101"], "1" : ["110.2.3.101"] }
  availability_zone = var.availability_zone[module.Region3Leaf1Vpc.region]["zone2"]
  region            = module.Region3Leaf1Vpc.region
  tags = {
    "Name" = "${var.topology}-Region3Leaf1CloudEOS2"
    "Cnps" = "Dev"
  }
  cloud_ha                   = "leaf3"
  internal_route_table_id    = module.Region3Leaf1CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Region3Leaf1Subnet.vpc_subnets[0]]
  iam_instance_profile       = var.aws_iam_instance_profile
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region3Leaf1host2" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/arista/aws/host"
  ami           = var.host_amis[module.Region3Leaf1Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region3Leaf1Vpc.region]
  subnet_id     = module.Region3Leaf1Subnet.vpc_subnets[3]
  private_ips   = ["110.2.3.102"]
  tags = {
    "Name" = "${var.topology}-Region3Leaf1host2"
  }
}

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
    "111.2.2.0/24" = var.availability_zone[module.Region3Leaf2Vpc.region]["zone2"]
    "111.2.3.0/24" = var.availability_zone[module.Region3Leaf2Vpc.region]["zone2"]
  }
  subnet_names = {
    "111.2.0.0/24" = "${var.topology}-Region3Leaf2Subnet0"
    "111.2.1.0/24" = "${var.topology}-Region3Leaf2Subnet1"
    "111.2.2.0/24" = "${var.topology}-Region3Leaf2Subnet2"
    "111.2.3.0/24" = "${var.topology}-Region3Leaf2Subnet3"
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
  cloud_ha = "leaf4"
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region3Leaf2host1" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/arista/aws/host"
  ami           = var.host_amis[module.Region3Leaf2Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region3Leaf2Vpc.region]
  subnet_id     = module.Region3Leaf2Subnet.vpc_subnets[1]
  private_ips   = ["111.2.1.102"]
  tags = {
    "Name" = "${var.topology}-Region3Leaf2host1"
  }
}

module "Region3Leaf2CloudEOS2" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudLeaf"
  topology_name = module.Region3Leaf2Vpc.topology_name
  cloudeos_ami  = var.eos_amis[module.Region3Leaf2Vpc.region]
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
  private_ips       = { "0" : ["111.2.2.101"], "1" : ["111.2.3.101"] }
  availability_zone = var.availability_zone[module.Region3Leaf2Vpc.region]["zone2"]
  region            = module.Region3Leaf2Vpc.region
  tags = {
    "Name" = "${var.topology}-Region3Leaf2CloudEOS2"
    "Cnps" = "Dev"
  }
  cloud_ha                   = "leaf4"
  internal_route_table_id    = module.Region3Leaf2CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Region3Leaf2Subnet.vpc_subnets[0]]
  iam_instance_profile       = var.aws_iam_instance_profile
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region3Leaf2host2" {
  region        = var.aws_regions["region3"]
  source        = "../../../module/arista/aws/host"
  ami           = var.host_amis[module.Region3Leaf2Vpc.region]
  instance_type = "t2.medium"
  keypair_name  = var.keypair_name[module.Region3Leaf2Vpc.region]
  subnet_id     = module.Region3Leaf2Subnet.vpc_subnets[3]
  private_ips   = ["111.2.3.102"]
  tags = {
    "Name" = "${var.topology}-Region3Leaf2host2"
  }
}
