terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    cloudeos = {
      source = "aristanetworks/cloudeos"
      version = ">= 1.1.2"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
