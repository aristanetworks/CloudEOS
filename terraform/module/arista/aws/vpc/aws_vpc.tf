provider "aws" {      
  region = var.region 
  access_key = "AKIARHBIZHWNJRWBJJJ3"
  secret_key = "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"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block[0]
  tags       = var.tags
  depends_on = [arista_vpc_config.vpc[0]]
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
  peer_vpc_id   = var.topology_name != "" ? arista_vpc_config.vpc[0].peer_vpc_id : var.peer_vpc_id
  vpc_id        = aws_vpc.vpc.id
  auto_accept   = true
  tags = {
    Name = format("peering %s and %v", aws_vpc.vpc.id, arista_vpc_config.vpc[0].peer_vpc_id )
  }
}
