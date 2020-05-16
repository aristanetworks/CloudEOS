## do not remove this file..used for downloading terraform plugins during setup
provider "aws" {
  version = "=2.50"
}
provider "azurerm" {
  skip_provider_registration = true
  features {}
}
data "template_file" "user_data_precreated" {}
