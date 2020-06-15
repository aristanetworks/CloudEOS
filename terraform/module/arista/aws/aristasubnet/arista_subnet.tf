resource "arista_subnet" "subnet" {
  count             = var.topology_name != "" ? length(var.subnet_names) : 0
  cloud_provider    = var.cloud_provider
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone[count.index]
  subnet_id         = var.subnet_id[count.index]
  cidr_block        = var.subnet_cidr[count.index]
  subnet_name       = var.subnet_names[count.index]
}
