output "vpc_subnets" {
  description = "The ids of subnets created inside the new vpc"
  value       = arista_subnet.subnet.*.computed_subnet_id
}
