// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
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

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block[0]
  tags                 = var.tags
  depends_on           = [cloudeos_vpc_config.vpc[0]]
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol    = -1
    self        = false
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    self        = false
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allowSSHIKE" {
  count       = var.role == "CloudEdge" ? 1 : 0
  name        = "allow_ike_ssh"
  description = "Allow IKE/SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "icmp"
    from_port   = "-1"
    to_port     = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "internetGateway" {
  count  = var.role == "CloudEdge" ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.igw_name
  }
}

//The number of vpc_peering links is equal to the number of peers returned by CloudDeploy
//Count cannot be an output varaiable: https://github.com/hashicorp/terraform/issues/18923
resource "aws_vpc_peering_connection" "vpc_peer" {
  count         = var.role == "CloudLeaf" ? var.topology_name != "" ? 1 : var.topology_name == "" && var.peer_vpc_id != "" ? 1 : 0 : 0
  peer_vpc_id   = var.topology_name != "" ? cloudeos_vpc_config.vpc[0].peer_vpc_id : var.peer_vpc_id
  peer_owner_id = var.cross_account_peering == true ? var.peer_owner_id : ""
  vpc_id        = aws_vpc.vpc.id
  auto_accept   = var.cross_account_peering == true ? false : true
  tags = {
    Name = format("peering %s and %v", aws_vpc.vpc.id, cloudeos_vpc_config.vpc[0].peer_vpc_id)
  }
}
resource "aws_vpc_peering_connection_accepter" "peer" {
  count                     = var.cross_account_peering == true ? var.role == "CloudLeaf" ? var.topology_name != "" ? 1 : var.topology_name == "" && var.peer_vpc_id != "" ? 1 : 0 : 0 : 0
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer[0].id
  auto_accept               = true
}
