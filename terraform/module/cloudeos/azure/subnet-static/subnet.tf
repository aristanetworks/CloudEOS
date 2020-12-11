
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_names[count.index]
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
  count                = length(var.subnet_names)
}

