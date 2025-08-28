
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.cluster_name}-rg"
  location = var.region 
}

# Network module
module "network" {
  source              = "../network"
  vnet_name           = "${var.cluster_name}-vnet"
  subnet_name         = "${var.cluster_name}-subnet"
  nsg_name            = "${var.cluster_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24"]
}


# Master
module "master" {
  source              = "../vm"
  vm_name             = "${var.cluster_name}-master"
  vm_size             = var.instance_size
  disk_size           = var.disk_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network.subnet_id
  nsg_id              = module.network.nsg_id
  depends_on = [module.network]
}

# Worker 
module "workers" {
  source              = "../vm"
  count               = var.worker_count
  vm_name             = "${var.cluster_name}-worker-${count.index + 1}"
  vm_size             = var.instance_size
  disk_size           = var.disk_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network.subnet_id
  nsg_id              = module.network.nsg_id

  depends_on = [module.network, module.master]
}




