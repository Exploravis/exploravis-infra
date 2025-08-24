



module "clusters" {
  source   = "./modules/cluster"
  for_each = var.clusters

  cluster_name   = "${each.key}-cluster"
  region         = each.value.region
  worker_count   = each.value.worker_count
  instance_size  = each.value.instance_size
  disk_size      = each.value.disk_size
  ssh_public_key = each.value.ssh_public_key
  admin_username = each.value.admin_username
  # tags           = each.value.tags
}
