#Read Vault secret for Azure Service Principal
ephemeral "vault_kv_secret_v2" "azure_creds" {
  provider = vault.tfbe
  mount = "terraform"
  name = "secrets/azure"
}

#Read Vault secret for Vault credentials
ephemeral "vault_kv_secret_v2" "vault_creds" {
  provider = vault.tfbe
  mount = "terraform"
  name = "secrets/vault"
}

# #Read Vault secret for TF Service Principal
# ephemeral "vault_kv_secret_v2" "TF_SPN" {
#   provider = vault.tfbe
#   mount = "terraform"
#   name = "secrets/TF_SPN"
# }

# Retrieve Azure credentials from Vault
locals {
  subscription_id = ephemeral.vault_kv_secret_v2.azure_creds.data["subscription_id"]
  client_id       = ephemeral.vault_kv_secret_v2.azure_creds.data["client_id"]
  client_secret   = ephemeral.vault_kv_secret_v2.azure_creds.data["client_secret"]
  tenant_id       = ephemeral.vault_kv_secret_v2.azure_creds.data["tenant_id"]
}