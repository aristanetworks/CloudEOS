variable "subnet_names" {
  description = "Subnet names"
}

variable "vpc_id" {
  description = "vpc id"
}

variable "cloud_provider" {
         description = "aws, azure or gcp"
         type = string
         default = "aws"
}

variable "topology_name" {
  default = ""
}

variable "region" {
  default = ""
}
variable "subnet_cidr" {
  default = []
}
variable "subnet_id" {
  default = []
}
variable "availability_zone" {
  default = []
}
