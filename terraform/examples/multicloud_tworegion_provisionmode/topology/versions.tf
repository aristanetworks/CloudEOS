terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    cloudeos = {
      source = "aristanetworks/cloudeos"
      version = ">= 1.2.2"
    }
  }
}
