// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the COPYING file.
resource "arista_subnet" "subnet" {
         count = var.topology_name != "" ? length(var.subnet_names) : 0
         cloud_provider = var.cloud_provider
         vpc_id = var.vpc_id
         availability_zone = aws_subnet.subnet[count.index].availability_zone
         subnet_id = aws_subnet.subnet[count.index].id
         cidr_block = aws_subnet.subnet[count.index].cidr_block
         subnet_name = values(var.subnet_names)[count.index]
}