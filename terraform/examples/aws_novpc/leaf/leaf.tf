provider "aws" {
  region = var.aws_regions["region1"]
}

provider "arista" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

module "LeafVpc" {
  source        = "../../../module/arista/aws/aristavpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  wan_name      = "${var.topology}-wan"
  role          = var.vpc_info["leaf1_vpc"]["role"]
  region        = var.aws_regions["region1"]
  tags          = var.vpc_info["leaf1_vpc"]["tags"]
  vpc_cidr      = var.vpc_info["leaf1_vpc"]["vpc_cidr"]
  vpc_id        = var.vpc_info["leaf1_vpc"]["vpc_id"]
  sg_default_id = var.vpc_info["leaf1_vpc"]["sg_default_id"]
}

module "LeafSubnet" {
  source            = "../../../module/arista/aws/aristasubnet"
  vpc_id            = module.LeafVpc.vpc_id[0]
  topology_name     = module.LeafVpc.topology_name
  region            = module.LeafVpc.region
  subnet_names      = var.subnet_info["leaf1_subnet"]["subnet_names"]
  subnet_id         = var.subnet_info["leaf1_subnet"]["subnet_id"]
  subnet_cidr       = var.subnet_info["leaf1_subnet"]["subnet_cidr"]
  availability_zone = var.subnet_info["leaf1_subnet"]["availability_zone"]
}
module "CloudEOSLeaf1" {
  source          = "../../../module/arista/aws/cloudEOS"
  role            = "CloudLeaf"
  topology_name   = module.LeafVpc.topology_name
  cloudeos_ami    = var.eos_amis[module.LeafVpc.region]
  keypair_name    = var.keypair_name[module.LeafVpc.region]
  vpc_info        = module.LeafVpc.vpc_info
  intf_names      = var.router_info["leaf11"]["intf_names"]
  interface_types = var.router_info["leaf11"]["interface_types"]
  private_ips     = var.router_info["leaf11"]["private_ips"]
  tags            = var.router_info["leaf11"]["tags"]
  subnetids = {
    "${var.topology}-Leaf1Intf0" = module.LeafSubnet.vpc_subnets[0]
    "${var.topology}-Leaf1Intf1" = module.LeafSubnet.vpc_subnets[1]
  }
  availability_zone = lookup(var.availability_zone[module.LeafVpc.region], "zone1", "")
  region            = module.LeafVpc.region
  primary           = true
  filename          = "../../../userdata/eos_ipsec_config.tpl"
}
module "CloudEOSLeaf2" {
  source          = "../../../module/arista/aws/cloudEOS"
  role            = "CloudLeaf"
  topology_name   = module.LeafVpc.topology_name
  cloudeos_ami    = var.eos_amis[module.LeafVpc.region]
  keypair_name    = var.keypair_name[module.LeafVpc.region]
  vpc_info        = module.LeafVpc.vpc_info
  intf_names      = var.router_info["leaf12"]["intf_names"]
  interface_types = var.router_info["leaf12"]["interface_types"]
  private_ips     = var.router_info["leaf12"]["private_ips"]
  tags            = var.router_info["leaf12"]["tags"]
  subnetids = {
    "${var.topology}-Leaf2Intf0" = module.LeafSubnet.vpc_subnets[2]
    "${var.topology}-Leaf2Intf1" = module.LeafSubnet.vpc_subnets[3]
  }
  availability_zone       = lookup(var.availability_zone[module.LeafVpc.region], "zone1", "")
  region                  = module.LeafVpc.region
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  internal_route_table_id = module.CloudEOSLeaf1.route_table_internal
}
