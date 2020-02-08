variable "subnet_zones" {
  description = "Subnet to Availability Zone map"
  type        = map(string)
}

variable "subnet_names" {
  description = "Subnet to name map"
  type        = map(string)
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
