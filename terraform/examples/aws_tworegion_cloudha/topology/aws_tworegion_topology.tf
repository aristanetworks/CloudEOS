provider "aws" {
  access_key = "AKIARHBIZHWNJRWBJJJ3"
  secret_key = "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"
  region     = var.aws_regions["region1"]
}

provider "arista" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_username            = var.cvaas["username"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

resource "arista_topology" "topology" {
  topology_name         = var.topology
  bgp_asn               = "65000-65100"             // Range of BGP ASN’s used for topology
  vtep_ip_cidr          = var.vtep_ip_cidr          // CIDR block for VTEP IPs on veos
  terminattr_ip_cidr    = var.terminattr_ip_cidr    // Loopback IP range on veos
  dps_controlplane_cidr = var.dps_controlplane_cidr // CIDR block for Dps Control Plane IPs on veos
}
resource "arista_clos" "clos" {
  name              = "${var.topology}-clos"
  topology_name     = arista_topology.topology.topology_name
  cv_container_name = var.clos_cv_container
}

resource "arista_wan" "wan" {
  name              = "${var.topology}-wan"
  topology_name     = arista_topology.topology.topology_name
  cv_container_name = var.wan_cv_container
}

module "RRVpc" {
  source        = "../../../module/arista/aws/vpc"
  topology_name = arista_topology.topology.topology_name
  clos_name     = arista_clos.clos.name
  wan_name      = arista_wan.wan.name
  role          = "CloudEdge"
  igw_name      = "${var.topology}-RRVpcIgw"
  cidr_block    = ["10.0.0.0/16"]
  tags = {
    Name = "${var.topology}-RRVpc"
  }
  region = var.aws_regions["region1"]
}

module "RRSubnet" {
  source = "../../../module/arista/aws/subnet"
  subnet_zones = {
    "10.0.0.0/24" = var.availability_zone[module.RRVpc.region]["zone1"]
  }
  subnet_names = {
    "10.0.0.0/24" = "${var.topology}-RRSubnet0"
  }
  vpc_id        = module.RRVpc.vpc_id[0]
  topology_name = module.RRVpc.topology_name
  region        = var.aws_regions["region1"]
}

module "CloudEOSRR1" {
  source        = "../../../module/arista/aws/cloudEOS"
  role          = "CloudEdge"
  topology_name = module.RRVpc.topology_name
  cloudeos_ami  = var.eos_amis[module.RRVpc.region]
  keypair_name  = var.keypair_name[module.RRVpc.region]
  vpc_info      = module.RRVpc.vpc_info
  intf_names    = ["${var.topology}-RRIntf0"]
  interface_types = {
    "${var.topology}-RRIntf0" = "public"
  }
  subnetids = {
    "${var.topology}-RRIntf0" = module.RRSubnet.vpc_subnets[0]
  }
  private_ips = {
    "0" : ["10.0.0.101"]
  }
  availability_zone = var.availability_zone[module.RRVpc.region]["zone1"]
  region            = module.RRVpc.region
  tags = {
    "Name"           = "${var.topology}-CloudEosRR1"
    "RouteReflector" = "True"
  }
  is_rr    = true
  primary  = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}
