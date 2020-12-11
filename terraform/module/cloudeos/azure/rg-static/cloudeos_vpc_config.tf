resource "cloudeos_vpc_config" "vpc" {
  count          = var.topology_name != "" ? 1 : 0
  cloud_provider = "azure"
  topology_name  = var.topology_name
  clos_name      = var.clos_name
  wan_name       = var.wan_name
  role           = var.role
  cnps           = lookup(var.tags, "Cnps", "")
  tags           = var.tags
  vnet_name      = var.vnet_name
  region         = data.azurerm_resource_group.rg.location
  topology_id    = var.topology_id
  wan_id         = var.wan_id
  clos_id        = var.clos_id
}
