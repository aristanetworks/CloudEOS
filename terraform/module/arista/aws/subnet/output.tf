// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the COPYING file.
output "vpc_subnets" {
  description = "The ids of subnets created inside the new vpc"
  value       = arista_subnet.subnet.*.computed_subnet_id
}
output "subnet_cidr" {
  description = "map of subnet cidr to id"
  value = length(aws_subnet.subnet.*.id) > 0 ? zipmap(keys(var.subnet_names), aws_subnet.subnet.*.id) : {}
}
