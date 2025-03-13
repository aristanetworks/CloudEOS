// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
provider "cloudeos" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}
module "EdgeVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  wan_name      = "${var.topology}-wan"
  role          = "CloudEdge"
  igw_name      = "${var.topology}-VpcIgw"
  cidr_block    = [(var.vpc_info["edge_vpc"]["vpc_cidr"])]
  tags = {
    Name = "${var.topology}-EdgeVpc"
  }
  region = var.aws_regions["region2"]
  default_ingress_sg_cidrs = var.ingress_allowlist["edge_vpc"]["default"]
  ssh_security_group_cidrs = var.ingress_allowlist["edge_vpc"]["ssh"]
  control_plane_ingress_cidrs = var.ingress_allowlist["edge_vpc"]["control"]
}
module "EdgeSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    (var.vpc_info["edge_vpc"]["subnet_cidr"][0]) = var.availability_zone[module.EdgeVpc.region]["zone1"]
    (var.vpc_info["edge_vpc"]["subnet_cidr"][1]) = var.availability_zone[module.EdgeVpc.region]["zone1"]
    (var.vpc_info["edge_vpc"]["subnet_cidr"][2]) = var.availability_zone[module.EdgeVpc.region]["zone2"]
    (var.vpc_info["edge_vpc"]["subnet_cidr"][3]) = var.availability_zone[module.EdgeVpc.region]["zone2"]
  }
  subnet_names = {
    (var.vpc_info["edge_vpc"]["subnet_cidr"][0]) = "${var.topology}-EdgeSubnet0"
    (var.vpc_info["edge_vpc"]["subnet_cidr"][1]) = "${var.topology}-EdgeSubnet1"
    (var.vpc_info["edge_vpc"]["subnet_cidr"][2]) = "${var.topology}-EdgeSubnet2"
    (var.vpc_info["edge_vpc"]["subnet_cidr"][3]) = "${var.topology}-EdgeSubnet3"
  }
  vpc_id        = module.EdgeVpc.vpc_id[0]
  topology_name = module.EdgeVpc.topology_name
  region        = module.EdgeVpc.region
}
output EdgePublicIPs {
  value = { "Edge1" : module.CloudEOSEdge1.eip_public, "Edge2" : module.CloudEOSEdge2.eip_public }
}
output edgePrivateIps {
  value = { "Edge1" : module.CloudEOSEdge1.intf_private_ips, "Edge2" : module.CloudEOSEdge2.intf_private_ips }
}

module "CloudEOSEdge1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.EdgeVpc.topology_name
  cloudeos_ami  = local.eos_amis[module.EdgeVpc.region]
  keypair_name  = var.keypair_name[module.EdgeVpc.region]
  vpc_info      = module.EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Edge1Intf0", "${var.topology}-Edge1Intf1"]
  interface_types = {
    "${var.topology}-Edge1Intf0" = "public"
    "${var.topology}-Edge1Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Edge1Intf0" = module.EdgeSubnet.vpc_subnets[0]
    "${var.topology}-Edge1Intf1" = module.EdgeSubnet.vpc_subnets[1]
  }
  private_ips       = { "0" : ([var.vpc_info["edge_vpc"]["interface_ips"][0]]), "1" : ([var.vpc_info["edge_vpc"]["interface_ips"][1]]) }
  availability_zone = var.availability_zone[module.EdgeVpc.region]["zone1"]
  region            = module.EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-CloudEOSEdge1"
  }
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["edge"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "CloudEOSEdge2" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.EdgeVpc.topology_name
  cloudeos_ami  = local.eos_amis[module.EdgeVpc.region]
  keypair_name  = var.keypair_name[module.EdgeVpc.region]
  vpc_info      = module.EdgeVpc.vpc_info
  intf_names    = ["${var.topology}-Edge2Intf0", "${var.topology}-Edge2Intf1"]
  interface_types = {
    "${var.topology}-Edge2Intf0" = "public"
    "${var.topology}-Edge2Intf1" = "internal"
  }
  subnetids = {
    "${var.topology}-Edge2Intf0" = module.EdgeSubnet.vpc_subnets[2]
    "${var.topology}-Edge2Intf1" = module.EdgeSubnet.vpc_subnets[3]
  }
  private_ips       = { "0" : ([var.vpc_info["edge_vpc"]["interface_ips"][2]]), "1" : ([var.vpc_info["edge_vpc"]["interface_ips"][3]]) }
  availability_zone = var.availability_zone[module.EdgeVpc.region]["zone2"]
  region            = module.EdgeVpc.region
  tags = {
    "Name" = "${var.topology}-CloudEOSEdge2"
  }
  filename                = "../../../userdata/eos_ipsec_config.tpl"
  public_route_table_id   = module.CloudEOSEdge1.route_table_public
  internal_route_table_id = module.CloudEOSEdge1.route_table_internal
  instance_type           = var.instance_type["edge"]
  licenses                = var.licenses
  cloudeos_image_offer    = var.cloudeos_image_offer
}
