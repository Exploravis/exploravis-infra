resource "local_file" "ansible_inventory" {
  content  = <<EOT
[master]
master ansible_host=${module.vm1.public_ip} ansible_user=azureuser ansible_ssh_private_key_file=~/.ssh/id_rsa.pem

[workers]
worker1 ansible_host=${module.vm2.public_ip} ansible_user=azureuser ansible_ssh_private_key_file=~/.ssh/id_rsa.pem
worker1 ansible_host=${module.vm3.public_ip} ansible_user=azureuser ansible_ssh_private_key_file=~/.ssh/id_rsa.pem
EOT
  filename = "${path.module}/inventory.ini"
}

