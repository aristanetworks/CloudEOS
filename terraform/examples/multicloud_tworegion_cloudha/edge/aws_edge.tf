provider "cloudeos" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

output EdgePublicIPs {
  value = { "Region2Edge1" : module.Region2CloudEOSEdge1.eip_public, "Region3Edge1" : module.Region3CloudEOSEdge1.eip_public }
}
output edgePrivateIps {
  value = { "Region2Edge1" : module.Region2CloudEOSEdge1.intf_private_ips, "Region3Edge1" : module.Region3CloudEOSEdge1.intf_private_ips }
}

module "Region2EdgeVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos-aws"
  wan_name      = "${var.topology}-wan"
  role          = "CloudEdge"
  igw_name      = "${var.topology}-Region2VpcIgw"
  cidr_block    = [(var.vpc_info["region2_edge_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Region2EdgeVpc"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["edge_vpc"]["default"]
  ssh_security_group_cidrs = var.ingress_allowlist["edge_vpc"]["ssh"]
  control_plane_ingress_cidrs = var.ingress_allowlist["edge_vpc"]["control"]
}

module "Region2EdgeSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["region2_edge_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Region2EdgeVpc.region]["zone1"]
    (var.vpc_info["region2_edge_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Region2EdgeVpc.region]["zone1"]
    (var.vpc_info["region2_edge_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.Region2EdgeVpc.region]["zone2"]
    (var.vpc_info["region2_edge_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.Region2EdgeVpc.region]["zone2"]
  }
  subnet_names = {
    (var.vpc_info["region2_edge_vpc"]["subnet_cidr"][0]) = "${var.topology}-Region2EdgeSubnet0"
    (var.vpc_info["region2_edge_vpc"]["subnet_cidr"][1]) = "${var.topology}-Region2EdgeSubnet1"
    (var.vpc_info["region2_edge_vpc"]["subnet_cidr"][2]) = "${var.topology}-Region2EdgeSubnet2"
    (var.vpc_info["region2_edge_vpc"]["subnet_cidr"][3]) = "${var.topology}-Region2EdgeSubnet3"
  }
  vpc_id        = module.Region2EdgeVpc.vpc_id[0]
  topology_name = module.Region2EdgeVpc.topology_name
  region        = module.Region2EdgeVpc.region
}

module "Region2CloudEOSEdge1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.Region2EdgeVpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Region2EdgeVpc.region]
  keypair_name  = var.keypair_name[module.Region2EdgeVpc.region]
  vpc_info      = module.Region2EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Region2Edge1Intf0", "${var.topology}-Region2Edge1Intf1"]
  interface_types = {
    "${var.topology}-Region2Edge1Intf0" = "public"
    "${var.topology}-Region2Edge1Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Region2Edge1Intf0" = module.Region2EdgeSubnet.vpc_subnets[0]
    "${var.topology}-Region2Edge1Intf1" = module.Region2EdgeSubnet.vpc_subnets[1]
  }
  private_ips       = { "0" : [(var.vpc_info["region2_edge_vpc"]["interface_ips"][0])], "1" : [(var.vpc_info["region2_edge_vpc"]["interface_ips"][1])] }
  availability_zone = var.availability_zone[module.Region2EdgeVpc.region]["zone1"]
  region            = module.Region2EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-Region2CloudEOSEdge1"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["edge"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}


module "Region2CloudEOSEdge2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.Region2EdgeVpc.topology_name
  cloudeos_ami = local.eos_amis[module.Region2EdgeVpc.region]
  keypair_name = var.keypair_name[module.Region2EdgeVpc.region]
  vpc_info      = module.Region2EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Region2Edge2Intf0", "${var.topology}-Region2Edge2Intf1"]
  interface_types = {
    "${var.topology}-Region2Edge2Intf0" = "public"
    "${var.topology}-Region2Edge2Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Region2Edge2Intf0" = module.Region2EdgeSubnet.vpc_subnets[2]
    "${var.topology}-Region2Edge2Intf1" = module.Region2EdgeSubnet.vpc_subnets[3]
  }
  private_ips       = { "0" : [(var.vpc_info["region2_edge_vpc"]["interface_ips"][2])], "1" : [(var.vpc_info["region2_edge_vpc"]["interface_ips"][3])]  }
  availability_zone = var.availability_zone[module.Region2EdgeVpc.region]["zone2"]
  region            = module.Region2EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-Region2CloudEOSEdge2"
  }
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  instance_type           = var.instance_type["edge"]
  public_route_table_id   = module.Region2CloudEOSEdge1.route_table_public
  internal_route_table_id = module.Region2CloudEOSEdge1.route_table_internal
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}


module "Region3EdgeVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos-aws"
  wan_name      = "${var.topology}-wan"
  role          = "CloudEdge"
  igw_name      = "${var.topology}-Region3VpcIgw"
  cidr_block    = [(var.vpc_info["region3_edge_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-Region3EdgeVpc"
  }
  region = var.aws_regions["region3"]
  default_ingress_sg_cidrs = var.ingress_allowlist["edge_vpc"]["default"]
  ssh_security_group_cidrs = var.ingress_allowlist["edge_vpc"]["ssh"]
  control_plane_ingress_cidrs = var.ingress_allowlist["edge_vpc"]["control"]
}

module "Region3EdgeSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["region3_edge_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.Region3EdgeVpc.region]["zone1"]
    (var.vpc_info["region3_edge_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.Region3EdgeVpc.region]["zone1"]
    (var.vpc_info["region3_edge_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.Region3EdgeVpc.region]["zone2"]
    (var.vpc_info["region3_edge_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.Region3EdgeVpc.region]["zone2"]
  }
  subnet_names = {
    (var.vpc_info["region3_edge_vpc"]["subnet_cidr"][0]) = "${var.topology}-Region3EdgeSubnet0"
    (var.vpc_info["region3_edge_vpc"]["subnet_cidr"][1]) = "${var.topology}-Region3EdgeSubnet1"
    (var.vpc_info["region3_edge_vpc"]["subnet_cidr"][2]) = "${var.topology}-Region3EdgeSubnet2"
    (var.vpc_info["region3_edge_vpc"]["subnet_cidr"][3]) = "${var.topology}-Region3EdgeSubnet3"
  }
  vpc_id        = module.Region3EdgeVpc.vpc_id[0]
  topology_name = module.Region3EdgeVpc.topology_name
  region        = module.Region3EdgeVpc.region
}

module "Region3CloudEOSEdge1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.Region3EdgeVpc.topology_name
  cloudeos_ami  = local.eos_amis[module.Region3EdgeVpc.region]
  keypair_name  = var.keypair_name[module.Region3EdgeVpc.region]
  vpc_info      = module.Region3EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Region3Edge1Intf0", "${var.topology}-Region3Edge1Intf1"]
  interface_types = {
    "${var.topology}-Region3Edge1Intf0" = "public"
    "${var.topology}-Region3Edge1Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Region3Edge1Intf0" = module.Region3EdgeSubnet.vpc_subnets[0]
    "${var.topology}-Region3Edge1Intf1" = module.Region3EdgeSubnet.vpc_subnets[1]
  }
  private_ips       = { "0" : [(var.vpc_info["region3_edge_vpc"]["interface_ips"][0])], "1" : [(var.vpc_info["region3_edge_vpc"]["interface_ips"][1])]  }
  availability_zone = var.availability_zone[module.Region3EdgeVpc.region]["zone1"]
  region            = module.Region3EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-Region3CloudEOSEdge1"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["edge"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}


module "Region3CloudEOSEdge2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.Region3EdgeVpc.topology_name
  cloudeos_ami = local.eos_amis[module.Region3EdgeVpc.region]
  keypair_name = var.keypair_name[module.Region3EdgeVpc.region]
  vpc_info      = module.Region3EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Region3Edge2Intf0", "${var.topology}-Region3Edge2Intf1"]
  interface_types = {
    "${var.topology}-Region3Edge2Intf0" = "public"
    "${var.topology}-Region3Edge2Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Region3Edge2Intf0" = module.Region3EdgeSubnet.vpc_subnets[2]
    "${var.topology}-Region3Edge2Intf1" = module.Region3EdgeSubnet.vpc_subnets[3]
  }
  private_ips       = { "0" : [(var.vpc_info["region3_edge_vpc"]["interface_ips"][2])], "1" : [(var.vpc_info["region3_edge_vpc"]["interface_ips"][3])]  }
  availability_zone = var.availability_zone[module.Region3EdgeVpc.region]["zone2"]
  region            = module.Region3EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-Region3CloudEOSEdge2"
  }
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  instance_type           = var.instance_type["edge"]
  public_route_table_id   = module.Region3CloudEOSEdge1.route_table_public
  internal_route_table_id = module.Region3CloudEOSEdge1.route_table_internal
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}
