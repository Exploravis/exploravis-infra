variable "ansible_user" {
  type    = string
  default = "azureuser"
}

variable "ansible_ssh_private_key_file" {
  type    = string
  default = "~/.ssh/id_rsa.pem"
}
locals {
  inventory_dir = "${path.module}/artifacts"
}

# resource "local_file" "ansible_inventory_per_cluster" {
#   for_each = module.clusters
#   filename = "${local.inventory_dir}/${each.key}_inventory.ini"
#
#   content = <<EOT
# [master]
# ${each.value.master.name} ansible_host=${each.value.master.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.ansible_ssh_private_key_file}
#
# [workers]
# %{for w in each.value.workers~}
# ${w.name} ansible_host=${w.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.ansible_ssh_private_key_file}
# %{endfor~}
# EOT
# }
#
