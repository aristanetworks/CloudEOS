// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
locals {
  empty_subnet_id    = [for name in var.subnet_names : ""]
  computed_subnet_id = length(arista_subnet.subnet.*.computed_subnet_id) > 0 ? arista_subnet.subnet.*.computed_subnet_id : local.empty_subnet_id
}
output "vpc_subnets" {
  description = "The ids of subnets created inside the new vpc"
  value       = local.computed_subnet_id
}
