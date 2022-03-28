terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.0"
    }

    cloudeos = {
      source = "aristanetworks/cloudeos"
      version = ">= 1.1.3"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
