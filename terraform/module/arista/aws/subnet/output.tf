output "vpc_subnets" {
  description = "The ids of subnets created inside the new vpc"
  value       = arista_subnet.subnet.*.computed_subnet_id
}
output "subnet_cidr" {
  description = "map of subnet cidr to id"
  value = zipmap(keys(var.subnet_names), aws_subnet.subnet.*.id)
}
