provider "azurerm" {
  skip_provider_registration = true
  client_id = var.creds["client_id"]
  subscription_id = var.creds["subscription_id"]
  tenant_id = var.creds["tenant_id"]
  client_secret = var.creds["client_secret"]
  features {}
}

locals {
  sanitized_topology = lower(replace(var.topology, "-", ""))
  edge1cloudeos1_private_ips = {
  "0" : [ var.vpc_info["azure_edge1_vpc"]["interface_ips"][0] ],
  "1" : [ var.vpc_info["azure_edge1_vpc"]["interface_ips"][1] ]
  }

  subnet_names    = ["edge1Subnet0", "edge1Subnet1"]
}

module "edge1" {
  source        = "../../../module/cloudeos/azure/rg"
  address_space = var.vpc_info["azure_edge1_vpc"]["vpc_cidr"]
  nsg_name      = "${var.topology}edge1Nsg"
  role          = "CloudEdge"
  rg_name       = "${var.topology}edge1"
  rg_location   = var.azure_regions["region1"]
  vnet_name     = "${var.topology}Edge1vnet"
  topology_name = var.topology
  wan_name      = "${var.topology}-wan"
  tags = {
    Name = "${var.topology}edge1"
  }
  availability_set = true
}

module "edge1Subnet" {
  source          = "../../../module/cloudeos/azure/subnet"
  subnet_prefixes = var.vpc_info["azure_edge1_vpc"]["subnet_cidr"]
  subnet_names    = local.subnet_names
  vnet_name       = module.edge1.vnet_name
  vnet_id         = module.edge1.vnet_id
  rg_name         = module.edge1.rg_name
  topology_name   = module.edge1.topology_name
}

module "azureedge1cloudeos1" {
  source        = "../../../module/cloudeos/azure/router"
  vpc_info      = module.edge1.vpc_info
  topology_name = module.edge1.topology_name
  role          = "CloudEdge"
  tags          = { "Name" : "${var.topology}Edge1cloudeos1" }
  # Storage account names must be between 3 and 24 characters in length and may contain
  # numbers and lowercase letters only. Storage account names must be unique within Azure
  storage_name  = format("%s%s",local.sanitized_topology,"edge1eos1store")
  subnetids = {
    "edge1cloudeos1Intf0" = module.edge1Subnet.vnet_subnets[0]
    "edge1cloudeos1Intf1" = module.edge1Subnet.vnet_subnets[1]
  }
  publicip_name   = var.cloudeos_info["edge1cloudeos1"]["publicip_name"]
  intf_names      = var.cloudeos_info["edge1cloudeos1"]["intf_names"]
  interface_types = var.cloudeos_info["edge1cloudeos1"]["interface_types"]
  private_ips            = local.edge1cloudeos1_private_ips

  availability_set_id     = module.edge1.availability_set_id
  disk_name              = var.cloudeos_info["edge1cloudeos1"]["disk_name"]
  route_name             = var.cloudeos_info["edge1cloudeos1"]["route_name"]
  routetable_name        = var.cloudeos_info["edge1cloudeos1"]["routetable_name"]
  filename               = var.cloudeos_info["edge1cloudeos1"]["filename"]
  cloudeos_image_version = var.cloudeos_info["edge1cloudeos1"]["cloudeos_image_version"]
  cloudeos_image_name    = var.cloudeos_info["edge1cloudeos1"]["cloudeos_image_name"]
  cloudeos_image_offer   = var.cloudeos_info["edge1cloudeos1"]["cloudeos_image_offer"]
  licenses               = lookup(var.cloudeos_info["edge1cloudeos1"], "licenses", {})
  admin_password         = var.password
  admin_username         = var.username
}
