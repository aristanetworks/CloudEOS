// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
resource "cloudeos_vpc_config" "vpc" {
  count          = var.topology_name != "" ? 1 : 0
  cloud_provider = "aws"
  topology_name  = var.topology_name
  clos_name      = var.clos_name
  wan_name       = var.wan_name
  role           = var.role
  cnps           = lookup(var.tags, "Cnps", "")
  tags           = var.tags
  region         = var.region
  topology_id    = var.topology_id
  wan_id         = var.wan_id
  clos_id        = var.clos_id
}
