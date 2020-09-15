terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    cloudeos = {
      source = "aristanetworks/cloudeos"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}