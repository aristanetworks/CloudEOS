
module "globals" {
  source = "../common"
  #topology = "${module.globals.topology}"
}

/*
provider "aws" {
  region = "${module.globals.aws_regions["region1"]}"
  //access_key = "ASIARHBIZHWNO5PC3VNW"
  //secret_key = "T9rJlqUgGdJKwccck2feZlOHhO4Xop1GMdfmLQ1k"
}
*/
provider "arista" {
  cvaas_domain = "${module.globals.cvaas["domain"]}"
  cvaas_username = "${module.globals.cvaas["username"]}"
  cvaas_server = "${module.globals.cvaas["server"]}"
  service_account_web_token = "${module.globals.cvaas["service_token"]}"
}

//=================Region1 Edge CloudEOS1===============================
# module "Region1EdgeVpc" {
#   source        = "../../../module/arista/aws/vpc"
#   topology_name  = "${module.globals.topology}"
#   clos_name      = "${module.globals.topology}-clos"
#   wan_name      = "${module.globals.topology}-wan"
#   role          = "CloudEdge"
#   igw_name      = "${module.globals.topology}-Region1VpcIgw"
#   cidr_block    = ["100.0.0.0/16"]
#   tags = {
#     Name = "${module.globals.topology}-Region1EdgeVpc"
#     Cnps = "Dev"
#   }
#   region = "${module.globals.aws_regions["region1"]}"
# }

# module "Region1EdgeSubnet" {
#   source = "../../../module/arista/aws/subnet"
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
#   source        = "../../../module/arista/aws/cloudEOS"
#   role          = "CloudEdge"
#   topology_name = module.Region1EdgeVpc.topology_name
#   cloudeos_ami = "${module.globals.eos_amis[module.Region1EdgeVpc.region]}"
#   keypair_name = "${module.globals.keypair_name}"
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
#     "Cnps" = "Dev"
#   }
#   primary  = true
#   filename = "../../../userdata/eos_ipsec_config.tpl"
# }

//=================Region2 Edge CloudEOS1===============================
# module "Region2EdgeVpc" {
#   source        = "../../../module/arista/aws/vpc"
#   topology_name  = "${module.globals.topology}"
#   clos_name      = "${module.globals.topology}-clos"
#   wan_name      = "${module.globals.topology}-wan"
#   role          = "CloudEdge"
#   igw_name      = "${module.globals.topology}-Region2VpcIgw"
#   cidr_block    = ["100.2.0.0/16"]
#   tags = {
#     Name = "${module.globals.topology}-Region2EdgeVpc"
#     Cnps = "Dev"
#   }
#   region = "${module.globals.aws_regions["region2"]}"
# }

# module "Region2EdgeSubnet" {
#   source = "../../../module/arista/aws/subnet"
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
#   source        = "../../../module/arista/aws/cloudEOS"
#   role          = "CloudEdge"
#   topology_name = module.Region2EdgeVpc.topology_name
#   cloudeos_ami = "${module.globals.eos_amis[module.Region2EdgeVpc.region]}"
#   keypair_name = "${module.globals.keypair_name}"
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
#     "Cnps" = "Dev"
#   }
#   primary  = true
#   filename = "../../../userdata/eos_ipsec_config.tpl"
# }
 
//=================Edge2=============================== NOTE NEEDS fixing - don't use
# module "uday2eftEdge2Vpc" {
#   source        = "../../../module/arista/aws/vpc"
#   topology_name  = "topo-uday2"
#   clos_name      = "clos-uday2"
#   wan_name      = "wan-uday2"
#   role          = "CloudEdge"
#   igw_name      = "edge2Vpcigw"
#   cidr_block    = ["101.0.0.0/16"]
#   tags = {
#     Name = "uday2eftEdge2Vpc"
#     Cnps = "Dev"
#   }
#   region = "us-west-1"
# }

# module "uday2eftEdge2Subnet" {
#   source = "../../../module/arista/aws/subnet"
#   subnet_zones = {
#     "101.0.0.0/24" = "us-west-1b"
#     "101.0.1.0/24" = "us-west-1b"
#   }
#   subnet_names = {
#     "101.0.0.0/24" = "edge2Subnet0"
#     "101.0.1.0/24" = "edge2Subnet1"
#   }
#   vpc_id        = module.uday2eftEdge2Vpc.vpc_id[0]
#   topology_name = module.uday2eftEdge2Vpc.topology_name
# }

# module "uday2eftEdge2veos1" {
#   source        = "../../../module/arista/aws/cloudEOS"
#   role          = "CloudEdge"
#   topology_name = module.uday2eftEdge2Vpc.topology_name
#   //cloudeos_ami  = "ami-07ec605ab3f7b279d"
#   cloudeos_ami = "ami-008dcfac638957625"
#   keypair_name  = "systest"
#   vpc_info      = module.uday2eftEdge2Vpc.vpc_info
#   intf_names    = ["edge2veos1Intf0", "edge2veos1Intf1"]
#   interface_types = {
#     "edge2veos1Intf0" = "public"
#     "edge2veos1Intf1" = "internal"
#   }
#   subnetids = {
#     "edge2veos1Intf0" = module.uday2eftEdge2Subnet.vpc_subnets[0]
#     "edge2veos1Intf1" = module.uday2eftEdge2Subnet.vpc_subnets[1]
#   }

#   private_ips       = { "0" : ["101.0.0.101"], "1" : ["101.0.1.101"] }
#   availability_zone = "us-west-1b"
#   region            = "us-west-1"
#   tags = {
#     "Name" = "uday2edge2veos1"
#     "Cnps" = "Dev"
#   }
#   primary  = true
#   filename = "../../../userdata/eos_ipsec_config.tpl"
# }

