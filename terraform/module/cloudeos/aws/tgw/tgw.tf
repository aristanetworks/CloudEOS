provider "aws" {
  region = var.region
}

resource "aws_ec2_transit_gateway" "tgw" {
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = var.cloudeos_cnps ? "enable" : "disable"
  default_route_table_propagation = var.cloudeos_cnps ? "enable" : "disable"
  tags                            = var.tags
  dns_support                     = var.dns_support ? "enable" : "disable"
  vpn_ecmp_support                = "enable"
}

resource "aws_ec2_transit_gateway_route_table" "route_tables" {
  count              = length(var.cnps)
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags               = { "Name" = format("%s-%v-rttable", var.cnps[count.index], aws_ec2_transit_gateway.tgw.id) }
}

output "tgw_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "tgw_rttable_id" {
  value = aws_ec2_transit_gateway_route_table.route_tables.*.id
}

output "tgw_cnps" {
  value = var.cnps
}
