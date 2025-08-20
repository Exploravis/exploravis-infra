resource "local_file" "ansible_inventory" {
  content  = <<EOT
[myvms]
${azurerm_linux_virtual_machine.vm.public_ip_address} ansible_user=${azurerm_linux_virtual_machine.vm.admin_username} ansible_ssh_private_key_file=~/.ssh/id_rsa.pem
EOT
  filename = "${path.module}/inventory.ini"
}
resource "null_resource" "configure_vm" {
  depends_on = [azurerm_linux_virtual_machine.vm]
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini playbook.yml -v"
  }
}
