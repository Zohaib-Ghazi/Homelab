#Read Vault secret for Azure Service Principal
data "vault_kv_secret_v2" "azure_creds" {
  mount = "terraform"
  name = "secrets/azure_creds"
}

#Read Vault secret for Vault credentials
data "vault_kv_secret_v2" "vault_creds" {
  mount = "terraform"
  name = "secrets/vault_creds"
}

#Read Vault secret for TF Service Principal
data "vault_kv_secret_v2" "TF_SPN" {
  mount = "terraform"
  name = "secrets/TF_SPN"
}

# Retrieve Azure credentials from Vault
locals {
  subscription_id = data.vault_kv_secret_v2.azure_creds.data["subscription_id"]
  client_id       = data.vault_kv_secret_v2.azure_creds.data["client_id"]
  client_secret   = data.vault_kv_secret_v2.azure_creds.data["client_secret"]
  tenant_id       = data.vault_kv_secret_v2.azure_creds.data["tenant_id"]
}