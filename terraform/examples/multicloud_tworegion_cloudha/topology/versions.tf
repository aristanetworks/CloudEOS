terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    cloudeos = {
      source = "aristanetworks/cloudeos"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
