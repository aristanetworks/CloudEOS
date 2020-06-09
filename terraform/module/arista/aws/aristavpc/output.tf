locals {
  peer_id       = length(aws_vpc_peering_connection.vpc_peer.*.id) > 0 ? aws_vpc_peering_connection.vpc_peer.*.id : []
  igw_id        = var.igw_id != "" ? [var.igw_id] : []
  sg_id         = var.sg_id != "" ? [var.sg_id] : []
  arista_vpc_id = length(arista_vpc.vpc.*.id) > 0 ? arista_vpc.vpc[0].id : ""
  peervpcidr    = var.role == "CloudLeaf" && length(arista_vpc_config.vpc.*.id) > 0 ? arista_vpc_config.vpc[0].peervpcidr : "0.0.0.0/0"
}

output "vpc_info" {
  value = [[var.vpc_id], local.igw_id, local.sg_id, local.peer_id, [var.vpc_cidr], [local.arista_vpc_id], [local.peervpcidr], [var.sg_default_id]]
}

output "peer_vpc_account_info" {
  value = [var.cross_account_peering, var.peer_access_key, var.peer_secret_key, var.peer_session_token]
}

output "vpc_id" {
  value = [var.vpc_id]
}

output "topology_name" {
  value = var.topology_name
}

output "region" {
  value = var.region
}
