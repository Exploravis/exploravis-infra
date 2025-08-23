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




module "clusters" {
  source   = "./modules/cluster"
  for_each = var.clusters

  # cluster_key    = each.key
  cluster_name   = "${each.key}-cluster"
  region         = each.value.region
  worker_count   = each.value.worker_count
  instance_size  = each.value.vm_size
  disk_size      = each.value.disk_size
  ssh_public_key = each.value.ssh_public_key
  admin_username = each.value.ssh_public_key
  # tags           = each.value.tags
}
