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
      name = "k3s-terraform-ansible-cluster"
    }
  }
}

provider "azurerm" {
  features {}
}
