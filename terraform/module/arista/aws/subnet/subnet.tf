// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
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
