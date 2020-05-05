provider "azurerm" {
  skip_provider_registration = true
  version                    = 1.33
}

provider "arista" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

variable "username" {}
variable "password" {}

module "azureLeaf1" {
  source        = "../../../module/arista/azure/rg"
  rg_name       = "azureLeaf1"
  role          = "CloudLeaf"
  rg_location   = "westus2"
  vnet_name     = "azureLeaf1Vnet"
  address_space = "16.0.0.0/16"
  nsg_name      = "azureLeaf1AllowSSHIKE"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  tags = {
    Name = "azureLeaf1Vpc"
    Cnps = "Dev"
  }
}

module "azureLeaf1Subnet" {
  source          = "../../../module/arista/azure/subnet"
  subnet_prefixes = var.subnet_info["leaf1subnet"]["subnet_prefixes"]
  subnet_names    = var.subnet_info["leaf1subnet"]["subnet_names"]
  vnet_name       = module.azureLeaf1.vnet_name
  vnet_id         = module.azureLeaf1.vnet_id
  rg_name         = module.azureLeaf1.rg_name
  topology_name   = module.azureLeaf1.topology_name
}

module "azureLeaf1veos1" {
  source        = "../../../module/arista/azure/veos"
  vpc_info      = module.azureLeaf1.vpc_info
  topology_name = module.azureLeaf1.topology_name
  role          = "CloudLeaf"
  nsg_id        = module.azureLeaf1.nsg_id

  subnetids = {
    "leaf1veos1Intf0" = module.azureLeaf1Subnet.vnet_subnets[0]
    "leaf1veos1Intf1" = module.azureLeaf1Subnet.vnet_subnets[1]
  }
  intf_names             = var.cloudeos_info["leaf1veos1"]["intf_names"]
  interface_types        = var.cloudeos_info["leaf1veos1"]["interface_types"]
  tags                   = var.cloudeos_info["leaf1veos1"]["tags"]
  disk_name              = var.cloudeos_info["leaf1veos1"]["disk_name"]
  storage_name           = var.cloudeos_info["leaf1veos1"]["storage_name"]
  private_ips            = var.cloudeos_info["leaf1veos1"]["private_ips"]
  route_name             = var.cloudeos_info["leaf1veos1"]["route_name"]
  routetable_name        = var.cloudeos_info["leaf1veos1"]["routetable_name"]
  filename               = var.cloudeos_info["leaf1veos1"]["filename"]
  cloudeos_image_version = var.cloudeos_info["leaf1veos1"]["cloudeos_image_version"]
  cloudeos_image_sku     = var.cloudeos_info["leaf1veos1"]["cloudeos_image_sku"]
  cloud_ha               = "leaf1"
  admin_password         = var.password
  admin_username         = var.username
}

module "azureLeaf1veos2" {
  source        = "../../../module/arista/azure/veos"
  vpc_info      = module.azureLeaf1.vpc_info
  topology_name = module.azureLeaf1.topology_name
  role          = "CloudLeaf"
  nsg_id        = module.azureLeaf1.nsg_id

  subnetids = {
    "leaf1veos2Intf0" = module.azureLeaf1Subnet.vnet_subnets[2]
    "leaf1veos2Intf1" = module.azureLeaf1Subnet.vnet_subnets[3]
  }
  intf_names             = var.cloudeos_info["leaf1veos2"]["intf_names"]
  interface_types        = var.cloudeos_info["leaf1veos2"]["interface_types"]
  tags                   = var.cloudeos_info["leaf1veos2"]["tags"]
  disk_name              = var.cloudeos_info["leaf1veos2"]["disk_name"]
  storage_name           = var.cloudeos_info["leaf1veos2"]["storage_name"]
  private_ips            = var.cloudeos_info["leaf1veos2"]["private_ips"]
  route_name             = var.cloudeos_info["leaf1veos2"]["route_name"]
  routetable_name        = var.cloudeos_info["leaf1veos2"]["routetable_name"]
  filename               = var.cloudeos_info["leaf1veos2"]["filename"]
  cloudeos_image_version = var.cloudeos_info["leaf1veos2"]["cloudeos_image_version"]
  cloudeos_image_sku     = var.cloudeos_info["leaf1veos2"]["cloudeos_image_sku"]
  cloud_ha               = "leaf1"
  admin_password         = var.password
  admin_username         = var.username
}

module "azureLeaf1host1" {
  source      = "../../../module/arista/azure/host"
  rg_name     = "azureLeaf1"
  rg_location = "westus2"
  intf_name   = "host1Intf0"
  subnet_id   = module.azureLeaf1Subnet.vnet_subnets[1]
  private_ip  = "16.0.1.10"
  disk_name   = "leaf1host1disk"
  tags = {
    "Name" : "host1azureLeaf1"
  }
  username = var.username
  password = var.password
}

module "azureLeaf1host2" {
  source      = "../../../module/arista/azure/host"
  rg_name     = "azureLeaf1"
  rg_location = "westus2"
  intf_name   = "azurehost2Intf1"
  subnet_id   = module.azureLeaf1Subnet.vnet_subnets[3]
  private_ip  = "16.0.3.10"
  disk_name   = "azureleaf1host2"
  tags = {
    "Name" : "azureleaf1host2"
  }
  username = var.username
  password = var.password
}

module "azureLeaf2" {
  source        = "../../../module/arista/azure/rg"
  rg_name       = "azureLeaf2"
  role          = "CloudLeaf"
  rg_location   = "westus2"
  vnet_name     = "azureLeaf2Vnet"
  address_space = "17.0.0.0/16"
  nsg_name      = "azureLeaf2AllowSSHIKE"
  topology_name = var.topology
  clos_name     = "${var.topology}-clos"
  tags = {
    Name = "azureLeaf2Vpc"
    Cnps = "Dev"
  }
}

module "azureLeaf2Subnet" {
  source          = "../../../module/arista/azure/subnet"
  subnet_prefixes = var.subnet_info["leaf2subnet"]["subnet_prefixes"]
  subnet_names    = var.subnet_info["leaf2subnet"]["subnet_names"]
  vnet_name       = module.azureLeaf2.vnet_name
  vnet_id         = module.azureLeaf2.vnet_id
  rg_name         = module.azureLeaf2.rg_name
  topology_name   = module.azureLeaf2.topology_name
}

module "azureLeaf2veos1" {
  source        = "../../../module/arista/azure/veos"
  vpc_info      = module.azureLeaf2.vpc_info
  topology_name = module.azureLeaf2.topology_name
  role          = "CloudLeaf"
  nsg_id        = module.azureLeaf2.nsg_id
  subnetids = {
    "leaf2veos1Intf0" = module.azureLeaf2Subnet.vnet_subnets[0]
    "leaf2veos1Intf1" = module.azureLeaf2Subnet.vnet_subnets[1]
  }
  intf_names             = var.cloudeos_info["leaf2veos1"]["intf_names"]
  interface_types        = var.cloudeos_info["leaf2veos1"]["interface_types"]
  availability_zone      = var.cloudeos_info["leaf2veos1"]["availability_zone"]
  tags                   = var.cloudeos_info["leaf2veos1"]["tags"]
  disk_name              = var.cloudeos_info["leaf2veos1"]["disk_name"]
  storage_name           = var.cloudeos_info["leaf2veos1"]["storage_name"]
  private_ips            = var.cloudeos_info["leaf2veos1"]["private_ips"]
  route_name             = var.cloudeos_info["leaf2veos1"]["route_name"]
  routetable_name        = var.cloudeos_info["leaf2veos1"]["routetable_name"]
  filename               = var.cloudeos_info["leaf2veos1"]["filename"]
  cloudeos_image_version = var.cloudeos_info["leaf2veos1"]["cloudeos_image_version"]
  cloudeos_image_sku     = var.cloudeos_info["leaf2veos1"]["cloudeos_image_sku"]
  admin_password         = var.password
  admin_username         = var.username
}

module "azureLeaf2host1" {
  source      = "../../../module/arista/azure/host"
  rg_name     = "azureLeaf2"
  rg_location = "westus2"
  intf_name   = "host2Intf0"
  subnet_id   = module.azureLeaf2Subnet.vnet_subnets[1]
  private_ip  = "17.0.1.10"
  disk_name   = "leaf2host1disk"
  tags = {
    "Name" : "host1azureLeaf2"
  }
  username = var.username
  password = var.password
}
