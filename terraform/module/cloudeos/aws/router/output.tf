// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
//Consumed by aws_instance
/*
output "bootstrap_cfg" {
       value = "${cloudeos_router_config.router[0].bootstrap_cfg}"
}
*/
output "publicIp" {
  value = aws_instance.cloudeosVm.public_ip
}
output "eip_public" {
  value = aws_eip.eip.*.public_ip
}
output "allIntfIds" {
  value = [aws_network_interface.allIntfs.*.id]
}

output "intfname_to_id" {
  value = length(aws_network_interface.allIntfs.*.id) > 0 && length(var.intf_names) > 0 ? zipmap(var.intf_names, aws_network_interface.allIntfs.*.id) : {}
}

output "intf_private_ips" {
  value = length(aws_network_interface.allIntfs.*.id) > 0 && length(aws_network_interface.allIntfs.*.private_ips) > 0 ? zipmap(aws_network_interface.allIntfs.*.id, aws_network_interface.allIntfs.*.private_ips) : {}
}

output "intf_to_subnets" {
  value = length(aws_network_interface.allIntfs.*.id) > 0 && length(aws_network_interface.allIntfs.*.subnet_id) > 0 ? zipmap(aws_network_interface.allIntfs.*.id, aws_network_interface.allIntfs.*.subnet_id) : {}
}

output "route_table_public" {
  value = length(aws_route_table.route_table_public.*.id) > 0 ? aws_route_table.route_table_public[0].id : var.public_route_table_id
}

output "route_table_internal" {
  value = length(aws_route_table.route_table_internal.*.id) > 0 ? aws_route_table.route_table_internal[0].id : var.internal_route_table_id
}

output "route_table_private" {
  value = length(aws_route_table.route_table_private.*.id) > 0 ? aws_route_table.route_table_private[0].id : ""
}

output "rtable_subnet_assoc_private" {
  value = zipmap(aws_route_table_association.route_map_private.*.subnet_id, aws_route_table_association.route_map_private.*.route_table_id)
}

output "rtable_subnet_assoc_public" {
  value = zipmap(aws_route_table_association.route_map_public.*.subnet_id, aws_route_table_association.route_map_public.*.route_table_id)
}

output "router_info" {
  value = [cloudeos_router_status.router[0].public_ip, cloudeos_router_status.router[0].tf_id]
  //Uncomment after TF provider is upgraded.
  //cloudeos_router_status.router[0].router_bgp_asn,
  //length(aws_customer_gateway.routerVpnGw.*.id) > 0 ? aws_customer_gateway.routerVpnGw[0].id : ""]
}
