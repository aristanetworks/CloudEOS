provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

//The number of vpc_peering links is equal to the number of peers returned by CloudDeploy
//Count cannot be an output varaiable: https://github.com/hashicorp/terraform/issues/18923
resource "aws_vpc_peering_connection" "vpc_peer" {
  count       = var.role == "CloudLeaf" ? var.topology_name != "" ? 1 : var.topology_name == "" && var.peer_vpc_id != "" ? 1 : 0 : 0
  peer_vpc_id = var.topology_name != "" ? arista_vpc_config.vpc[0].peer_vpc_id : var.peer_vpc_id
  vpc_id      = var.vpc_id
  auto_accept = true
  tags = {
    Name = format("peering %s and %v", var.vpc_id, arista_vpc_config.vpc[0].peer_vpc_id)
  }
}
