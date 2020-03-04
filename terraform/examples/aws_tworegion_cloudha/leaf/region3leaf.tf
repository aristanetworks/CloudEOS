//=================Region3 Leaf1 CloudEOS1===============================
module "Region3Leaf1Vpc" {
  source         = "../../../module/arista/aws/vpc"
  topology_name  = module.globals.topology
  clos_name      = "${module.globals.topology}-clos"
  role           = "CloudLeaf"
  cidr_block     = ["110.2.0.0/16"]
  tags = {
    Name = "${module.globals.topology}-Region3Leaf1Vpc"
    Cnps = "Dev"
  }
  region = module.globals.aws_regions["region3"]
}

module "Region3Leaf1Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
     "110.2.0.0/24" = lookup( module.globals.availability_zone[module.Region3Leaf1Vpc.region], "zone1", "" )
     "110.2.1.0/24" = lookup( module.globals.availability_zone[module.Region3Leaf1Vpc.region], "zone1", "" )
     "110.2.2.0/24" = lookup( module.globals.availability_zone[module.Region3Leaf1Vpc.region], "zone2", "" )
     "110.2.3.0/24" = lookup( module.globals.availability_zone[module.Region3Leaf1Vpc.region], "zone2", "" )
  }
  subnet_names = {
     "110.2.0.0/24" = "${module.globals.topology}-Region3Leaf1Subnet0"
     "110.2.1.0/24" = "${module.globals.topology}-Region3Leaf1Subnet1"
     "110.2.2.0/24" = "${module.globals.topology}-Region3Leaf1Subnet2"
     "110.2.3.0/24" = "${module.globals.topology}-Region3Leaf1Subnet3"
   }
  vpc_id = module.Region3Leaf1Vpc.vpc_id[0]
  topology_name = module.Region3Leaf1Vpc.topology_name
  region = module.Region3Leaf1Vpc.region
}

module "Region3Leaf1CloudEOS1" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudLeaf"
  topology_name = module.Region3Leaf1Vpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.Region3Leaf1Vpc.region]
  keypair_name = module.globals.keypair_name[module.Region3Leaf1Vpc.region]
  vpc_info = module.Region3Leaf1Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Region3Leaf1CloudEOS1Intf0",
    "${module.globals.topology}-Region3Leaf1CloudEOS1Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Region3Leaf1CloudEOS1Intf0" = "internal"
    "${module.globals.topology}-Region3Leaf1CloudEOS1Intf1" = "private"
  }
  subnetids  = {
      "${module.globals.topology}-Region3Leaf1CloudEOS1Intf0" = module.Region3Leaf1Subnet.vpc_subnets[0]
      "${module.globals.topology}-Region3Leaf1CloudEOS1Intf1" = module.Region3Leaf1Subnet.vpc_subnets[1]
  }
  private_ips = {"0": ["110.2.0.101"], "1": ["110.2.1.101"]}
  availability_zone = lookup( module.globals.availability_zone[module.Region3Leaf1Vpc.region], "zone1", "" )
  region            = module.Region3Leaf1Vpc.region
  tags = {
         "Name" = "${module.globals.topology}-Region3Leaf1CloudEOS1"
         "Cnps" = "Dev"
  }
  cloud_ha = "leaf3"
  primary = true
  iam_instance_profile = var.aws_iam_instance_profile
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region3Leaf1host1" {
		region = module.globals.aws_regions["region3"]
		source = "../../../module/arista/aws/host"
		ami = module.globals.host_amis[module.Region3Leaf1Vpc.region]
		instance_type = "c5.xlarge"
		keypair_name = module.globals.keypair_name[module.Region3Leaf1Vpc.region]
		subnet_id = module.Region3Leaf1Subnet.vpc_subnets[1]
		private_ips = ["110.2.1.102"]
		tags = {
				"Name" = "${module.globals.topology}-Region3Leaf1host1"
		}
}

module "Region3Leaf1CloudEOS2" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudLeaf"
  topology_name = module.Region3Leaf1Vpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.Region3Leaf1Vpc.region]
  keypair_name = module.globals.keypair_name[module.Region3Leaf1Vpc.region]
  vpc_info = module.Region3Leaf1Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Region3Leaf1CloudEOS2Intf0",
    "${module.globals.topology}-Region3Leaf1CloudEOS2Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Region3Leaf1CloudEOS2Intf0" = "internal"
    "${module.globals.topology}-Region3Leaf1CloudEOS2Intf1" = "private"
  }
  subnetids  = {
      "${module.globals.topology}-Region3Leaf1CloudEOS2Intf0" = module.Region3Leaf1Subnet.vpc_subnets[2]
      "${module.globals.topology}-Region3Leaf1CloudEOS2Intf1" = module.Region3Leaf1Subnet.vpc_subnets[3]
  }
  private_ips = {"0": ["110.2.2.101"], "1": ["110.2.3.101"]}
  availability_zone = lookup( module.globals.availability_zone[module.Region3Leaf1Vpc.region], "zone2", "" )
  region            = module.Region3Leaf1Vpc.region
  tags = {
         "Name" = "${module.globals.topology}-Region3Leaf1CloudEOS2"
         "Cnps" = "Dev"
  }
  cloud_ha = "leaf3"
  internal_route_table_id = module.Region3Leaf1CloudEOS1.route_table_internal
  primary_internal_subnetids = [module.Region3Leaf1Subnet.vpc_subnets[0]]
  iam_instance_profile = var.aws_iam_instance_profile
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Region3Leaf1host2" {
		region = module.globals.aws_regions["region3"]
		source = "../../../module/arista/aws/host"
		ami = module.globals.host_amis[module.Region3Leaf1Vpc.region]
		instance_type = "c5.xlarge"
		keypair_name = module.globals.keypair_name[module.Region3Leaf1Vpc.region]
		subnet_id = module.Region3Leaf1Subnet.vpc_subnets[3]
		private_ips = ["110.2.3.102"]
		tags = {
				"Name" = "${module.globals.topology}-Region3Leaf1host2"
		}
}

