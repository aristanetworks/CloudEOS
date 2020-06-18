output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = azurerm_virtual_network.vnet.name
}

output "rg_name" {
  description = "The Name of the newly created RG"
  value       = azurerm_resource_group.rg.name
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = azurerm_virtual_network.vnet.location
}

output "rg_location" {
  description = "The location of the newly created vNet"
  value       = azurerm_resource_group.rg.location
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = azurerm_virtual_network.vnet.address_space
}

output "topology_name" {
  value = var.topology_name
}

output "availability_set_id" {
  value = length(azurerm_availability_set.availSet.*.id) > 0 ? azurerm_availability_set.availSet[0].id : ""
}

locals {
  vpc_id       = length(arista_vpc.vpc.*.id) > 0 ? arista_vpc.vpc[0].id : ""
  publicNSGId  = length(azurerm_network_security_group.publicNSG.*.id) > 0 ? azurerm_network_security_group.publicNSG[0].id : ""
  privateNSGId = length(azurerm_network_security_group.privateNSG.*.id) > 0 ? azurerm_network_security_group.privateNSG[0].id : ""

}
output "vpc_info" {
  value = [azurerm_virtual_network.vnet.id, azurerm_virtual_network.vnet.name,
    azurerm_resource_group.rg.name, azurerm_resource_group.rg.location,
  local.vpc_id, local.publicNSGId, local.privateNSGId]
}