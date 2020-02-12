module "globals" {
  source = "../../../module/arista/common"
  topology = var.topology
  keypair_name = var.keypair_name
  cvaas = var.cvaas
  instance_type = var.instance_type
  aws_regions = var.aws_regions
  eos_amis = var.eos_amis
  availability_zone = var.availability_zone
  host_amis = var.host_amis
}

provider "arista" {
  cvaas_domain = module.globals.cvaas["domain"]
  cvaas_username = module.globals.cvaas["username"]
  cvaas_server = module.globals.cvaas["server"]
  service_account_web_token = module.globals.cvaas["service_token"]
}

//================= Leaf1 CloudEOS1===============================
module "Leaf1Vpc" {
  source         = "../../../module/arista/aws/vpc"
  topology_name  = module.globals.topology
  clos_name      = "${module.globals.topology}-clos"
  role           = "CloudLeaf"
  cidr_block     = ["101.2.0.0/16"]
  tags = {
    Name = "${module.globals.topology}-Leaf1Vpc"
    Cnps = "dev"
  }
  region = module.globals.aws_regions["region2"]
}

module "Leaf1Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
     "101.2.0.0/24" = lookup( module.globals.availability_zone[module.Leaf1Vpc.region], "zone1", "" )
     "101.2.1.0/24" = lookup( module.globals.availability_zone[module.Leaf1Vpc.region], "zone1", "" )
     "101.2.2.0/24" = lookup( module.globals.availability_zone[module.Leaf1Vpc.region], "zone2", "" )
     "101.2.3.0/24" = lookup( module.globals.availability_zone[module.Leaf1Vpc.region], "zone2", "" )
  }
  subnet_names = {
     "101.2.0.0/24" = "${module.globals.topology}-Leaf1Subnet0"
     "101.2.1.0/24" = "${module.globals.topology}-Leaf1Subnet1"
     "101.2.2.0/24" = "${module.globals.topology}-Leaf1Subnet2"
     "101.2.3.0/24" = "${module.globals.topology}-Leaf1Subnet3"
   }
  vpc_id = module.Leaf1Vpc.vpc_id[0]
  topology_name = module.Leaf1Vpc.topology_name
  region = module.Leaf1Vpc.region
}

module "Leaf1CloudEOS1" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudLeaf"
  topology_name = module.Leaf1Vpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.Leaf1Vpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info = module.Leaf1Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Leaf1CloudEOS1Intf0",
    "${module.globals.topology}-Leaf1CloudEOS1Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Leaf1CloudEOS1Intf0" = "internal"
    "${module.globals.topology}-Leaf1CloudEOS1Intf1" = "private"
  }
  subnetids  = {
      "${module.globals.topology}-Leaf1CloudEOS1Intf0" = module.Leaf1Subnet.vpc_subnets[0]
      "${module.globals.topology}-Leaf1CloudEOS1Intf1" = module.Leaf1Subnet.vpc_subnets[1]
  }
  private_ips = {"0": ["101.2.0.101"], "1": ["101.2.1.101"]}
  availability_zone = lookup( module.globals.availability_zone[module.Leaf1Vpc.region], "zone1", "" )
  region            = module.Leaf1Vpc.region
  tags = {
         "Name" = "${module.globals.topology}-Leaf1CloudEOS1"
         "Cnps" = "dev"
  }
  primary = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Leaf1CloudEOS2" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudLeaf"
  topology_name = module.Leaf1Vpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.Leaf1Vpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info = module.Leaf1Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Leaf1CloudEOS2Intf0",
    "${module.globals.topology}-Leaf1CloudEOS2Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Leaf1CloudEOS2Intf0" = "internal"
    "${module.globals.topology}-Leaf1CloudEOS2Intf1" = "private"
  }
  subnetids  = {
      "${module.globals.topology}-Leaf1CloudEOS2Intf0" = module.Leaf1Subnet.vpc_subnets[2]
      "${module.globals.topology}-Leaf1CloudEOS2Intf1" = module.Leaf1Subnet.vpc_subnets[3]
  }
  private_ips = {"0": ["101.2.2.101"], "1": ["101.2.3.101"]}
  availability_zone = lookup( module.globals.availability_zone[module.Leaf1Vpc.region], "zone2", "" )
  region            = module.Leaf1Vpc.region
  tags = {
         "Name" = "${module.globals.topology}-Leaf1CloudEOS2"
         "Cnps" = "dev"
  }
  internal_route_table_id = module.Leaf1CloudEOS1.route_table_internal
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Leaf1host1" {
		region = module.globals.aws_regions["region2"]
		source = "../../../module/arista/aws/host"
		ami = module.globals.host_amis[module.Leaf1Vpc.region]
		instance_type = "c5.xlarge"
		keypair_name = "systest"
		subnet_id = module.Leaf1Subnet.vpc_subnets[1]
		private_ips = ["101.2.1.102"]
		tags = {
				"Name" = "${module.globals.topology}-Leaf1host"
		}
}

// Leaf2
module "Leaf2Vpc" {
  source         = "../../../module/arista/aws/vpc"
  topology_name  = module.globals.topology
  clos_name      = "${module.globals.topology}-clos"
  role           = "CloudLeaf"
  cidr_block     = ["102.2.0.0/16"]
  tags = {
    Name = "${module.globals.topology}-Leaf2Vpc"
    Cnps = "prod"
  }
  region = module.globals.aws_regions["region2"]
}

module "Leaf2Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
     "102.2.0.0/24" = lookup( module.globals.availability_zone[module.Leaf2Vpc.region], "zone1", "" )
     "102.2.1.0/24" = lookup( module.globals.availability_zone[module.Leaf2Vpc.region], "zone1", "" )
     "102.2.2.0/24" = lookup( module.globals.availability_zone[module.Leaf2Vpc.region], "zone2", "" )
     "102.2.3.0/24" = lookup( module.globals.availability_zone[module.Leaf2Vpc.region], "zone2", "" )
  }
  subnet_names = {
     "102.2.0.0/24" = "${module.globals.topology}-Leaf2Subnet0"
     "102.2.1.0/24" = "${module.globals.topology}-Leaf2Subnet1"
     "102.2.2.0/24" = "${module.globals.topology}-Leaf2Subnet2"
     "102.2.3.0/24" = "${module.globals.topology}-Leaf2Subnet3"
   }
  vpc_id = module.Leaf2Vpc.vpc_id[0]
  topology_name = module.Leaf2Vpc.topology_name
  region = module.Leaf2Vpc.region
}

module "Leaf2CloudEOS1" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudLeaf"
  topology_name = module.Leaf2Vpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.Leaf2Vpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info = module.Leaf2Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Leaf2CloudEOS1Intf0",
    "${module.globals.topology}-Leaf2CloudEOS1Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Leaf2CloudEOS1Intf0" = "internal"
    "${module.globals.topology}-Leaf2CloudEOS1Intf1" = "private"
  }
  subnetids  = {
      "${module.globals.topology}-Leaf2CloudEOS1Intf0" = module.Leaf2Subnet.vpc_subnets[0]
      "${module.globals.topology}-Leaf2CloudEOS1Intf1" = module.Leaf2Subnet.vpc_subnets[1]
  }
  private_ips = {"0": ["102.2.0.101"], "1": ["102.2.1.101"]}
  availability_zone = lookup( module.globals.availability_zone[module.Leaf2Vpc.region], "zone1", "" )
  region            = module.Leaf2Vpc.region
  tags = {
         "Name" = "${module.globals.topology}-Leaf2CloudEOS1"
         "Cnps" = "prod"
  }
  primary = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Leaf2CloudEOS2" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudLeaf"
  topology_name = module.Leaf2Vpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.Leaf2Vpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info = module.Leaf2Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Leaf2CloudEOS2Intf0",
    "${module.globals.topology}-Leaf2CloudEOS2Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Leaf2CloudEOS2Intf0" = "internal"
    "${module.globals.topology}-Leaf2CloudEOS2Intf1" = "private"
  }
  subnetids  = {
      "${module.globals.topology}-Leaf2CloudEOS2Intf0" = module.Leaf2Subnet.vpc_subnets[2]
      "${module.globals.topology}-Leaf2CloudEOS2Intf1" = module.Leaf2Subnet.vpc_subnets[3]
  }
  private_ips = {"0": ["102.2.2.101"], "1": ["102.2.3.101"]}
  availability_zone = lookup( module.globals.availability_zone[module.Leaf2Vpc.region], "zone2", "" )
  region            = module.Leaf2Vpc.region
  tags = {
         "Name" = "${module.globals.topology}-Leaf2CloudEOS2"
         "Cnps" = "prod"
  }
  internal_route_table_id = module.Leaf2CloudEOS1.route_table_internal
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

//Leaf3
module "Leaf3Vpc" {
  source         = "../../../module/arista/aws/vpc"
  topology_name  = module.globals.topology
  clos_name      = "${module.globals.topology}-clos"
  role           = "CloudLeaf"
  cidr_block     = ["103.2.0.0/16"]
  tags = {
    Name = "${module.globals.topology}-Leaf3Vpc"
    Cnps = "dev"
  }
  region = module.globals.aws_regions["region2"]
}

module "Leaf3Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
     "103.2.0.0/24" = lookup( module.globals.availability_zone[module.Leaf3Vpc.region], "zone1", "" )
     "103.2.1.0/24" = lookup( module.globals.availability_zone[module.Leaf3Vpc.region], "zone1", "" )
     "103.2.2.0/24" = lookup( module.globals.availability_zone[module.Leaf3Vpc.region], "zone2", "" )
     "103.2.3.0/24" = lookup( module.globals.availability_zone[module.Leaf3Vpc.region], "zone2", "" )
  }
  subnet_names = {
     "103.2.0.0/24" = "${module.globals.topology}-Leaf3Subnet0"
     "103.2.1.0/24" = "${module.globals.topology}-Leaf3Subnet1"
     "103.2.2.0/24" = "${module.globals.topology}-Leaf3Subnet2"
     "103.2.3.0/24" = "${module.globals.topology}-Leaf3Subnet3"
   }
  vpc_id = module.Leaf3Vpc.vpc_id[0]
  topology_name = module.Leaf3Vpc.topology_name
  region = module.Leaf3Vpc.region
}

module "Leaf3CloudEOS1" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudLeaf"
  topology_name = module.Leaf3Vpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.Leaf3Vpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info = module.Leaf3Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Leaf3CloudEOS1Intf0",
    "${module.globals.topology}-Leaf3CloudEOS1Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Leaf3CloudEOS1Intf0" = "internal"
    "${module.globals.topology}-Leaf3CloudEOS1Intf1" = "private"
  }
  subnetids  = {
      "${module.globals.topology}-Leaf3CloudEOS1Intf0" = module.Leaf3Subnet.vpc_subnets[0]
      "${module.globals.topology}-Leaf3CloudEOS1Intf1" = module.Leaf3Subnet.vpc_subnets[1]
  }
  private_ips = {"0": ["103.2.0.101"], "1": ["103.2.1.101"]}
  availability_zone = lookup( module.globals.availability_zone[module.Leaf3Vpc.region], "zone1", "" )
  region            = module.Leaf3Vpc.region
  tags = {
         "Name" = "${module.globals.topology}-Leaf3CloudEOS1"
         "Cnps" = "dev"
  }
  primary = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Leaf3CloudEOS2" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudLeaf"
  topology_name = module.Leaf3Vpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.Leaf3Vpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info = module.Leaf3Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Leaf3CloudEOS2Intf0",
    "${module.globals.topology}-Leaf3CloudEOS2Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Leaf3CloudEOS2Intf0" = "internal"
    "${module.globals.topology}-Leaf3CloudEOS2Intf1" = "private"
  }
  subnetids  = {
      "${module.globals.topology}-Leaf3CloudEOS2Intf0" = module.Leaf3Subnet.vpc_subnets[2]
      "${module.globals.topology}-Leaf3CloudEOS2Intf1" = module.Leaf3Subnet.vpc_subnets[3]
  }
  private_ips = {"0": ["103.2.2.101"], "1": ["103.2.3.101"]}
  availability_zone = lookup( module.globals.availability_zone[module.Leaf3Vpc.region], "zone2", "" )
  region            = module.Leaf3Vpc.region
  tags = {
         "Name" = "${module.globals.topology}-Leaf3CloudEOS2"
         "Cnps" = "dev"
  }
  internal_route_table_id = module.Leaf3CloudEOS1.route_table_internal
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Leaf3host1" {
		region = module.globals.aws_regions["region2"]
		source = "../../../module/arista/aws/host"
		ami = module.globals.host_amis[module.Leaf3Vpc.region]
		instance_type = "c5.xlarge"
		keypair_name = "systest"
		subnet_id = module.Leaf3Subnet.vpc_subnets[1]
		private_ips = ["103.2.1.102"]
		tags = {
				"Name" = "${module.globals.topology}-Leaf3host"
		}
}

//Leaf4
module "Leaf4Vpc" {
  source         = "../../../module/arista/aws/vpc"
  topology_name  = module.globals.topology
  clos_name      = "${module.globals.topology}-clos"
  role           = "CloudLeaf"
  cidr_block     = ["104.2.0.0/16"]
  tags = {
    Name = "${module.globals.topology}-Leaf4Vpc"
    Cnps = "prod"
  }
  region = module.globals.aws_regions["region2"]
}

module "Leaf4Subnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
     "104.2.0.0/24" = lookup( module.globals.availability_zone[module.Leaf4Vpc.region], "zone1", "" )
     "104.2.1.0/24" = lookup( module.globals.availability_zone[module.Leaf4Vpc.region], "zone1", "" )
     "104.2.2.0/24" = lookup( module.globals.availability_zone[module.Leaf4Vpc.region], "zone2", "" )
     "104.2.3.0/24" = lookup( module.globals.availability_zone[module.Leaf4Vpc.region], "zone2", "" )
  }
  subnet_names = {
     "104.2.0.0/24" = "${module.globals.topology}-Leaf4Subnet0"
     "104.2.1.0/24" = "${module.globals.topology}-Leaf4Subnet1"
     "104.2.2.0/24" = "${module.globals.topology}-Leaf4Subnet2"
     "104.2.3.0/24" = "${module.globals.topology}-Leaf4Subnet3"
   }
  vpc_id = module.Leaf4Vpc.vpc_id[0]
  topology_name = module.Leaf4Vpc.topology_name
  region = module.Leaf4Vpc.region
}

module "Leaf4CloudEOS1" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudLeaf"
  topology_name = module.Leaf4Vpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.Leaf4Vpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info = module.Leaf4Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Leaf4CloudEOS1Intf0",
    "${module.globals.topology}-Leaf4CloudEOS1Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Leaf4CloudEOS1Intf0" = "internal"
    "${module.globals.topology}-Leaf4CloudEOS1Intf1" = "private"
  }
  subnetids  = {
      "${module.globals.topology}-Leaf4CloudEOS1Intf0" = module.Leaf4Subnet.vpc_subnets[0]
      "${module.globals.topology}-Leaf4CloudEOS1Intf1" = module.Leaf4Subnet.vpc_subnets[1]
  }
  private_ips = {"0": ["104.2.0.101"], "1": ["104.2.1.101"]}
  availability_zone = lookup( module.globals.availability_zone[module.Leaf4Vpc.region], "zone1", "" )
  region            = module.Leaf4Vpc.region
  tags = {
         "Name" = "${module.globals.topology}-Leaf4CloudEOS1"
         "Cnps" = "prod"
  }
  primary = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "Leaf4CloudEOS2" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudLeaf"
  topology_name = module.Leaf4Vpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.Leaf4Vpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info = module.Leaf4Vpc.vpc_info
  intf_names = [
    "${module.globals.topology}-Leaf4CloudEOS2Intf0",
    "${module.globals.topology}-Leaf4CloudEOS2Intf1"
  ]
  interface_types = {
    "${module.globals.topology}-Leaf4CloudEOS2Intf0" = "internal"
    "${module.globals.topology}-Leaf4CloudEOS2Intf1" = "private"
  }
  subnetids  = {
      "${module.globals.topology}-Leaf4CloudEOS2Intf0" = module.Leaf4Subnet.vpc_subnets[2]
      "${module.globals.topology}-Leaf4CloudEOS2Intf1" = module.Leaf4Subnet.vpc_subnets[3]
  }
  private_ips = {"0": ["104.2.2.101"], "1": ["104.2.3.101"]}
  availability_zone = lookup( module.globals.availability_zone[module.Leaf4Vpc.region], "zone2", "" )
  region            = module.Leaf4Vpc.region
  tags = {
         "Name" = "${module.globals.topology}-Leaf4CloudEOS2"
         "Cnps" = "prod"
  }
  internal_route_table_id = module.Leaf4CloudEOS1.route_table_internal
  filename = "../../../userdata/eos_ipsec_config.tpl"
}
