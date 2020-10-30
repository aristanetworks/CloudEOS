provider "aws" {
  region = var.region
}

provider "aws" {
  alias      = "peer"
  region     = var.region
  access_key = var.peer_access_key
  secret_key = var.peer_secret_key
  token      = var.peer_session_token
}

data "aws_caller_identity" "current" {}

//The number of vpc_peering links is equal to the number of peers returned by CloudDeploy
//Count cannot be an output varaiable: https://github.com/hashicorp/terraform/issues/18923
resource "aws_vpc_peering_connection" "vpc_peer" {
  count         = var.role == "CloudLeaf" && var.vpc_peering == true ? var.topology_name != "" ? 1 : var.topology_name == "" && var.peer_vpc_id != "" ? 1 : 0 : 0
  peer_vpc_id   = var.topology_name != "" ? cloudeos_vpc_config.vpc[0].peer_vpc_id : var.peer_vpc_id
  peer_owner_id = var.cross_account_peering == true ? var.peer_owner_id : ""
  vpc_id        = var.vpc_id
  auto_accept   = var.cross_account_peering == true ? false : true
  tags = {
    Name = format("peering %s and %v", var.vpc_id, cloudeos_vpc_config.vpc[0].peer_vpc_id)
  }
}
resource "aws_vpc_peering_connection_accepter" "peer" {
  count                     = var.cross_account_peering == true && var.vpc_peering == true ? var.role == "CloudLeaf" ? var.topology_name != "" ? 1 : var.topology_name == "" && var.peer_vpc_id != "" ? 1 : 0 : 0 : 0
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer[0].id
  auto_accept               = true
}
