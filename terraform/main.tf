terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.65"
      # version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}


module "spain-cl" {
  source = "./modules/cluster"
  cluster_name   = "spain-cluster"
  region         = "spaincentral"
  worker_count   = 3
  vm_size        = "Standard_B1ms"
  disk_size      = 30 
  ssh_public_key = "~/.ssh/id_rsa.pub"
}

module "southuk-cl" {
  source = "./modules/cluster"
  cluster_name   = "uksouth-cluster"
  region         = "uksouth"
  worker_count   = 1 
  vm_size        = "Standard_B1ms"
  disk_size      = 30 
  ssh_public_key = "~/.ssh/id_rsa.pub"
}


