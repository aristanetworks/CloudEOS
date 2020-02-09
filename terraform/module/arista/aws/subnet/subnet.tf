provider "aws" {
  region = var.region
  access_key = "AKIARHBIZHWNJRWBJJJ3"
  secret_key = "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"
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
