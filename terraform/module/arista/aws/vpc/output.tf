output "vpc_id" {
  value = aws_vpc.vpc.*.id
}

output "vpc_name_toid" {
       value = map( var.tags["Name"], aws_vpc.vpc.*.id[0] )
}

output "vpc_cidr" {
       value = map(aws_vpc.vpc.*.id[0], aws_vpc.vpc.*.cidr_block[0])
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internetGateway.*.id
}

output "default_rt_id" {
  value = aws_vpc.vpc.*.default_route_table_id
}

output "sg_id" {
  value = length(aws_security_group.allowSSHIKE.*.id) > 0 ? aws_security_group.allowSSHIKE[0].id : ""
}

locals {
  peer_id = length(aws_vpc_peering_connection.vpc_peer.*.id) > 0 ? aws_vpc_peering_connection.vpc_peer.*.id : []
  igw_id  = length(aws_internet_gateway.internetGateway.*.id) > 0 ? [aws_internet_gateway.internetGateway[0].id] : []
  sg_id   = length(aws_security_group.allowSSHIKE.*.id) > 0 ? [aws_security_group.allowSSHIKE[0].id] : []
  arista_vpc_id = length(arista_vpc.vpc.*.id) > 0 ? arista_vpc.vpc[0].id : ""
  peervpcidr = var.role == "CloudLeaf" && length(arista_vpc_config.vpc.*.id) > 0 ? arista_vpc_config.vpc[0].peervpcidr : "0.0.0.0/0"
}

output "vpc_info" {
  value = [[aws_vpc.vpc.id], local.igw_id, local.sg_id, local.peer_id, [aws_vpc.vpc.cidr_block], [local.arista_vpc_id], [local.peervpcidr]]
}

output "topology_name" {
  value = var.topology_name
}

output "region" {
  value = var.region
}
