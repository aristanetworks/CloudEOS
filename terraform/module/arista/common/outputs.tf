// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the COPYING file.
output "topology" {
  value = var.topology
}

output "keypair_name" {
  value = var.keypair_name
}

output "cvaas" {
  value = var.cvaas
}

output "instance_type" {
  value=var.instance_type
}

output "aws_regions" {
   value = var.aws_regions
}

output "eos_amis" {
  value = var.eos_amis
}

output "availability_zone" {
  value = var.availability_zone
}

output "host_amis" {
  value = var.host_amis
}
