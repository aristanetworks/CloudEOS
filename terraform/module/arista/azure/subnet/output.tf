locals {
  empty_subnet_id    = [for name in var.subnet_names : ""]
  computed_subnet_id = length(arista_subnet.subnet.*.computed_subnet_id) > 0 ? arista_subnet.subnet.*.computed_subnet_id : local.empty_subnet_id
}
output "vnet_subnets" {
  description = "The ids of subnets created inside the newl vNet"
  value       = local.computed_subnet_id
}