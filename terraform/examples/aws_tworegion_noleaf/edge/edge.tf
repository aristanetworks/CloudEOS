// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
module "globals" {
  source            = "../../../module/cloudeos/common"
  topology          = var.topology
  keypair_name      = var.keypair_name
  cvaas             = var.cvaas
  instance_type     = var.instance_type
  aws_regions       = var.aws_regions
  eos_amis          = local.eos_amis
  availability_zone = var.availability_zone
  host_amis         = var.host_amis
}

provider "cloudeos" {
  cvaas_domain              = module.globals.cvaas["domain"]
  cvaas_server              = module.globals.cvaas["server"]
  service_account_web_token = module.globals.cvaas["service_token"]
}

//=================Region1 Edge CloudEOS1===============================
# module "Region1EdgeVpc" {
#   source        = "../../../module/cloudeos/aws/vpc"
#   topology_name  = "${module.globals.topology}"
#   clos_name      = "${module.globals.topology}-clos"
#   wan_name      = "${module.globals.topology}-wan"
#   role          = "CloudEdge"
#   igw_name      = "${module.globals.topology}-Region1VpcIgw"
#   cidr_block    = ["100.0.0.0/16"]
#   tags = {
#     Name = "${module.globals.topology}-Region1EdgeVpc"
#   }
#   region = "${module.globals.aws_regions["region1"]}"
# }

# module "Region1EdgeSubnet" {
#   source = "../../../module/cloudeos/aws/subnet"
#   subnet_zones = {
#     "100.0.0.0/24" = lookup( "${module.globals.availability_zone[module.Region1EdgeVpc.region]}", "zone1", "" )
#     "100.0.1.0/24" = lookup( "${module.globals.availability_zone[module.Region1EdgeVpc.region]}", "zone1", "" )
#     "100.0.2.0/24" = lookup( "${module.globals.availability_zone[module.Region1EdgeVpc.region]}", "zone2", "" )
#     "100.0.3.0/24" = lookup( "${module.globals.availability_zone[module.Region1EdgeVpc.region]}", "zone2", "" )
#   }
#   subnet_names = {
#     "100.0.0.0/24" = "${module.globals.topology}-Region1EdgeSubnet0"
#     "100.0.1.0/24" = "${module.globals.topology}-Region1EdgeSubnet1"
#     "100.0.2.0/24" = "${module.globals.topology}-Region1EdgeSubnet2"
#     "100.0.3.0/24" = "${module.globals.topology}-Region1EdgeSubnet3"
#   }
#   vpc_id        = module.Region1EdgeVpc.vpc_id[0]
#   topology_name = module.Region1EdgeVpc.topology_name
#   region            = module.Region1EdgeVpc.region
# }

# module "Region1CloudEOSEdge1" {
#   source        = "../../../module/cloudeos/aws/router"
#   role          = "CloudEdge"
#   topology_name = module.Region1EdgeVpc.topology_name
#   cloudeos_ami = module.globals.eos_amis[module.Region1EdgeVpc.region]
#   keypair_name = module.globals.keypair_name[module.Region1EdgeVpc.region]
#   vpc_info      = module.Region1EdgeVpc.vpc_info
#   intf_names    = ["${module.globals.topology}-Region1Edge1Intf0", "${module.globals.topology}-Region1Edge1Intf1"]
#   interface_types = {
#     "${module.globals.topology}-Region1Edge1Intf0" = "public"
#     "${module.globals.topology}-Region1Edge1Intf1" = "internal"
#   }
#   subnetids = {
#     "${module.globals.topology}-Region1Edge1Intf0" = module.Region1EdgeSubnet.vpc_subnets[0]
#     "${module.globals.topology}-Region1Edge1Intf1" = module.Region1EdgeSubnet.vpc_subnets[1]
#   }
#   private_ips       = { "0" : ["100.0.0.101"], "1" : ["100.0.1.101"] }
#   availability_zone = lookup( "${module.globals.availability_zone[module.Region1EdgeVpc.region]}", "zone1", "" )
#   region            = module.Region1EdgeVpc.region
#   tags = {
#     "Name" = "${module.globals.topology}-Region1CloudEOSEdge1"
#   }
#   primary  = true
#   filename = "../../../userdata/eos_ipsec_config.tpl"
# }

//=================Region2 Edge CloudEOS1===============================
# module "Region2EdgeVpc" {
#   source        = "../../../module/cloudeos/aws/vpc"
#   topology_name  = "${module.globals.topology}"
#   clos_name      = "${module.globals.topology}-clos"
#   wan_name      = "${module.globals.topology}-wan"
#   role          = "CloudEdge"
#   igw_name      = "${module.globals.topology}-Region2VpcIgw"
#   cidr_block    = ["100.2.0.0/16"]
#   tags = {
#     Name = "${module.globals.topology}-Region2EdgeVpc"
#   }
#   region = "${module.globals.aws_regions["region2"]}"
# }

# module "Region2EdgeSubnet" {
#   source = "../../../module/cloudeos/aws/subnet"
#   subnet_zones = {
#     "100.2.0.0/24" = lookup( "${module.globals.availability_zone[module.Region2EdgeVpc.region]}", "zone1", "" )
#     "100.2.1.0/24" = lookup( "${module.globals.availability_zone[module.Region2EdgeVpc.region]}", "zone1", "" )
#     "100.2.2.0/24" = lookup( "${module.globals.availability_zone[module.Region2EdgeVpc.region]}", "zone2", "" )
#     "100.2.3.0/24" = lookup( "${module.globals.availability_zone[module.Region2EdgeVpc.region]}", "zone2", "" )
#   }
#   subnet_names = {
#     "100.2.0.0/24" = "${module.globals.topology}-Region2EdgeSubnet0"
#     "100.2.1.0/24" = "${module.globals.topology}-Region2EdgeSubnet1"
#     "100.2.2.0/24" = "${module.globals.topology}-Region2EdgeSubnet2"
#     "100.2.3.0/24" = "${module.globals.topology}-Region2EdgeSubnet3"
#   }
#   vpc_id        = module.Region2EdgeVpc.vpc_id[0]
#   topology_name = module.Region2EdgeVpc.topology_name
#   region = module.Region2EdgeVpc.region
# }

# module "Region2CloudEOSEdge1" {
#   source        = "../../../module/cloudeos/aws/router"
#   role          = "CloudEdge"
#   topology_name = module.Region2EdgeVpc.topology_name
#   cloudeos_ami = module.globals.eos_amis[module.Region2EdgeVpc.region]
#   keypair_name = module.globals.keypair_name[module.Region2EdgeVpc.region]
#   vpc_info      = module.Region2EdgeVpc.vpc_info
#   intf_names    = ["${module.globals.topology}-Region2Edge1Intf0", "${module.globals.topology}-Region2Edge1Intf1"]
#   interface_types = {
#     "${module.globals.topology}-Region2Edge1Intf0" = "public"
#     "${module.globals.topology}-Region2Edge1Intf1" = "internal"
#   }
#   subnetids = {
#     "${module.globals.topology}-Region2Edge1Intf0" = module.Region2EdgeSubnet.vpc_subnets[0]
#     "${module.globals.topology}-Region2Edge1Intf1" = module.Region2EdgeSubnet.vpc_subnets[1]
#   }
#   private_ips       = { "0" : ["100.2.0.101"], "1" : ["100.2.1.101"] }
#   availability_zone = lookup( "${module.globals.availability_zone[module.Region2EdgeVpc.region]}", "zone1", "" )
#   region            = module.Region2EdgeVpc.region
#   tags = {
#     "Name" = "${module.globals.topology}-Region2CloudEOSEdge1"
#   }
#   primary  = true
#   filename = "../../../userdata/eos_ipsec_config.tpl"
# }