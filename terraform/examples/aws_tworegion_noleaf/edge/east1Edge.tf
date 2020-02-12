//=================East1 Edge CloudEOS1===============================
module "East1EdgeVpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name  = module.globals.topology
  clos_name      = "${module.globals.topology}-clos"
  wan_name      = "${module.globals.topology}-wan"
  role          = "CloudEdge"
  igw_name      = "${module.globals.topology}-East1VpcIgw"
  cidr_block    = ["200.2.0.0/16"]
  tags = {
    Name = "${module.globals.topology}-East1EdgeVpc"
  }
  region = module.globals.aws_regions["region2"]
}

module "East1EdgeSubnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
    "200.2.0.0/24" = lookup( module.globals.availability_zone[module.East1EdgeVpc.region], "zone1", "" )
    "200.2.1.0/24" = lookup( module.globals.availability_zone[module.East1EdgeVpc.region], "zone1", "" )
    "200.2.2.0/24" = lookup( module.globals.availability_zone[module.East1EdgeVpc.region], "zone2", "" )
    "200.2.3.0/24" = lookup( module.globals.availability_zone[module.East1EdgeVpc.region], "zone2", "" )
  }
  subnet_names = {
    "200.2.0.0/24" = "${module.globals.topology}-East1EdgeSubnet0"
    "200.2.1.0/24" = "${module.globals.topology}-East1EdgeSubnet1"
    "200.2.2.0/24" = "${module.globals.topology}-East1EdgeSubnet2"
    "200.2.3.0/24" = "${module.globals.topology}-East1EdgeSubnet3"
  }
  vpc_id        = module.East1EdgeVpc.vpc_id[0]
  topology_name = module.East1EdgeVpc.topology_name
  region = module.East1EdgeVpc.region
}

module "East1CloudEOSEdge1" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudEdge"
  topology_name = module.East1EdgeVpc.topology_name
  cloudeos_ami = module.globals.eos_amis[module.East1EdgeVpc.region]
  keypair_name = module.globals.keypair_name
  vpc_info      = module.East1EdgeVpc.vpc_info
  intf_names    = ["${module.globals.topology}-East1Edge1Intf0", "${module.globals.topology}-East1Edge1Intf1"]
  interface_types = {
    "${module.globals.topology}-East1Edge1Intf0" = "public"
    "${module.globals.topology}-East1Edge1Intf1" = "internal"
  }
  subnetids = {
    "${module.globals.topology}-East1Edge1Intf0" = module.East1EdgeSubnet.vpc_subnets[0]
    "${module.globals.topology}-East1Edge1Intf1" = module.East1EdgeSubnet.vpc_subnets[1]
  }
  private_ips       = { "0" : ["200.2.0.101"], "1" : ["200.2.1.101"] }
  availability_zone = lookup( module.globals.availability_zone[module.East1EdgeVpc.region], "zone1", "" )
  region            = module.East1EdgeVpc.region
  tags = {
    "Name" = "${module.globals.topology}-East1CloudEOSEdge1"
  }
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

