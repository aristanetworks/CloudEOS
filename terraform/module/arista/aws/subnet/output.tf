output "vpc_subnets" {
  description = "The ids of subnets created inside the new vpc"
  value       = aws_subnet.subnet.*.id
}
output "subnet_cidr" {
  description = "map of subnet cidr to id"
  value = zipmap(keys(var.subnet_names), aws_subnet.subnet.*.id)
}