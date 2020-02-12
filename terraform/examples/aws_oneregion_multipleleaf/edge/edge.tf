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
module "EdgeVpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name  = module.globals.topology
  clos_name      = "${module.globals.topology}-clos"
  wan_name      = "${module.globals.topology}-wan"
  role          = "CloudEdge"
  igw_name      = "${module.globals.topology}-VpcIgw"
  cidr_block    = ["100.2.0.0/16"]
  tags = {
    Name = "${module.globals.topology}-EdgeVpc"
  }
  region = module.globals.aws_regions["region2"]
}
module "EdgeSubnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
    "100.2.0.0/24" = lookup( module.globals.availability_zone[module.EdgeVpc.region], "zone1", "" )
    "100.2.1.0/24" = lookup( module.globals.availability_zone[module.EdgeVpc.region], "zone1", "" )
    "100.2.2.0/24" = lookup( module.globals.availability_zone[module.EdgeVpc.region], "zone2", "" )
    "100.2.3.0/24" = lookup( module.globals.availability_zone[module.EdgeVpc.region], "zone2", "" )
  }
  subnet_names = {
    "100.2.0.0/24" = "${module.globals.topology}-EdgeSubnet0"
    "100.2.1.0/24" = "${module.globals.topology}-EdgeSubnet1"
    "100.2.2.0/24" = "${module.globals.topology}-EdgeSubnet2"
    "100.2.3.0/24" = "${module.globals.topology}-EdgeSubnet3"
  }
  vpc_id        = module.EdgeVpc.vpc_id[0]
  topology_name = module.EdgeVpc.topology_name
  region = module.EdgeVpc.region
}

module "CloudEOSEdge1" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudEdge"
  topology_name = module.EdgeVpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.EdgeVpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info      = module.EdgeVpc.vpc_info
  intf_names    = ["${module.globals.topology}-Edge1Intf0", "${module.globals.topology}-Edge1Intf1"]
  interface_types = {
    "${module.globals.topology}-Edge1Intf0" = "public"
    "${module.globals.topology}-Edge1Intf1" = "internal"
  }
  subnetids = {
    "${module.globals.topology}-Edge1Intf0" = module.EdgeSubnet.vpc_subnets[0]
    "${module.globals.topology}-Edge1Intf1" = module.EdgeSubnet.vpc_subnets[1]
  }
  private_ips       = { "0" : ["100.2.0.101"], "1" : ["100.2.1.101"] }
  availability_zone = lookup( module.globals.availability_zone[module.EdgeVpc.region], "zone1", "" )
  region            = module.EdgeVpc.region
  tags = {
    "Name" = "${module.globals.topology}-CloudEOSEdge1"
  }
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "CloudEOSEdge2" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudEdge"
  topology_name = module.EdgeVpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.EdgeVpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info      = module.EdgeVpc.vpc_info
  intf_names    = ["${module.globals.topology}-Edge2Intf0", "${module.globals.topology}-Edge2Intf1"]
  interface_types = {
    "${module.globals.topology}-Edge2Intf0" = "public"
    "${module.globals.topology}-Edge2Intf1" = "internal"
  }
  subnetids = {
    "${module.globals.topology}-Edge2Intf0" = module.EdgeSubnet.vpc_subnets[2]
    "${module.globals.topology}-Edge2Intf1" = module.EdgeSubnet.vpc_subnets[3]
  }
  private_ips       = { "0" : ["100.2.2.101"], "1" : ["100.2.3.101"] }
  availability_zone = lookup( module.globals.availability_zone[module.EdgeVpc.region], "zone2", "" )
  region            = module.EdgeVpc.region
  tags = {
    "Name" = "${module.globals.topology}-CloudEOSEdge2"
  }
  filename = "../../../userdata/eos_ipsec_config.tpl"
  public_route_table_id = module.CloudEOSEdge1.route_table_public
  internal_route_table_id = module.CloudEOSEdge1.route_table_internal
}
