resource "cloudeos_vpc_status" "vpc" {
  count             = var.topology_name != "" ? 1 : 0
  cloud_provider    = "aws"
  vpc_id            = var.vpc_id
  security_group_id = var.sg_id
  cidr_block        = var.vpc_cidr
  igw               = var.igw_id
  role              = var.role
  cnps              = lookup(var.tags, "Cnps", "")
  topology_name     = var.topology_name
  tags              = var.tags
  clos_name         = var.clos_name
  wan_name          = var.wan_name
  region            = var.region
  tf_id             = cloudeos_vpc_config.vpc[0].tf_id
  account           = data.aws_caller_identity.current.account_id
}
