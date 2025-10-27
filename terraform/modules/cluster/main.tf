
# Flattened workers

locals {
  all_workers = flatten([
    for w in var.workers : [
      for i in range(w.count) : {
        name          = "${var.cluster_name}-${w.name}-${i + 1}"
        instance_size = w.instance_size
        disk_size     = w.disk_size
        tags          = w.tags

      }
    ]
  ])
}

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

module "policy" {
  source            = "../policy"
  resource_group_id = azurerm_resource_group.rg.id
}


# Master
module "master" {
  source = "../vm"

  vm_name             = "${var.cluster_name}-master"
  vm_size             = local.all_workers[0].instance_size
  disk_size           = local.all_workers[0].disk_size
  tags                = merge({ node_type = "master" }, local.all_workers[0].tags)
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network.subnet_id
  nsg_id              = module.network.nsg_id
  depends_on          = [module.network]
}

# Worker 
module "workers" {
  source    = "../vm"
  count     = length(local.all_workers)
  vm_name   = local.all_workers[count.index].name
  vm_size   = local.all_workers[count.index].instance_size
  disk_size = local.all_workers[count.index].disk_size
  tags      = merge({ node_type = "worker" }, local.all_workers[count.index].tags)

  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network.subnet_id
  nsg_id              = module.network.nsg_id # this should be made dynamic per group in the future

  depends_on = [module.network, module.master]
}




