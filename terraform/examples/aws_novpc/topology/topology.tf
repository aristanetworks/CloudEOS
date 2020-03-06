provider "aws" {
  region = var.aws_regions["region1"]
}

provider "arista" {
  cvaas_domain = var.cvaas["domain"]
  cvaas_username = var.cvaas["username"]
  cvaas_server = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

resource "arista_topology" "topology" {
  topology_name           = var.topology
  bgp_asn                 = "65200-65300" // Range of BGP ASN’s used for topology
  vtep_ip_cidr            = var.vtep_ip_cidr           // CIDR block for VTEP IPs on veos
  terminattr_ip_cidr      = var.terminattr_ip_cidr     // Loopback IP range on veos
  dps_controlplane_cidr   = var.dps_controlplane_cidr  // CIDR block for Dps Control Plane IPs on veos
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
  source        = "../../../module/arista/aws/aristavpc"
  topology_name = arista_topology.topology.topology_name
  clos_name     = arista_clos.clos.name
  wan_name      = arista_wan.wan.name
  role          = var.vpc_info["rr_vpc"]["role"]
  tags = var.vpc_info["rr_vpc"]["tags"]
  region = var.aws_regions["region1"]
  vpc_cidr = var.vpc_info["rr_vpc"]["vpc_cidr"]
  sg_id = var.vpc_info["rr_vpc"]["sg_id"]
  vpc_id = var.vpc_info["rr_vpc"]["vpc_id"]
  igw_id = var.vpc_info["rr_vpc"]["igw_id"]
}

module "RRSubnet" {
  source = "../../../module/arista/aws/aristasubnet"
  vpc_id        = module.RRVpc.vpc_id[0]
  topology_name = module.RRVpc.topology_name
  region = var.aws_regions["region1"]
  subnet_names = var.subnet_info["rr_subnet"]["subnet_names"]
  subnet_id = var.subnet_info["rr_subnet"]["subnet_id"]
  subnet_cidr = var.subnet_info["rr_subnet"]["subnet_cidr"]
  availability_zone = var.subnet_info["rr_subnet"]["availability_zone"]
}

module "CloudEOSRR1" {
  source = "../../../module/arista/aws/cloudEOS"
  topology_name = module.RRVpc.topology_name
  cloudeos_ami = var.eos_amis[module.RRVpc.region]
  keypair_name = var.keypair_name[module.RRVpc.region]
  vpc_info = module.RRVpc.vpc_info
  role = var.router_info["rr1"]["role"]
  intf_names = var.router_info["rr1"]["intf_names"]
  interface_types = var.router_info["rr1"]["interface_types"]
  private_ips = var.router_info["rr1"]["private_ips"]
  tags = var.router_info["rr1"]["tags"]
  subnetids = {
    "${var.topology}-RRIntf0" = module.RRSubnet.vpc_subnets[0]
  }
  availability_zone = var.availability_zone[module.RRVpc.region]["zone1"]
  region = module.RRVpc.region
  primary = true
  is_rr = true
  filename = "../../../userdata/eos_ipsec_config.tpl"
}

module "CloudEOSRR2" {
  source = "../../../module/arista/aws/cloudEOS"
  topology_name = module.RRVpc.topology_name
  cloudeos_ami = var.eos_amis[module.RRVpc.region]
  keypair_name = var.keypair_name[module.RRVpc.region]
  vpc_info = module.RRVpc.vpc_info
  is_rr = true
  role = var.router_info["rr2"]["role"]
  intf_names = var.router_info["rr2"]["intf_names"]
  interface_types = var.router_info["rr2"]["interface_types"]
  private_ips = var.router_info["rr2"]["private_ips"]
  tags = var.router_info["rr2"]["tags"]
  subnetids = {
    "${var.topology}-RR2Intf0" = module.RRSubnet.vpc_subnets[1]
  }
  availability_zone = var.availability_zone[module.RRVpc.region]["zone1"]
  region = module.RRVpc.region
  filename = "../../../userdata/eos_ipsec_config.tpl"
  primary = true
}
