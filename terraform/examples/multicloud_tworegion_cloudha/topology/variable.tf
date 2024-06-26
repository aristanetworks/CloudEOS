variable "topology" {}
variable "keypair_name" {}
variable "cvaas" {}
variable "instance_type" {}
variable "aws_regions" {}
variable "azure_regions"{}
variable "availability_zone" {}
variable "host_amis" {}
variable "vtep_ip_cidr" {}
variable "terminattr_ip_cidr" {}
variable "dps_controlplane_cidr" {}
variable "clos_cv_container" {}
variable "wan_cv_container" {}
variable "aws_iam_instance_profile" {}
variable "vpc_info"{}
variable "cloudeos_info"{}
variable "username"{}
variable "password"{}
variable "licenses" {}
variable "cloudeos_image_offer" {}
variable "eos_payg_amis" {}
variable "eos_byol_amis" {}
variable "ingress_allowlist" {}
locals {
   eos_amis = var.cloudeos_image_offer == "cloudeos-router-payg" ? var.eos_payg_amis : var.eos_byol_amis
}
