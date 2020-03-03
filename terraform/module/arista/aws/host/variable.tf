variable "subnet_id" {}
variable "private_ips" {}
variable "ami" {}
variable "instance_type" {}
variable "tags" {}
variable "keypair_name" {}
variable "region" {}
variable "vpc_id" {}
variable "username" {
  type = string
  default = "cloudeos"
}
variable "passwd" {
  type = string
  default = "$1$SaltSalt$KWR36KJWI.AWkjpD1KU850"
}
