

module "clusters" {
  source   = "./modules/cluster"
  for_each = var.clusters

  cluster_name = "${each.key}-cluster"
  region       = each.value.region
  # worker_count   = each.value.worker_count
  workers = each.value.workers
  # instance_size  = each.value.instance_size
  # disk_size      = each.value.disk_size
  ssh_public_key = tls_private_key.cluster_ssh[each.key].public_key_openssh
  admin_username = each.value.admin_username
  depends_on     = [azurerm_key_vault_secret.cluster_private_key]
  tags           = each.value.tags
}

resource "random_uuid" "cluster_uuid" {
  for_each = var.clusters
}

resource "tls_private_key" "cluster_ssh" {
  for_each  = var.clusters
  algorithm = "RSA"
  rsa_bits  = 4096
}

# variable "ssh_public_key"{
#   type = string
#   description = "ssh pub for admin"
# }

data "azurerm_key_vault" "key" {
  name                = "wasp-vault"
  resource_group_name = "vault-rg"
}


resource "azurerm_key_vault_secret" "cluster_private_key" {
  for_each     = var.clusters
  name         = "${random_uuid.cluster_uuid[each.key].result}--private-key"
  value        = tls_private_key.cluster_ssh[each.key].private_key_pem
  key_vault_id = data.azurerm_key_vault.key.id
}

resource "azurerm_key_vault_secret" "cluster_public_key" {
  for_each     = var.clusters
  name         = "${random_uuid.cluster_uuid[each.key].result}--public-key"
  value        = tls_private_key.cluster_ssh[each.key].public_key_openssh
  key_vault_id = data.azurerm_key_vault.key.id
}

#
#
# locals {
#   ssh_pub_key = chomp(trimspace(data.azurerm_key_vault_secret.cluster_node_key.value))
# }



output "clusters_creds" {
  value = {
    for k, cluster in var.clusters :
    k => {
      cluster_id              = tls_private_key.cluster_ssh[k].id
      private_key_pem         = tls_private_key.cluster_ssh[k].private_key_pem
      public_key_openssh      = tls_private_key.cluster_ssh[k].public_key_openssh
      private_key_secret_name = azurerm_key_vault_secret.cluster_private_key[k].name
      public_key_secret_name  = azurerm_key_vault_secret.cluster_public_key[k].name
      admin_username          = cluster.admin_username
      master_ip               = module.clusters[k].master.public_ip
      worker_ips              = module.clusters[k].workers

      # worker_ips              = for w in module.clusters[k].workers : {
      #   name: w.vm_name
      #   public_ip: w.public_ip
      # }
    }
  }
  sensitive = true
}
