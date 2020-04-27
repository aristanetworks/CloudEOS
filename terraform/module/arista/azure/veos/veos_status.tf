locals {
  instanceId                  = var.availability_zone != [] ? azurerm_virtual_machine.veosVm1.*.id[0] : azurerm_virtual_machine.veosVm.*.id[0]
  primary_network_interfaceId = var.availability_zone != [] ? azurerm_virtual_machine.veosVm1.*.primary_network_interface_id[0] : azurerm_virtual_machine.veosVm.*.primary_network_interface_id[0]
}

resource "arista_veos_status" "veos" {
  count                        = var.topology_name != "" ? 1 : 0
  cloud_provider               = "azure"
  cv_container                 = var.cv_container
  vpc_id                       = var.vpc_info != [] ? var.vpc_info[0] : var.vnet_id
  rg_name                      = var.vpc_info != [] ? var.vpc_info[2] : var.vnet_id
  region                       = var.vpc_info != [] ? var.vpc_info[3] : var.vnet_id
  instance_id                  = local.instanceId
  instance_type                = var.instance_type
  tags                         = var.tags
  primary_network_interface_id = local.primary_network_interfaceId
  cnps                         = lookup(var.tags, "Cnps", "")
  public_ip                    = length(azurerm_public_ip.publicip.*.ip_address) > 0 ? azurerm_public_ip.publicip[0].ip_address : ""
  intf_name                    = var.intf_names
  intf_id                      = azurerm_network_interface.allIntfs.*.id
  intf_private_ip              = azurerm_network_interface.allIntfs.*.private_ip_address
  intf_subnet_id               = values(var.subnetids)
  intf_type                    = values(var.interface_types)
  ha_name                      = var.cloud_ha
  availability_zone            = var.availability_zone != [] ? var.availability_zone[0] : ""
  availability_set_id          = var.availablity_set_id
  tf_id                        = arista_veos_config.veos[0].tf_id
  private_rt_table_ids         = azurerm_route_table.privateRoutetable.*.id
  is_rr                        = var.is_rr
}
