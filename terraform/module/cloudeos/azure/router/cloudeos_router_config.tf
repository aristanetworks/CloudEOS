locals {
  private_ip = [for i in values(var.private_ips) : i[0]]
}

resource "cloudeos_router_config" "router" {
  count             = length(values(var.subnetids)) != 0 && var.topology_name != "" ? 1 : 0
  cloud_provider    = "azure"
  topology_name     = var.topology_name // ListTopology will get us clos_name, wan_name
  role              = var.role
  cnps              = lookup(var.tags, "Cnps", "")
  vpc_id            = var.vpc_info != [] ? var.vpc_info[0] : var.vnet_id //ListVpc will get us the router role and region
  tags              = var.tags                                           //tags should have the router name
  region            = var.vpc_info != [] ? var.vpc_info[3] : var.rg_location
  is_rr             = var.is_rr
  intf_name         = var.intf_names
  intf_private_ip   = local.private_ip
  intf_type         = values(var.interface_types)
  ami               = ""
  key_name          = ""
  availability_zone = ""
}
