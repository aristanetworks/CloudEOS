locals {
  rg_name         = var.vpc_info != [] ? var.vpc_info[2] : var.rg_name
  rg_location     = var.vpc_info != [] ? var.vpc_info[3] : var.rg_location
  ilb_intfnames   = var.cloud_ha != "" && var.role == "CloudLeaf" ? [for key, value in var.interface_types : key if value == "private"] : []
  frontend_ilb_ip = var.primary == true && var.cloud_ha != "" ? azurerm_lb.leafha_ilb[0].private_ip_address : var.cloud_ha != "" && var.frontend_ilb_ip != "" ? var.frontend_ilb_ip : ""
}

resource "azurerm_lb" "leafha_ilb" {
  count               = var.primary == true && var.cloud_ha != "" && var.role == "CloudLeaf" && length(local.ilb_intfnames) > 0 ? 1 : 0
  name                = "Leaf_HA_ILB"
  location            = local.rg_location
  resource_group_name = local.rg_name
  sku                 = "Standard"
  frontend_ip_configuration {
    name      = "Leaf_HA_ILB_IP"
    subnet_id = var.subnetids[local.ilb_intfnames[0]]
  }
}

resource "azurerm_lb_rule" "rule" {
  count                          = var.primary == true && var.cloud_ha != "" && var.role == "CloudLeaf" ? 1 : 0
  resource_group_name            = local.rg_name
  loadbalancer_id                = azurerm_lb.leafha_ilb[0].id
  name                           = "ILBRule1"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "Leaf_HA_ILB_IP"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pool[0].id
  probe_id                       = azurerm_lb_probe.probe[0].id
  load_distribution              = "SourceIP"
}

resource "azurerm_lb_probe" "probe" {
  count               = var.primary == true && var.cloud_ha != "" && var.role == "CloudLeaf" ? 1 : 0
  resource_group_name = local.rg_name
  loadbalancer_id     = azurerm_lb.leafha_ilb[0].id
  name                = "ssh-probe"
  port                = 22
  protocol            = "Tcp"
}

resource "azurerm_network_interface_backend_address_pool_association" "intfpoolassociation" {
  count                   = var.cloud_ha != "" && var.role == "CloudLeaf" ? 1 : 0
  network_interface_id    = azurerm_network_interface.allIntfs[1].id
  ip_configuration_name   = local.ilb_intfnames[0]
  backend_address_pool_id = length(azurerm_lb_backend_address_pool.pool.*.id) > 0 ? azurerm_lb_backend_address_pool.pool[0].id : var.backend_pool
}

resource "azurerm_lb_backend_address_pool" "pool" {
  count               = var.primary == true && var.cloud_ha != "" && var.role == "CloudLeaf" ? 1 : 0
  resource_group_name = local.rg_name
  loadbalancer_id     = azurerm_lb.leafha_ilb[0].id
  name                = "CloudEOSPool"
}

resource "azurerm_public_ip" "publicip" {
  count               = length(matchkeys(keys(var.interface_types), values(var.interface_types), ["public"]))
  name                = format("%s%d", var.publicip_name, count.index)
  location            = local.rg_location
  resource_group_name = local.rg_name
  allocation_method   = "Static"
  zones               = var.availability_zone
}

resource "azurerm_network_interface" "allIntfs" {
  count                         = length(var.intf_names)
  name                          = var.intf_names[count.index]
  location                      = local.rg_location
  resource_group_name           = local.rg_name
  enable_accelerated_networking = true
  enable_ip_forwarding          = true

  ip_configuration {
    name                          = var.intf_names[count.index]
    subnet_id                     = lookup(var.subnetids, var.intf_names[count.index], null)
    private_ip_address_allocation = lookup(var.private_ips, tostring(count.index), []) != [] ? "Static" : "Dynamic"
    private_ip_address            = lookup(var.private_ips, tostring(count.index), []) != [] ? lookup(var.private_ips, tostring(count.index), "")[0] : null
    public_ip_address_id          = lookup(var.interface_types, var.intf_names[count.index], "") == "public" && length(azurerm_public_ip.publicip.*.id) > 0 ? azurerm_public_ip.publicip.*.id[index(matchkeys(keys(var.interface_types), values(var.interface_types), ["public"]), var.intf_names[count.index])] : null
  }

}

resource "azurerm_network_interface_security_group_association" "nsg" {
  count                     = length(var.vpc_info) != 0 ? length(var.intf_names) : 0
  network_interface_id      = azurerm_network_interface.allIntfs[count.index].id
  network_security_group_id = var.role == "CloudEdge" ? var.vpc_info[5] : var.vpc_info[6]
}

data "template_file" "user_data_precreated" {
  count    = var.existing_userdata == true ? 1 : 0
  template = file(var.filename)
}

data "template_file" "user_data_specific" {
  count    = var.existing_userdata == false ? 1 : 0
  template = file(var.filename)
  vars = {
    bootstrap_cfg = arista_veos_config.veos[0].bootstrap_cfg
  }
}

resource "azurerm_virtual_machine" "veosVm" {
  count                         = var.availability_zone == [] ? 1 : 0
  name                          = length([for i, z in var.tags : i if i == "Name"]) > 0 ? var.tags["Name"] : ""
  location                      = local.rg_location
  resource_group_name           = local.rg_name
  primary_network_interface_id  = length(azurerm_network_interface.allIntfs.*.id) > 0 ? azurerm_network_interface.allIntfs[0].id : ""
  network_interface_ids         = length(azurerm_network_interface.allIntfs.*.id) > 0 ? azurerm_network_interface.allIntfs.*.id : []
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = true

  //Demo Only
  storage_image_reference {
    //id = "/subscriptions/ba0583bb-4130-4d7b-bfe4-0c7597857323/resourceGroups/geFxDps-demo4-RG/providers/Microsoft.Compute/images/veos-image"
    //id = "/subscriptions/ba0583bb-4130-4d7b-bfe4-0c7597857323/resourceGroups/geFxDpsLeaf-demo5-RG/providers/Microsoft.Compute/images/veos-image"
    id = "/subscriptions/ba0583bb-4130-4d7b-bfe4-0c7597857323/resourceGroups/jakRelAzureMarch30-demo1-RG/providers/Microsoft.Compute/images/veos-image"
  }

/*
  storage_image_reference {
    publisher = "arista-networks"
    offer     = var.cloudeos_image_offer
    sku       = var.cloudeos_image_name
    version   = var.cloudeos_image_version
  }
*/
  storage_os_disk {
    name              = var.disk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  availability_set_id = var.availablity_set_id

  os_profile {
    computer_name  = length([for i, z in var.tags : i if i == "Name"]) > 0 ? var.tags["Name"] : ""
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = var.existing_userdata == false ? data.template_file.user_data_specific[0].rendered : data.template_file.user_data_precreated[0].rendered
  }
/*
  plan {
    name      = var.cloudeos_image_name
    publisher = "arista-networks"
    product   = var.cloudeos_image_offer
  }
*/
  os_profile_linux_config {
    disable_password_authentication = false
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }
  tags = var.tags
}

resource "azurerm_virtual_machine" "veosVm1" {
  count                         = var.availability_zone != [] ? 1 : 0
  name                          = length([for i, z in var.tags : i if i == "Name"]) > 0 ? var.tags["Name"] : ""
  location                      = local.rg_location
  resource_group_name           = local.rg_name
  primary_network_interface_id  = azurerm_network_interface.allIntfs[0].id
  network_interface_ids         = azurerm_network_interface.allIntfs.*.id
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = true

  //Demo Only
  storage_image_reference {
    //id = "/subscriptions/ba0583bb-4130-4d7b-bfe4-0c7597857323/resourceGroups/jakRelmar25-demo-RG/providers/Microsoft.Compute/images/veos-image"
    id = "/subscriptions/ba0583bb-4130-4d7b-bfe4-0c7597857323/resourceGroups/jakRelAzureMarch30-demo1-RG/providers/Microsoft.Compute/images/veos-image"
  }
/*
  storage_image_reference {
    publisher = "arista-networks"
    offer     = var.cloudeos_image_offer
    sku       = var.cloudeos_image_name
    version   = var.cloudeos_image_version
  }
*/
  storage_os_disk {
    name              = var.disk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  zones = var.availability_zone

  os_profile {
    computer_name  = length([for i, z in var.tags : i if i == "Name"]) > 0 ? var.tags["Name"] : ""
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = var.existing_userdata == false ? data.template_file.user_data_specific[0].rendered : data.template_file.user_data_precreated[0].rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }
  tags = var.tags
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_name
  location                 = local.rg_location
  resource_group_name      = local.rg_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_route_table" "privateRoutetable" {
  count                         = length(matchkeys(keys(var.interface_types), values(var.interface_types), ["private"]))
  name                          = "${var.routetable_name}_private"
  location                      = local.rg_location
  resource_group_name           = local.rg_name
  disable_bgp_route_propagation = false

  route {
    address_prefix         = "0.0.0.0/0"
    name                   = var.route_name
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.cloud_ha != "" ? local.frontend_ilb_ip : length(azurerm_network_interface.allIntfs) > 0 ? azurerm_network_interface.allIntfs[index(var.intf_names, matchkeys(keys(var.interface_types), values(var.interface_types), ["private"])[count.index])].private_ip_address : ""
  }

  tags = {
    environment = "internal"
  }
}

resource "azurerm_subnet_route_table_association" "privateRtSubnetMap" {
  count          = length(matchkeys(keys(var.interface_types), values(var.interface_types), ["private"]))
  subnet_id      = lookup(var.subnetids, matchkeys(keys(var.interface_types), values(var.interface_types), ["private"])[count.index], null)
  route_table_id = azurerm_route_table.privateRoutetable[count.index].id
}

/*
resource "azurerm_route_table" "internalRoutetable" {
  count                         = length(matchkeys(keys(var.interface_types), values(var.interface_types), ["internal"]))
  name                          = "${var.routetable_name}_internal"
  location                      = local.rg_location
  resource_group_name           = local.rg_name
  disable_bgp_route_propagation = false
}
*/

/*
resource "azurerm_subnet_route_table_association" "internalRtSubnetMap" {
  count          = length(matchkeys(keys(var.interface_types), values(var.interface_types), ["internal"]))
  subnet_id      = lookup(var.subnetids, matchkeys(keys(var.interface_types), values(var.interface_types), ["internal"])[count.index], null)
  route_table_id = azurerm_route_table.privateRoutetable[count.index].id
}
*/
