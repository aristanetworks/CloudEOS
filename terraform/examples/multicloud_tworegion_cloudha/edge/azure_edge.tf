provider "azurerm" {
  skip_provider_registration = true
  features {}
}

variable "username" {}
variable "password" {}

locals {
  sanitized_topology = lower(replace(var.topology, "-", ""))
}

module "edge1" {
  source        = "../../../module/cloudeos/azure/rg"
  address_space = "12.0.0.0/16"
  nsg_name      = "${var.topology}edge1Nsg"
  role          = "CloudEdge"
  rg_name       = "${var.topology}edge1"
  rg_location   = var.azure_regions["region1"]
  vnet_name     = "${var.topology}Edge1vnet"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos-azure"
  wan_name      = "${var.topology}-wan"
  tags = {
    Name = "${var.topology}edge1"
  }
  availability_set = true
}

module "edge1Subnet" {
  source          = "../../../module/cloudeos/azure/subnet"
  subnet_prefixes = var.subnet_info["edge1subnet"]["subnet_prefixes"]
  subnet_names    = var.subnet_info["edge1subnet"]["subnet_names"]
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
  tags          = { "Name" : "${var.topology}Edge1cloudeos1", "autostop" : "no", "autoterminate" : "no" }
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

  availability_set_id     = module.edge1.availability_set_id
  disk_name              = var.cloudeos_info["edge1cloudeos1"]["disk_name"]
  private_ips            = var.cloudeos_info["edge1cloudeos1"]["private_ips"]
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

module "azureedge1cloudeos2" {
  source        = "../../../module/cloudeos/azure/router"
  vpc_info      = module.edge1.vpc_info
  topology_name = module.edge1.topology_name
  role          = "CloudEdge"
  tags          = { "Name" : "${var.topology}Edge1cloudeos2", "autostop" : "no", "autoterminate" : "no" }
  storage_name  = format("%s%s",local.sanitized_topology,"edge1eos2store")
  subnetids = {
    "edge1cloudeos2Intf0" = module.edge1Subnet.vnet_subnets[2]
    "edge1cloudeos2Intf1" = module.edge1Subnet.vnet_subnets[3]
  }
  availability_set_id     = module.edge1.availability_set_id
  publicip_name          = var.cloudeos_info["edge1cloudeos2"]["publicip_name"]
  intf_names             = var.cloudeos_info["edge1cloudeos2"]["intf_names"]
  interface_types        = var.cloudeos_info["edge1cloudeos2"]["interface_types"]
  disk_name              = var.cloudeos_info["edge1cloudeos2"]["disk_name"]
  private_ips            = var.cloudeos_info["edge1cloudeos2"]["private_ips"]
  route_name             = var.cloudeos_info["edge1cloudeos2"]["route_name"]
  routetable_name        = var.cloudeos_info["edge1cloudeos2"]["routetable_name"]
  filename               = var.cloudeos_info["edge1cloudeos2"]["filename"]
  cloudeos_image_version = var.cloudeos_info["edge1cloudeos2"]["cloudeos_image_version"]
  cloudeos_image_name    = var.cloudeos_info["edge1cloudeos2"]["cloudeos_image_name"]
  cloudeos_image_offer   = var.cloudeos_info["edge1cloudeos2"]["cloudeos_image_offer"]
  licenses               = lookup(var.cloudeos_info["edge1cloudeos2"], "licenses", {})
  admin_password         = var.password
  admin_username         = var.username
}

/*
module "azureRR1" {
  source = "../../../module/cloudeos/azure/router"
  role   = "CloudEdge"
  tags   = { "Name" : "${var.topology}rr1cloudeos1", "autostop" : "no", "autoterminate" : "no" }
  subnetids = {
    "rr1cloudeos1Intf0" = module.edge1Subnet.vnet_subnets[4]
  }
  vpc_info               = module.edge1.vpc_info
  topology_name          = module.edge1.topology_name
  publicip_name          = var.cloudeos_info["rr1cloudeos1"]["publicip_name"]
  intf_names             = var.cloudeos_info["rr1cloudeos1"]["intf_names"]
  interface_types        = var.cloudeos_info["rr1cloudeos1"]["interface_types"]
  #tags                   = var.cloudeos_info["rr1cloudeos1"]["tags"]
  disk_name              = var.cloudeos_info["rr1cloudeos1"]["disk_name"]
  storage_name           = var.cloudeos_info["rr1cloudeos1"]["storage_name"]
  private_ips            = var.cloudeos_info["rr1cloudeos1"]["private_ips"]
  route_name             = var.cloudeos_info["rr1cloudeos1"]["route_name"]
  routetable_name        = var.cloudeos_info["rr1cloudeos1"]["routetable_name"]
  filename               = var.cloudeos_info["rr1cloudeos1"]["filename"]
  cloudeos_image_version = var.cloudeos_info["rr1cloudeos1"]["cloudeos_image_version"]
  #cloudeos_image_sku     = var.cloudeos_info["rr1"]["cloudeos_image_sku"]
  is_rr                  = true
  admin_password         = var.password
  admin_username         = var.username
  cloudeos_image_name    = var.cloudeos_info["rr1cloudeos1"]["cloudeos_image_name"]
  cloudeos_image_offer   = var.cloudeos_info["rr1cloudeos1"]["cloudeos_image_offer"]
  licenses               = lookup(var.cloudeos_info["rr1cloudeos1"], "licenses", {})
}
*/
