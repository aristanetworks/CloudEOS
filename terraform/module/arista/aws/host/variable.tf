// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
variable "subnet_id" {}
variable "private_ips" {}
variable "ami" {}
variable "instance_type" {}
variable "tags" {}
variable "keypair_name" {}
variable "region" {}
variable "username" {
  type    = string
  default = "cloudeos"
}
variable "passwd" {
  type    = string
  default = "$1$SaltSalt$KWR36KJWI.AWkjpD1KU850"
}
