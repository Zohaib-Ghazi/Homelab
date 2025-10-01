#Read Vault secret for Azure Service Principal
data "vault_kv_secret_v2" "azure_creds" {
  mount = "terraform"
  name = "secrets/azure_creds"
}

# Retrieve Azure credentials from Vault
locals {
  subscription_id = data.vault_kv_secret_v2.azure_creds.data["subscription_id"]
  client_id       = data.vault_kv_secret_v2.azure_creds.data["client_id"]
  client_secret   = data.vault_kv_secret_v2.azure_creds.data["client_secret"]
  tenant_id       = data.vault_kv_secret_v2.azure_creds.data["tenant_id"]
}