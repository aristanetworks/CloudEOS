// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
resource "cloudeos_vpc_status" "vpc" {
  count             = var.topology_name != "" ? 1 : 0
  cloud_provider    = "aws"
  vpc_id            = aws_vpc.vpc.id
  security_group_id = length(aws_security_group.allowSSHIKE.*.id) > 0 ? aws_security_group.allowSSHIKE[0].id : ""
  cidr_block        = aws_vpc.vpc.cidr_block
  igw               = length(aws_internet_gateway.internetGateway.*.id) > 0 ? aws_internet_gateway.internetGateway[0].id : ""
  role              = var.role
  topology_name     = var.topology_name
  tags              = var.tags
  cnps              = lookup(var.tags, "Cnps", "")
  clos_name         = var.clos_name
  wan_name          = var.wan_name
  region            = var.region
  tf_id             = cloudeos_vpc_config.vpc[0].tf_id
  account           = data.aws_caller_identity.current.account_id
}
