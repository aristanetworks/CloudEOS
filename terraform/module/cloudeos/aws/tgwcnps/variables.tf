variable "tgw_id" {
  description = "AWS TGW Id"
}
variable "router_info" {
  description = "List of CloudEOS instances which act as CGW"
  default = []
}
variable "bandwidth_gbps" {
  description = "Bandwidth required from each CNPS route table"
}
variable "cnps_route_table_info" {
  description = "Route Table id for the CNPS segment"
}
variable "cnps" {
  description = "CNPS segment for the VPN resource"
}
variable "bandwith_per_tunnel_gbps" {
  description = "Default bandwidth per VPN tunnel"
  default     = 1
}
variable "vpc_id" {
  description = "AWS VPC Id"
}
variable "region" {
  description = "AWS Region"
}
variable "vpc_attach_vpcs" {
  description = "VPC Ids to which the VPC attachments need to be made"
  default     = []
}
variable "vpc_attach_subnets" {
  description = "Subnets of the VPC required for the VPC attachment"
  default     = []
}
variable "create_vpn" {
  description = "Create VPN Attachments and connections"
  default = true
}
