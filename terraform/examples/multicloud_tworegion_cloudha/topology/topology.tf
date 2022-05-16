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
  bgp_asn               = "65000-65100"             // Range of BGP ASN’s used for topology
  vtep_ip_cidr          = var.vtep_ip_cidr          // CIDR block for VTEP IPs on cloudeos
  terminattr_ip_cidr    = var.terminattr_ip_cidr    // Loopback IP range on cloudeos
  dps_controlplane_cidr = var.dps_controlplane_cidr // CIDR block for Dps Control Plane IPs on cloudeos
}
resource "cloudeos_clos" "clos-aws" {
  name              = "${var.topology}-clos-aws"
  topology_name     = cloudeos_topology.topology.topology_name
  cv_container_name = var.clos_cv_container
}

resource "cloudeos_clos" "clos-azure" {
  name              = "${var.topology}-clos-azure"
  topology_name     = cloudeos_topology.topology.topology_name
  cv_container_name = var.clos_cv_container
}

resource "cloudeos_wan" "wan" {
  name              = "${var.topology}-wan"
  topology_name     = cloudeos_topology.topology.topology_name
  cv_container_name = var.wan_cv_container
}

module "RRVpc" {
  source        = "../../../module/cloudeos/aws/vpc"
  topology_name = cloudeos_topology.topology.topology_name
  clos_name     = cloudeos_clos.clos-aws.name
  wan_name      = cloudeos_wan.wan.name
  role          = "CloudEdge"
  igw_name      = "${var.topology}-RRVpcIgw"
  cidr_block    = ["10.4.0.0/16"]
  tags = {
    Name = "${var.topology}-RRVpc"
  }
  region = var.aws_regions["region1"]
}

module "RRSubnet" {
  source = "../../../module/cloudeos/aws/subnet"
  subnet_zones = {
    "10.4.0.0/24" = var.availability_zone[module.RRVpc.region]["zone1"]
  }
  subnet_names = {
    "10.4.0.0/24" = "${var.topology}-RRSubnet0"
  }
  vpc_id        = module.RRVpc.vpc_id[0]
  topology_name = module.RRVpc.topology_name
  region        = var.aws_regions["region1"]
}

module "CloudEOSRR1" {
  source        = "../../../module/cloudeos/aws/router"
  role          = "CloudEdge"
  topology_name = module.RRVpc.topology_name
  cloudeos_ami  = local.eos_amis[module.RRVpc.region]
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
    "0" : ["10.4.0.101"]
  }
  availability_zone = var.availability_zone[module.RRVpc.region]["zone1"]
  region            = module.RRVpc.region
  tags = {
    "Name"           = "${var.topology}-CloudEosRR1"
    "RouteReflector" = "True"
  }
  is_rr                = true
  primary              = true
  filename             = "../../../userdata/eos_ipsec_config.tpl"
  instance_type        = var.instance_type["rr"]
  licenses             = var.licenses
  cloudeos_image_offer = var.cloudeos_image_offer
}
