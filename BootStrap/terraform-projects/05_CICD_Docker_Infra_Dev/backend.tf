# Configure the backend to store the Terraform state in Azure Blob Storage
terraform {
    backend "azurerm" {
        resource_group_name  = "tfstate-rg"
        storage_account_name = "tfstatesa0dev"
        container_name       = "azurecloud-tfstate"
        key                  = "docker_infra.tfstate"
    }
}

#Read Vault secret for Azure Service Principal
ephemeral "vault_kv_secret_v2" "azure_creds" {
  provider = vault.tfbe
  mount = "terraform"
  name = "secrets/azure"
}

# Retrieve Azure credentials from Vault
locals {
  subscription_id = ephemeral.vault_kv_secret_v2.azure_creds.data["subscription_id"]
  client_id       = ephemeral.vault_kv_secret_v2.azure_creds.data["client_id"]
  client_secret   = ephemeral.vault_kv_secret_v2.azure_creds.data["client_secret"]
  tenant_id       = ephemeral.vault_kv_secret_v2.azure_creds.data["tenant_id"]
}