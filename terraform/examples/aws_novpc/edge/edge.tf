provider "aws" {
  region = var.aws_regions["region1"]
}

provider "cloudeos" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

module "EdgeVpc" {
  source        = "../../../module/cloudeos/aws/aristavpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  wan_name      = "${var.topology}-wan"
  role          = var.vpc_info["edge_vpc"]["role"]
  tags          = var.vpc_info["edge_vpc"]["tags"]
  region        = var.aws_regions["region1"]
  vpc_cidr      = var.vpc_info["edge_vpc"]["vpc_cidr"]
  sg_id         = var.vpc_info["edge_vpc"]["sg_id"]
  vpc_id        = var.vpc_info["edge_vpc"]["vpc_id"]
  igw_id        = var.vpc_info["edge_vpc"]["igw_id"]
}

module "EdgeSubnet" {
  source            = "../../../module/cloudeos/aws/aristasubnet"
  vpc_id            = module.EdgeVpc.vpc_id[0]
  topology_name     = module.EdgeVpc.topology_name
  region            = module.EdgeVpc.region
  subnet_names      = var.subnet_info["edge_subnet"]["subnet_names"]
  subnet_id         = var.subnet_info["edge_subnet"]["subnet_id"]
  subnet_cidr       = var.subnet_info["edge_subnet"]["subnet_cidr"]
  availability_zone = var.subnet_info["edge_subnet"]["availability_zone"]
}

module "CloudEOSEdge1" {
  source            = "../../../module/cloudeos/aws/router"
  role              = var.router_info["edge2"]["role"]
  availability_zone = var.availability_zone[module.EdgeVpc.region]["zone1"]
  intf_names        = var.router_info["edge1"]["intf_names"]
  interface_types   = var.router_info["edge1"]["interface_types"]
  private_ips       = var.router_info["edge1"]["private_ips"]
  tags              = var.router_info["edge1"]["tags"]
  subnetids = {
    "${var.topology}-EdgeIntf0" = module.EdgeSubnet.vpc_subnets[0]
    "${var.topology}-EdgeIntf1" = module.EdgeSubnet.vpc_subnets[1]
  }
  primary       = true
  topology_name = module.EdgeVpc.topology_name
  cloudeos_ami  = var.eos_amis[module.EdgeVpc.region]
  keypair_name  = var.keypair_name[module.EdgeVpc.region]
  vpc_info      = module.EdgeVpc.vpc_info
  region        = module.EdgeVpc.region
  filename      = "../../../userdata/eos_ipsec_config.tpl"
}

module "CloudEOSEdge2" {
  source          = "../../../module/cloudeos/aws/router"
  role            = var.router_info["edge2"]["role"]
  intf_names      = var.router_info["edge2"]["intf_names"]
  interface_types = var.router_info["edge2"]["interface_types"]
  private_ips     = var.router_info["edge2"]["private_ips"]
  tags            = var.router_info["edge2"]["tags"]
  subnetids = {
    "${var.topology}-Edge2Intf0" = module.EdgeSubnet.vpc_subnets[2]
    "${var.topology}-Edge2Intf1" = module.EdgeSubnet.vpc_subnets[3]
  }
  availability_zone       = var.availability_zone[module.EdgeVpc.region]["zone2"]
  region                  = module.EdgeVpc.region
  topology_name           = module.EdgeVpc.topology_name
  cloudeos_ami            = var.eos_amis[module.EdgeVpc.region]
  keypair_name            = var.keypair_name[module.EdgeVpc.region]
  vpc_info                = module.EdgeVpc.vpc_info
  public_route_table_id   = module.CloudEOSEdge1.route_table_public
  internal_route_table_id = module.CloudEOSEdge1.route_table_internal
  filename                = "../../../userdata/eos_ipsec_config.tpl"
}
