
module "globals" {
  source = "../common"
  #topology = "${module.globals.topology}"
}

provider "aws" {
  region = "${module.globals.aws_regions["region1"]}"
}

provider "arista" {
  cvaas_domain = "${module.globals.cvaas["domain"]}"
  cvaas_username = "${module.globals.cvaas["username"]}"
  cvaas_server = "${module.globals.cvaas["server"]}"
  service_account_web_token = "${module.globals.cvaas["service_token"]}"
}

data "arista_device_token" "token" {}

resource "arista_topology" "topology" {
  topology_name           = "${module.globals.topology}"
  bgp_asn                 = "65000-65100" // Range of BGP ASN’s used for topology
  vtep_ip_cidr            = "5.0.0.0/16"  // CIDR block for VTEP IPs on veos
  terminattr_ip_cidr      = "6.0.0.0/16"  // Loopback IP range on veos
  dps_controlplane_cidr   = "7.0.0.0/16"  // CIDR block for Dps Control Plane IPs on veos
  device_enrollment_token = data.arista_device_token.token.device_enrollment_token
}

resource "arista_clos" "clos" {
  name              = "${module.globals.topology}-clos"
  topology_name     = arista_topology.topology.topology_name
  cv_container_name = "CloudLeaf"
}

resource "arista_clos" "closRR" {
  name              = "${module.globals.topology}-closRR"
  topology_name     = arista_topology.topology.topology_name
  cv_container_name = "CloudLeaf"
}

resource "arista_wan" "wan" {
  name              = "${module.globals.topology}-wan"
  topology_name     = arista_topology.topology.topology_name
  cv_container_name = "CloudEdge"
}

module "RRVpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name = arista_topology.topology.topology_name
  clos_name     = arista_clos.closRR.name
  wan_name      = arista_wan.wan.name
  role          = "CloudEdge"
  igw_name      = "${module.globals.topology}-RRVpcIgw"
  cidr_block    = ["10.0.0.0/16"]
  tags = {
    Name = "${module.globals.topology}-RRVpc"
    Cnps = "Dev"
  }
  region = "${module.globals.aws_regions["region1"]}"
}

module "RRSubnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
    "10.0.0.0/24" = lookup( "${module.globals.availability_zone[module.RRVpc.region]}", "zone1", "" )
  }
  subnet_names = {
    "10.0.0.0/24" = "${module.globals.topology}-RRSubnet0"
  }
  vpc_id        = module.RRVpc.vpc_id[0]
  topology_name = module.RRVpc.topology_name
  region = "${module.globals.aws_regions["region1"]}"
}

module "CloudEOSRR1" {
  source = "../../../module/arista/aws/cloudEOS"
  role = "CloudEdge"
  topology_name = module.RRVpc.topology_name
  cloudeos_ami = "${module.globals.eos_amis[module.RRVpc.region]}"
  keypair_name = "${module.globals.keypair_name}"
  vpc_info = module.RRVpc.vpc_info
  intf_names = ["${module.globals.topology}-RRIntf0"]
  interface_types = {
    "${module.globals.topology}-RRIntf0" = "public"
  }
  subnetids = {
    "${module.globals.topology}-RRIntf0" = module.RRSubnet.vpc_subnets[0]
  }
  private_ips = {
    "0": ["10.0.0.101"]
  }
  availability_zone = lookup( "${module.globals.availability_zone[module.RRVpc.region]}", "zone1", "" )
  region = module.RRVpc.region
  tags = {
    "Name" = "${module.globals.topology}-CloudEosRR1"
    "RouteReflector" = "True"
  }
  is_rr = true
  primary = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}
