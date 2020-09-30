locals {
  vpn_connection_ids      = aws_vpn_connection.vpnConn.*.id                   //[List of all VPN connections]
  empty_connection_list   = [for i in range(local.total_vpn_connections) : i] //Creating a list used for the setproduct below.
  total_vpn_connections   = length(var.router_info) * ceil(var.bandwidth_gbps / var.bandwith_per_tunnel_gbps)
  router_ip_list          = [for router in var.router_info : router[0]] //router_info = [public_ip, router_tf_id, router_asn, cgw_id]
  router_id_list          = [for router in var.router_info : router[1]]
  router_bgp_list         = [for router in var.router_info : router[2]]
  cgw_ids                 = [for router in var.router_info : router[3]]
  cgw_vpn_conn_list       = setproduct(local.empty_connection_list, local.cgw_ids)
  router_id_vpn_conn_list = setproduct(local.empty_connection_list, local.router_id_list)
}

resource "aws_ec2_transit_gateway" "tgw" {
  count = var.create_tgw ? 1 : 0
}

resource "aws_vpn_connection" "vpnConn" {
  count               = local.total_vpn_connections
  customer_gateway_id = local.cgw_vpn_conn_list[count.index][1]
  transit_gateway_id  = var.tgw_id
  type                = "ipsec.1"
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_association" {
  count                          = local.total_vpn_connections
  transit_gateway_attachment_id  = aws_vpn_connection.vpnConn[count.index].transit_gateway_attachment_id
  transit_gateway_route_table_id = var.cnps_route_table_info
}

resource "cloudeos_aws_vpn" "vpn" {
  count                     = local.total_vpn_connections
  cnps                      = var.cnps
  cgw_id                    = local.cgw_vpn_conn_list[count.index][1]
  router_id                 = local.router_id_vpn_conn_list[count.index][1]
  tgw_id                    = var.tgw_id
  vpc_id                    = var.vpc_id
  vpn_tgw_attachment_id     = aws_vpn_connection.vpnConn[count.index].transit_gateway_attachment_id
  vpn_connection_id         = aws_vpn_connection.vpnConn[count.index].id
  tunnel1_aws_endpoint_ip   = aws_vpn_connection.vpnConn[count.index].tunnel1_address
  tunnel1_bgp_asn           = aws_vpn_connection.vpnConn[count.index].tunnel1_bgp_asn
  tunnel1_router_overlay_ip = aws_vpn_connection.vpnConn[count.index].tunnel1_cgw_inside_address
  tunnel1_aws_overlay_ip     = aws_vpn_connection.vpnConn[count.index].tunnel1_vgw_inside_address
  tunnel1_bgp_holdtime      = aws_vpn_connection.vpnConn[count.index].tunnel1_bgp_holdtime
  tunnel1_preshared_key     = aws_vpn_connection.vpnConn[count.index].tunnel1_preshared_key
  tunnel2_aws_endpoint_ip   = aws_vpn_connection.vpnConn[count.index].tunnel2_address
  tunnel2_bgp_asn           = aws_vpn_connection.vpnConn[count.index].tunnel1_bgp_asn
  tunnel2_router_overlay_ip = aws_vpn_connection.vpnConn[count.index].tunnel2_cgw_inside_address
  tunnel2_aws_overlay_ip     = aws_vpn_connection.vpnConn[count.index].tunnel2_vgw_inside_address
  tunnel2_bgp_holdtime      = aws_vpn_connection.vpnConn[count.index].tunnel2_bgp_holdtime
  tunnel2_preshared_key     = aws_vpn_connection.vpnConn[count.index].tunnel2_preshared_key
  vpn_gateway_id            = ""
}

resource "aws_ec2_transit_gateway_route_table_propagation" "router_propagation" {
  count                          = local.total_vpn_connections
  transit_gateway_attachment_id  = aws_vpn_connection.vpnConn[count.index].transit_gateway_attachment_id
  transit_gateway_route_table_id = var.cnps_route_table_info
}
