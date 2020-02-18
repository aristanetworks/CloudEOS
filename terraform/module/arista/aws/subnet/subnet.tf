provider "aws" {
  region = var.region
}

resource "aws_subnet" "subnet" {
  count             = length(var.subnet_names)
  vpc_id            = var.vpc_id
  cidr_block        = element(keys(var.subnet_names), count.index)
  availability_zone = element(values(var.subnet_zones), count.index)
  tags = {
    "Name" = element(values(var.subnet_names), count.index)
  }
}
