provider "azurerm" {
  skip_provider_registration = true
  client_id = var.creds["client_id"]
  subscription_id = var.creds["subscription_id"]
  tenant_id = var.creds["tenant_id"]
  client_secret = var.creds["client_secret"]
  features {}
}

provider "cloudeos" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

locals {
  sanitized_topology = lower(replace(var.topology, "-", ""))
  leaf1cloudeos1_private_ips = {
  "0" : [ var.vpc_info["leaf1_vpc"]["interface_ips"][0] ],
  "1" : [ var.vpc_info["leaf1_vpc"]["interface_ips"][1] ]
  }
  leaf1cloudeos2_private_ips = {
  "0" : [ var.vpc_info["leaf1_vpc"]["interface_ips"][2] ],
  "1" : [ var.vpc_info["leaf1_vpc"]["interface_ips"][3] ]
  }
  leaf2cloudeos1_private_ips = {
  "0" : [ var.vpc_info["leaf2_vpc"]["interface_ips"][0] ],
  "1" : [ var.vpc_info["leaf2_vpc"]["interface_ips"][1] ]
  }

  leaf2cloudeos2_private_ips = {
  "0" : [ var.vpc_info["leaf2_vpc"]["interface_ips"][2] ],
  "1" : [ var.vpc_info["leaf2_vpc"]["interface_ips"][3] ]
  }
}

module "azureLeaf1" {
  source        = "../../../module/cloudeos/azure/rg"
  rg_name       = "${var.topology}Leaf1"
  role          = "CloudLeaf"
  rg_location   = "westus2"
  vnet_name     = "${var.topology}Leaf1Vnet"
  address_space = var.vpc_info["leaf1_vpc"]["vpc_cidr"]
  nsg_name      = "${var.topology}Leaf1Nsg"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  tags = {
    Name = "azureLeaf1Vpc"
    Cnps = "dev"
  }
}

module "azureLeaf1Subnet" {
  source          = "../../../module/cloudeos/azure/subnet"
  subnet_prefixes = var.vpc_info["leaf1_vpc"]["subnet_cidr"]
  subnet_names    = var.subnet_info["leaf1subnet"]["subnet_names"]
  vnet_name       = module.azureLeaf1.vnet_name
  vnet_id         = module.azureLeaf1.vnet_id
  rg_name         = module.azureLeaf1.rg_name
  topology_name   = module.azureLeaf1.topology_name
}

module "azureLeaf1cloudeos1" {
  source        = "../../../module/cloudeos/azure/router"
  vpc_info      = module.azureLeaf1.vpc_info
  topology_name = module.azureLeaf1.topology_name
  role          = "CloudLeaf"
  # Storage account names must be between 3 and 24 characters in length and may contain
  # numbers and lowercase letters only. Storage account names must be unique within Azure
  storage_name  = format("%s%s",local.sanitized_topology,"leaf1eos1store")

  subnetids = {
    "leaf1cloudeos1Intf0" = module.azureLeaf1Subnet.vnet_subnets[0]
    "leaf1cloudeos1Intf1" = module.azureLeaf1Subnet.vnet_subnets[1]
  }
  intf_names             = var.cloudeos_info["leaf1cloudeos1"]["intf_names"]
  interface_types        = var.cloudeos_info["leaf1cloudeos1"]["interface_types"]
  tags                   = { "Name" : "${var.topology}leaf1cloudeos1", "Cnps" : "dev" }
  disk_name              = var.cloudeos_info["leaf1cloudeos1"]["disk_name"]
  private_ips            = local.leaf1cloudeos1_private_ips
  availability_zone      = var.cloudeos_info["leaf1cloudeos1"]["availability_zone"]
  route_name             = var.cloudeos_info["leaf1cloudeos1"]["route_name"]
  routetable_name        = var.cloudeos_info["leaf1cloudeos1"]["routetable_name"]
  filename               = var.cloudeos_info["leaf1cloudeos1"]["filename"]
  cloudeos_image_version = var.cloudeos_info["leaf1cloudeos1"]["cloudeos_image_version"]
  cloudeos_image_name    = var.cloudeos_info["leaf1cloudeos1"]["cloudeos_image_name"]
  cloudeos_image_offer   = var.cloudeos_info["leaf1cloudeos1"]["cloudeos_image_offer"]
  licenses               = lookup(var.cloudeos_info["leaf1cloudeos1"], "licenses", {})
  admin_password         = var.password
  admin_username         = var.username
  cloud_ha               = "leaf1"
  primary                = true
}

module "azureLeaf1cloudeos2" {
  source        = "../../../module/cloudeos/azure/router"
  vpc_info      = module.azureLeaf1.vpc_info
  topology_name = module.azureLeaf1.topology_name
  role          = "CloudLeaf"
  storage_name  = format("%s%s",local.sanitized_topology,"leaf1eos2store")
  subnetids = {
    "leaf1cloudeos2Intf0" = module.azureLeaf1Subnet.vnet_subnets[2]
    "leaf1cloudeos2Intf1" = module.azureLeaf1Subnet.vnet_subnets[3]
  }
  intf_names             = var.cloudeos_info["leaf1cloudeos2"]["intf_names"]
  interface_types        = var.cloudeos_info["leaf1cloudeos2"]["interface_types"]
  tags                   = { "Name" : "${var.topology}leaf1cloudeos2", "Cnps" : "dev" }
  disk_name              = var.cloudeos_info["leaf1cloudeos2"]["disk_name"]
  private_ips            = local.leaf1cloudeos2_private_ips
  availability_zone      = var.cloudeos_info["leaf1cloudeos2"]["availability_zone"]
  route_name             = var.cloudeos_info["leaf1cloudeos2"]["route_name"]
  routetable_name        = var.cloudeos_info["leaf1cloudeos2"]["routetable_name"]
  filename               = var.cloudeos_info["leaf1cloudeos2"]["filename"]
  cloudeos_image_version = var.cloudeos_info["leaf1cloudeos2"]["cloudeos_image_version"]
  cloudeos_image_name    = var.cloudeos_info["leaf1cloudeos2"]["cloudeos_image_name"]
  cloudeos_image_offer   = var.cloudeos_info["leaf1cloudeos2"]["cloudeos_image_offer"]
  licenses               = lookup(var.cloudeos_info["leaf1cloudeos2"], "licenses", {})
  admin_password         = var.password
  admin_username         = var.username
  cloud_ha               = "leaf1"
  backend_pool           = module.azureLeaf1cloudeos1.backend_pool_id
  frontend_ilb_ip        = module.azureLeaf1cloudeos1.ilb_ip
}

module "azureLeaf1host1" {
  source      = "../../../module/cloudeos/azure/host"
  rg_name     = module.azureLeaf1.rg_name
  rg_location = "westus2"
  intf_name   = "host1Intf0"
  subnet_id   = module.azureLeaf1Subnet.vnet_subnets[1]
  private_ip  = var.vpc_info["leaf1_vpc"]["interface_ips"][4]
  disk_name   = "leaf1host1disk"
  tags = {
    "Name" : "host1azureLeaf1"
  }
  username = var.username
  password = var.password
}

module "azureLeaf1host2" {
  source      = "../../../module/cloudeos/azure/host"
  rg_name     = module.azureLeaf1.rg_name
  rg_location = "westus2"
  intf_name   = "azurehost2Intf1"
  subnet_id   = module.azureLeaf1Subnet.vnet_subnets[3]
  private_ip  = var.vpc_info["leaf1_vpc"]["interface_ips"][5]
  disk_name   = "azureleaf1host2"
  tags = {
    "Name" : "azureleaf1host2"
  }
  username = var.username
  password = var.password
}

module "azureLeaf2" {
  source        = "../../../module/cloudeos/azure/rg"
  rg_name       = "${var.topology}Leaf2"
  role          = "CloudLeaf"
  rg_location   = "westus2"
  vnet_name     = "${var.topology}Leaf2Vnet"
  address_space = var.vpc_info["leaf2_vpc"]["vpc_cidr"]
  nsg_name      = "${var.topology}Leaf2Nsg"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  tags = {
    Name = "azureLeaf2Vpc"
    Cnps = "dev"
  }
}

module "azureLeaf2Subnet" {
  source          = "../../../module/cloudeos/azure/subnet"
  subnet_prefixes = var.vpc_info["leaf2_vpc"]["subnet_cidr"]
  subnet_names    = var.subnet_info["leaf2subnet"]["subnet_names"]
  vnet_name       = module.azureLeaf2.vnet_name
  vnet_id         = module.azureLeaf2.vnet_id
  rg_name         = module.azureLeaf2.rg_name
  topology_name   = module.azureLeaf2.topology_name
}

module "azureLeaf2cloudeos1" {
  source        = "../../../module/cloudeos/azure/router"
  vpc_info      = module.azureLeaf2.vpc_info
  topology_name = module.azureLeaf2.topology_name
  role          = "CloudLeaf"
  storage_name  = format("%s%s",local.sanitized_topology,"leaf2eos1store")
  tags          = { "Name" : "${var.topology}leaf2cloudeos1", "Cnps" : "dev" }

  subnetids = {
    "leaf2cloudeos1Intf0" = module.azureLeaf2Subnet.vnet_subnets[0]
    "leaf2cloudeos1Intf1" = module.azureLeaf2Subnet.vnet_subnets[1]
  }
  intf_names             = var.cloudeos_info["leaf2cloudeos1"]["intf_names"]
  interface_types        = var.cloudeos_info["leaf2cloudeos1"]["interface_types"]
  availability_zone      = var.cloudeos_info["leaf2cloudeos1"]["availability_zone"]
  disk_name              = var.cloudeos_info["leaf2cloudeos1"]["disk_name"]
  private_ips            = local.leaf2cloudeos1_private_ips
  route_name             = var.cloudeos_info["leaf2cloudeos1"]["route_name"]
  routetable_name        = var.cloudeos_info["leaf2cloudeos1"]["routetable_name"]
  filename               = var.cloudeos_info["leaf2cloudeos1"]["filename"]
  cloudeos_image_version = var.cloudeos_info["leaf2cloudeos1"]["cloudeos_image_version"]
  cloudeos_image_name    = var.cloudeos_info["leaf2cloudeos1"]["cloudeos_image_name"]
  cloudeos_image_offer   = var.cloudeos_info["leaf2cloudeos1"]["cloudeos_image_offer"]
  licenses               = lookup(var.cloudeos_info["leaf2cloudeos1"], "licenses", {})
  admin_password         = var.password
  admin_username         = var.username
  cloud_ha               = "leaf2"
  primary                = true
}

module "azureLeaf2host1" {
  source      = "../../../module/cloudeos/azure/host"
  rg_name     = module.azureLeaf2.rg_name
  rg_location = "westus2"
  intf_name   = "host2Intf0"
  subnet_id   = module.azureLeaf2Subnet.vnet_subnets[1]
  private_ip  = var.vpc_info["leaf2_vpc"]["interface_ips"][4]
  disk_name   = "leaf2host1disk"
  tags = {
    "Name" : "host1azureLeaf2"
  }
  username = var.username
  password = var.password
}

module "azureLeaf2cloudeos2" {
  source        = "../../../module/cloudeos/azure/router"
  vpc_info      = module.azureLeaf2.vpc_info
  topology_name = module.azureLeaf2.topology_name
  role          = "CloudLeaf"
  storage_name  = format("%s%s",local.sanitized_topology,"leaf2eos2store")
  tags          = { "Name" : "${var.topology}leaf2cloudeos2", "Cnps" : "dev" }

  subnetids = {
    "leaf2cloudeos2Intf0" = module.azureLeaf2Subnet.vnet_subnets[2]
    "leaf2cloudeos2Intf1" = module.azureLeaf2Subnet.vnet_subnets[3]
  }
  intf_names             = var.cloudeos_info["leaf2cloudeos2"]["intf_names"]
  interface_types        = var.cloudeos_info["leaf2cloudeos2"]["interface_types"]
  availability_zone      = var.cloudeos_info["leaf2cloudeos2"]["availability_zone"]
  disk_name              = var.cloudeos_info["leaf2cloudeos2"]["disk_name"]
  private_ips            = local.leaf2cloudeos2_private_ips
  route_name             = var.cloudeos_info["leaf2cloudeos2"]["route_name"]
  routetable_name        = var.cloudeos_info["leaf2cloudeos2"]["routetable_name"]
  filename               = var.cloudeos_info["leaf2cloudeos2"]["filename"]
  cloudeos_image_version = var.cloudeos_info["leaf2cloudeos2"]["cloudeos_image_version"]
  cloudeos_image_name    = var.cloudeos_info["leaf2cloudeos2"]["cloudeos_image_name"]
  cloudeos_image_offer   = var.cloudeos_info["leaf2cloudeos2"]["cloudeos_image_offer"]
  licenses               = lookup(var.cloudeos_info["leaf2cloudeos2"], "licenses", {})
  admin_password         = var.password
  admin_username         = var.username
  cloud_ha               = "leaf2"
  backend_pool           = module.azureLeaf2cloudeos1.backend_pool_id
  frontend_ilb_ip        = module.azureLeaf2cloudeos1.ilb_ip
}

module "azureLeaf2host2" {
  source      = "../../../module/cloudeos/azure/host"
  rg_name     = module.azureLeaf2.rg_name
  rg_location = "westus2"
  intf_name   = "leaf2host2Intf0"
  subnet_id   = module.azureLeaf2Subnet.vnet_subnets[3]
  private_ip  = var.vpc_info["leaf2_vpc"]["interface_ips"][5]
  disk_name   = "leaf2host2disk"
  tags = {
    "Name" : "host2azureLeaf2"
  }
  username = var.username
  password = var.password
}
