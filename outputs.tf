data "azurerm_public_ip" "example" {
  name                = azurerm_public_ip.az_public_ip_1.name
  resource_group_name = azurerm_linux_virtual_machine.vm.resource_group_name

}

output "public_ip_address" {
  value = data.azurerm_public_ip.example.ip_address
}
