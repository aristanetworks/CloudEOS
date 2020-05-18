provider "azurerm" {
  skip_provider_registration = true
  features {}
}

provider "arista" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

variable "username" {}
variable "password" {}

resource "arista_topology" "topology" {
  topology_name         = var.topology
  bgp_asn               = "100-200"                 // Range of BGP ASN’s used for topology
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

module "edge1" {
  source        = "../../../module/arista/azure/rg"
  address_space = "12.0.0.0/16"
  nsg_name      = "${var.topology}edge1Nsg"
  role          = "CloudEdge"
  rg_name       = "${var.topology}edge1"
  rg_location   = var.azure_regions["region1"]
  vnet_name     = "${var.topology}Edge1vnet"
  topology_name = arista_topology.topology.topology_name
  clos_name     = arista_clos.clos.name
  wan_name      = arista_wan.wan.name
  tags = {
    Name = "${var.topology}edge1"
    Cnps = "Dev"
  }
  availability_set = true
}

module "edge1Subnet" {
  source          = "../../../module/arista/azure/subnet"
  subnet_prefixes = var.subnet_info["edge1subnet"]["subnet_prefixes"]
  subnet_names    = var.subnet_info["edge1subnet"]["subnet_names"]
  vnet_name       = module.edge1.vnet_name
  vnet_id         = module.edge1.vnet_id
  rg_name         = module.edge1.rg_name
  topology_name   = module.edge1.topology_name
}

module "azureedge1veos1" {
  source        = "../../../module/arista/azure/veos"
  vpc_info      = module.edge1.vpc_info
  topology_name = module.edge1.topology_name
  role          = "CloudEdge"
  tags          = { "Name" : "${var.topology}Edge1veos1" }
  storage_name  = lower("${var.topology}edge1veos1store")

  subnetids = {
    "edge1veos1Intf0" = module.edge1Subnet.vnet_subnets[0]
    "edge1veos1Intf1" = module.edge1Subnet.vnet_subnets[1]
  }
  publicip_name   = var.cloudeos_info["edge1veos1"]["publicip_name"]
  intf_names      = var.cloudeos_info["edge1veos1"]["intf_names"]
  interface_types = var.cloudeos_info["edge1veos1"]["interface_types"]

  availablity_set_id     = module.edge1.availability_set_id
  disk_name              = var.cloudeos_info["edge1veos1"]["disk_name"]
  private_ips            = var.cloudeos_info["edge1veos1"]["private_ips"]
  route_name             = var.cloudeos_info["edge1veos1"]["route_name"]
  routetable_name        = var.cloudeos_info["edge1veos1"]["routetable_name"]
  filename               = var.cloudeos_info["edge1veos1"]["filename"]
  cloudeos_image_version = var.cloudeos_info["edge1veos1"]["cloudeos_image_version"]
  cloudeos_image_sku     = var.cloudeos_info["edge1veos1"]["cloudeos_image_sku"]
  admin_password         = var.password
  admin_username         = var.username
}

module "azureedge1veos2" {
  source        = "../../../module/arista/azure/veos"
  vpc_info      = module.edge1.vpc_info
  topology_name = module.edge1.topology_name
  role          = "CloudEdge"
  tags          = { "Name" : "${var.topology}Edge1veos2" }
  storage_name  = lower("${var.topology}edge1veos2store")
  subnetids = {
    "edge1veos2Intf0" = module.edge1Subnet.vnet_subnets[2]
    "edge1veos2Intf1" = module.edge1Subnet.vnet_subnets[3]
  }
  availablity_set_id     = module.edge1.availability_set_id
  publicip_name   = var.cloudeos_info["edge1veos2"]["publicip_name"]
  intf_names      = var.cloudeos_info["edge1veos2"]["intf_names"]
  interface_types = var.cloudeos_info["edge1veos2"]["interface_types"]
  disk_name              = var.cloudeos_info["edge1veos2"]["disk_name"]
  private_ips            = var.cloudeos_info["edge1veos2"]["private_ips"]
  route_name             = var.cloudeos_info["edge1veos2"]["route_name"]
  routetable_name        = var.cloudeos_info["edge1veos2"]["routetable_name"]
  filename               = var.cloudeos_info["edge1veos2"]["filename"]
  cloudeos_image_version = var.cloudeos_info["edge1veos2"]["cloudeos_image_version"]
  cloudeos_image_sku     = var.cloudeos_info["edge1veos2"]["cloudeos_image_sku"]
  admin_password         = var.password
  admin_username         = var.username
}

/*
module "azureRR1" {
  source = "../../../module/arista/azure/veos"
  role   = "CloudEdge"
  subnetids = {
    "RR1Intf0" = module.edge1Subnet.vnet_subnets[2]
  }
  vpc_info               = module.edge1.vpc_info
  topology_name          = module.edge1.topology_name
  publicip_name          = var.cloudeos_info["rr1"]["publicip_name"]
  intf_names             = var.cloudeos_info["rr1"]["intf_names"]
  interface_types        = var.cloudeos_info["rr1"]["interface_types"]
  tags                   = var.cloudeos_info["rr1"]["tags"]
  disk_name              = var.cloudeos_info["rr1"]["disk_name"]
  storage_name           = var.cloudeos_info["rr1"]["storage_name"]
  private_ips            = var.cloudeos_info["rr1"]["private_ips"]
  route_name             = var.cloudeos_info["rr1"]["route_name"]
  routetable_name        = var.cloudeos_info["rr1"]["routetable_name"]
  filename               = var.cloudeos_info["rr1"]["filename"]
  cloudeos_image_version = var.cloudeos_info["rr1"]["cloudeos_image_version"]
  cloudeos_image_sku     = var.cloudeos_info["rr1"]["cloudeos_image_sku"]
  is_rr                  = true
  admin_password         = var.password
  admin_username         = var.username
}
*/