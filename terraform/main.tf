

module "clusters" {
  source   = "./modules/cluster"
  for_each = var.clusters

  cluster_name   = "${each.key}-cluster"
  region         = each.value.region
  worker_count   = each.value.worker_count
  instance_size  = each.value.instance_size
  disk_size      = each.value.disk_size
  ssh_public_key =  tls_private_key.cluster_ssh.public_key_openssh
  admin_username = each.value.admin_username
  depends_on = [azurerm_key_vault_secret.cluster_private_key]
  # tags           = each.value.tags
}

resource "tls_private_key" "cluster_ssh"{
  algorithm = "RSA"
  rsa_bits = 4096
}

# variable "ssh_public_key"{
#   type = string
#   description = "ssh pub for admin"
# }

data "azurerm_key_vault" "key" {
  name = "wasp-vault"
  resource_group_name = "vault-rg"
}


resource "azurerm_key_vault_secret" "cluster_private_key" {
  name         = "az-cluster-node-private-key"
  value = tls_private_key.cluster_ssh.private_key_pem
  key_vault_id = data.azurerm_key_vault.key.id
}


resource "azurerm_key_vault_secret" "cluster_public_key" {
  name         = "az-cluster-node-public-key"
  value = tls_private_key.cluster_ssh.public_key_openssh
  key_vault_id = data.azurerm_key_vault.key.id
}
#
#
# locals {
#   ssh_pub_key = chomp(trimspace(data.azurerm_key_vault_secret.cluster_node_key.value))
# }
