resource "cloudeos_subnet" "subnet" {
  count             = var.topology_name != "" ? length(var.subnet_names) : 0
  cloud_provider    = var.cloud_provider
  vpc_id            = var.vnet_id
  vnet_name         = var.vnet_name
  availability_zone = ""
  subnet_id         = data.azurerm_subnet.subnet[count.index].id
  cidr_block        = data.azurerm_subnet.subnet[count.index].address_prefix
  subnet_name       = var.subnet_names[count.index]
}
