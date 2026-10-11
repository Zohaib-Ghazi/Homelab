#Read Vault secret for Azure Service Principal
ephemeral "vault_kv_secret_v2" "IntPKI_creds" {
  provider = vault.tfbe
  mount = "terraform"
  name = "secrets/IntPKI"
}

# Retrieve Azure credentials from Vault
locals {
  APPROLE_ROLE_ID         = ephemeral.vault_kv_secret_v2.IntPKI_creds.data["IntPKI_AppRoleID"]
  APPROLE_SECRET_ID       = ephemeral.vault_kv_secret_v2.IntPKI_creds.data["IntPKI_AppSecretID"]
}