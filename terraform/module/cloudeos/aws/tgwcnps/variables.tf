variable "tgw_id" {}
variable "router_info" {}
variable "bandwidth_gbps" {}
variable "cnps_route_table_info" {}
variable "cnps" {}
variable "create_tgw" {
  default = false
}
variable "tgw_vpc_attachments" {
  default = {}
}

variable "bandwith_per_tunnel_gbps" {
  default = 1
}
variable "vpc_id" {}
