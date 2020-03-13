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
    "101.2.2.0/24" = lookup(module.globals.availability_zone[module.Region2Leaf1Vpc.region], "zone2", "")
    "101.2.3.0/24" = lookup(module.globals.availability_zone[module.Region2Leaf1Vpc.region], "zone2", "")
  }
  subnet_names = {
    "101.2.0.0/24" = "${module.globals.topology}-Region2Leaf1Subnet0"
    "101.2.1.0/24" = "${module.globals.topology}-Region2Leaf1Subnet1"
    "101.2.2.0/24" = "${module.globals.topology}-Region2Leaf1Subnet2"
    "101.2.3.0/24" = "${module.globals.topology}-Region2Leaf1Subnet3"
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
  cloud_ha             = "leaf2"
  primary              = true
  iam_instance_profile = var.aws_iam_instance_profile
  filename             = "../../../userdata/eos_ipsec_config.tpl"
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
    "Name" = "${module.globals.topology}-Region2Leaf1host1"
  }
}

module "Region2Leaf1CloudEOS2" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudLeaf"
  topology_name = module.Region2Leaf1Vpc.topology_name
  cloudeos_ami  = module.globals.eos_amis[module.Region2Leaf1Vpc.region]
  keypair_name  = module.globals.keypair_name[module.Region2Leaf1Vpc.region]
  vpc_info      = module.Region2Leaf1Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Region2Leaf1CloudEOS2Intf0",
    "${module.globals.topology}-Region2Leaf1CloudEOS2Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Region2Leaf1CloudEOS2Intf0" = "internal"
    "${module.globals.topology}-Region2Leaf1CloudEOS2Intf1" = "private"
  }
  subnetids = {
    "${module.globals.topology}-Region2Leaf1CloudEOS2Intf0" = module.Region2Leaf1Subnet.vpc_subnets[2]
    "${module.globals.topology}-Region2Leaf1CloudEOS2Intf1" = module.Region2Leaf1Subnet.vpc_subnets[3]
  }
  private_ips       = { "0" : ["101.2.2.101"], "1" : ["101.2.3.101"] }
  availability_zone = lookup(module.globals.availability_zone[module.Region2Leaf1Vpc.region], "zone2", "")
  region            = module.Region2Leaf1Vpc.region
  tags = {
    "Name" = "${module.globals.topology}-Region2Leaf1CloudEOS2"
    "Cnps" = "Dev"
  }
  cloud_ha                   = "leaf2"
  internal_route_table_id    = module.Region2Leaf1CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Region2Leaf1Subnet.vpc_subnets[0]]
  iam_instance_profile       = var.aws_iam_instance_profile
  filename                   = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region2Leaf1host2" {
  region        = module.globals.aws_regions["region2"]
  source        = "../../../module/arista/aws/host"
  ami           = module.globals.host_amis[module.Region2Leaf1Vpc.region]
  instance_type = "c5.xlarge"
  keypair_name  = module.globals.keypair_name[module.Region2Leaf1Vpc.region]
  subnet_id     = module.Region2Leaf1Subnet.vpc_subnets[3]
  private_ips   = ["101.2.3.102"]
  tags = {
    "Name" = "${module.globals.topology}-Region2Leaf1host2"
  }
}

