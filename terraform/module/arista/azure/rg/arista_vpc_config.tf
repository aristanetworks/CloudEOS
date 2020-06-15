resource "arista_vpc_config" "vpc" {
  count          = var.topology_name != "" ? 1 : 0
  cloud_provider = "azure"
  topology_name  = var.topology_name
  clos_name      = var.clos_name
  wan_name       = var.wan_name
  role           = var.role
  cnps           = lookup(var.tags, "Cnps", "")
  tags           = var.tags
  vnet_name      = var.vnet_name
  region         = var.rg_location
}