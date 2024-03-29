data "azurerm_client_config" "current" {}

resource "azurerm_network_security_group" "publicNSG" {
  count               = var.role == "CloudEdge" ? 1 : 0
  depends_on          = [azurerm_resource_group.rg]
  name                = var.nsg_name
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "publicSSH" {
  count                      = var.role == "CloudEdge" ? 1 : 0
  name                       = "allow_SSH"
  description                = "Allow SSH access"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.publicNSG[count.index].name
}
resource "azurerm_network_security_rule" "publicIKE500" {
  count                      = var.role == "CloudEdge" ? 1 : 0
  name                       = "allow_IKE500"
  description                = "Allow IKE access"
  priority                   = 110
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Udp"
  source_port_range          = "*"
  destination_port_range     = "500"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.publicNSG[count.index].name
}
resource "azurerm_network_security_rule" "publicIKE4500" {
  count                      = var.role == "CloudEdge" ? 1 : 0
  name                       = "allow_IKE4500"
  description                = "Allow IKE4500 access"
  priority                   = 120
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Udp"
  source_port_range          = "*"
  destination_port_range     = "4500"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.publicNSG[count.index].name
}


resource "azurerm_network_security_group" "privateNSG" {
  count               = var.role != "CloudEdge" ? 1 : 0
  depends_on          = [azurerm_resource_group.rg]
  name                = "${var.nsg_name}-leaf"
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "privateAll" {
  count                      = var.role != "CloudEdge" ? 1 : 0
  name                       = "allow_all"
  priority                   = 130
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.privateNSG[count.index].name
}
resource "azurerm_resource_group" "rg" {
  name       = var.rg_name
  location   = var.rg_location
  depends_on = [cloudeos_vpc_config.vpc[0]]
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
}

//The check var.cvp is to be able to create peering connections if the user provides the peering information
//and CloudDeploy isn't being used.
resource "azurerm_virtual_network_peering" "peer" {
  count                        = var.role == "CloudLeaf" ? var.topology_name != "" ? 1 : var.peervpccidr != "" ? 1 : 0 : 0
  name                         = var.topology_name != "" ? "${azurerm_resource_group.rg.name}${cloudeos_vpc_config.vpc[0].peer_rg_name}" : "${azurerm_resource_group.rg.name}${var.peerrgname}"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = cloudeos_vpc_config.vpc[0].peer_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "peer1" {
  count                        = var.role == "CloudLeaf" ? var.topology_name != "" ? 1 : var.peerrgname != "" && var.peervnetname != "" ? 1 : 0 : 0
  name                         = var.topology_name != "" ? "${cloudeos_vpc_config.vpc[0].peer_rg_name}${azurerm_resource_group.rg.name}" : "${var.peerrgname}${azurerm_resource_group.rg.name}"
  resource_group_name          = var.topology_name != "" ? cloudeos_vpc_config.vpc[0].peer_rg_name : var.peerrgname
  virtual_network_name         = var.topology_name != "" ? cloudeos_vpc_config.vpc[0].peer_vnet_name : var.peervnetname
  remote_virtual_network_id    = azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_availability_set" "availSet" {
  count                       = var.availability_set ? 1 : 0
  name                        = "${var.rg_name}AvailSet"
  location                    = var.rg_location
  resource_group_name         = azurerm_resource_group.rg.name
  managed                     = true
  platform_fault_domain_count = 2
}