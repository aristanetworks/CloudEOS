terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
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
