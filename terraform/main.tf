terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "test-rg"
  location = "spaincentral"
}

# Network module
module "network" {
  source              = "./modules/network"
  vnet_name           = "test-vnet"
  subnet_name         = "test-subnet"
  nsg_name            = "test-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24"]
}

# VM 1 
module "vm1" {
  source              = "./modules/vm"
  vm_name             = "test-vm"
  vm_size             = var.az_instance_size
  disk_size           = var.az_disk_size
  admin_username      = "azureuser"
  ssh_public_key      = "~/.ssh/id_rsa.pem.pub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network.subnet_id
  nsg_id              = module.network.nsg_id
}

# VM 2 
module "vm2" {
  source              = "./modules/vm"
  vm_name             = "test-2-vm"
  vm_size             = var.az_instance_size
  disk_size           = var.az_disk_size
  admin_username      = "azureuser"
  ssh_public_key      = "~/.ssh/id_rsa.pem.pub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network.subnet_id
  nsg_id              = module.network.nsg_id
}

output "master_public_ip" {
  value = module.vm1.public_ip
}

output "vm1_public_ip" {
  value = module.vm2.public_ip
}
