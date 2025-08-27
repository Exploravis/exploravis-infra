terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.65"
    }
  }
}

provider "azurerm" {
  features {}
}


data "azurerm_key_vault" "key" {
  name = "wasp-vault"
  resource_group_name = "vault-rg"
}

data "azurerm_key_vault_secret" "mykey" {
  name         = "azureuser"
  key_vault_id = data.azurerm_key_vault.key.id
}

output "secret_value" {
  value     = data.azurerm_key_vault_secret.mykey.value
  sensitive = true
}
