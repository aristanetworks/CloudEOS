variable "cloudeos_cnps" {
  default     = false
  description = "Support segmentation in Leaf VPCs using CloudEOS routers"
}

variable "cnps" {
  description = "CNPS segments that the TGW supports"
}

variable "tags" {
  default     = {}
  description = "Tags for the TGW"
}

variable "dns_support" {
  default     = true
  description = "Whether DNS support is enabled."
}

variable "region" {
  description = "AWS Region"
}
