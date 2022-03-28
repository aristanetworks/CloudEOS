terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.0"    
    }

    cloudeos = {
      source = "aristanetworks/cloudeos"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
