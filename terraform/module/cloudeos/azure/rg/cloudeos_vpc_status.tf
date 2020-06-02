locals {
  publicNSGID  = length(azurerm_network_security_group.publicNSG.*.id) > 0 ? azurerm_network_security_group.publicNSG[0].id : ""
  privateNSGID = length(azurerm_network_security_group.privateNSG.*.id) > 0 ? azurerm_network_security_group.privateNSG[0].id : ""
}

resource "cloudeos_vpc_status" "vpc" {
  count             = var.topology_name != "" ? 1 : 0
  cloud_provider    = "azure"
  rg_name           = var.rg_name
  vpc_id            = azurerm_virtual_network.vnet.id
  vnet_name         = var.vnet_name
  region            = azurerm_virtual_network.vnet.location
  security_group_id = var.role == "CloudEdge" ? local.publicNSGId : local.privateNSGID
  cidr_block        = azurerm_virtual_network.vnet.address_space[0]
  role              = var.role
  topology_name     = var.topology_name
  tags              = var.tags
  clos_name         = var.clos_name
  wan_name          = var.wan_name
  tf_id             = cloudeos_vpc_config.vpc[0].tf_id
  cnps              = lookup(var.tags, "Cnps", "")
  account           = data.azurerm_client_config.current.subscription_id
}