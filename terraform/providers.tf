terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.65"
    }
  }
  backend "remote" {
    organization = "WaspCloud"

    workspaces {
      name = "Exploravis"
    }
  }
}

provider "azurerm" {
  features {}
}
