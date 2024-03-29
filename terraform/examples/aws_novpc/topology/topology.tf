provider "aws" {
  region = var.aws_regions["region1"]
}

provider "cloudeos" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

resource "cloudeos_topology" "topology" {
  topology_name         = var.topology
  bgp_asn               = "65200-65300"             // Range of BGP ASN’s used for topology
  vtep_ip_cidr          = var.vtep_ip_cidr          // CIDR block for VTEP IPs on cloudeos
  terminattr_ip_cidr    = var.terminattr_ip_cidr    // Loopback IP range on cloudeos
  dps_controlplane_cidr = var.dps_controlplane_cidr // CIDR block for Dps Control Plane IPs on cloudeos
}
resource "cloudeos_clos" "clos" {
  name              = "${var.topology}-clos"
  topology_name     = cloudeos_topology.topology.topology_name
  cv_container_name = var.clos_cv_container
}

resource "cloudeos_wan" "wan" {
  name              = "${var.topology}-wan"
  topology_name     = cloudeos_topology.topology.topology_name
  cv_container_name = var.wan_cv_container
}

module "RRVpc" {
  source        = "../../../module/cloudeos/aws/aristavpc"
  topology_name = cloudeos_topology.topology.topology_name
  clos_name     = cloudeos_clos.clos.name
  wan_name      = cloudeos_wan.wan.name
  role          = var.vpc_info["rr_vpc"]["role"]
  tags          = var.vpc_info["rr_vpc"]["tags"]
  region        = var.aws_regions["region1"]
  vpc_cidr      = var.vpc_info["rr_vpc"]["vpc_cidr"]
  sg_id         = var.vpc_info["rr_vpc"]["sg_id"]
  vpc_id        = var.vpc_info["rr_vpc"]["vpc_id"]
  igw_id        = var.vpc_info["rr_vpc"]["igw_id"]
}

module "RRSubnet" {
  source            = "../../../module/cloudeos/aws/aristasubnet"
  vpc_id            = module.RRVpc.vpc_id[0]
  topology_name     = module.RRVpc.topology_name
  region            = var.aws_regions["region1"]
  subnet_names      = var.subnet_info["rr_subnet"]["subnet_names"]
  subnet_id         = var.subnet_info["rr_subnet"]["subnet_id"]
  subnet_cidr       = var.subnet_info["rr_subnet"]["subnet_cidr"]
  availability_zone = var.subnet_info["rr_subnet"]["availability_zone"]
}

module "CloudEOSRR1" {
  source          = "../../../module/cloudeos/aws/router"
  topology_name   = module.RRVpc.topology_name
  cloudeos_ami    = local.eos_amis[module.RRVpc.region]
  keypair_name    = var.keypair_name[module.RRVpc.region]
  vpc_info        = module.RRVpc.vpc_info
  role            = var.router_info["rr1"]["role"]
  intf_names      = var.router_info["rr1"]["intf_names"]
  interface_types = var.router_info["rr1"]["interface_types"]
  private_ips     = var.router_info["rr1"]["private_ips"]
  tags            = var.router_info["rr1"]["tags"]
  subnetids = {
    "${var.topology}-RRIntf0" = module.RRSubnet.vpc_subnets[0]
  }
  availability_zone    = var.availability_zone[module.RRVpc.region]["zone1"]
  region               = module.RRVpc.region
  primary              = true
  is_rr                = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}

module "CloudEOSRR2" {
  source          = "../../../module/cloudeos/aws/router"
  topology_name   = module.RRVpc.topology_name
  cloudeos_ami    = local.eos_amis[module.RRVpc.region]
  keypair_name    = var.keypair_name[module.RRVpc.region]
  vpc_info        = module.RRVpc.vpc_info
  is_rr           = true
  role            = var.router_info["rr2"]["role"]
  intf_names      = var.router_info["rr2"]["intf_names"]
  interface_types = var.router_info["rr2"]["interface_types"]
  private_ips     = var.router_info["rr2"]["private_ips"]
  tags            = var.router_info["rr2"]["tags"]
  subnetids = {
    "${var.topology}-RR2Intf0" = module.RRSubnet.vpc_subnets[1]
  }
  availability_zone    = var.availability_zone[module.RRVpc.region]["zone1"]
  region               = module.RRVpc.region
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  primary              = true
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}