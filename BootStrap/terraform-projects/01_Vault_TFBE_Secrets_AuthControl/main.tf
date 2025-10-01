# Enable secrets kv2 engine at path "terraform"
resource "vault_mount" "terraform" {
  path        = "terraform"
  type        = "kv-v2"
  description = "TF Secrets Engine"
}

resource "vault_kv_secret_v2" "TF_SPN_creds" {
  mount                      = vault_mount.terraform.path
  name                       = "secrets/TF_SPN"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    TF_SPN_role_id       = data.vault_approle_auth_backend_role_id.TF_SPN.role_id,
    TF_SPN_secret_id       = vault_approle_auth_backend_role_secret_id.TF_SPN.secret_id,
  }
  )
  custom_metadata {
    max_versions = 5
    data = {
      foo = "vault@example.com",
      bar = "12345"
    }
  }
}

resource "vault_kv_secret_v2" "Azure_creds" {
  mount                      = vault_mount.terraform.path
  name                       = "secrets/azure_creds"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    subscription_id       = var.subscription_id,
    client_id             = var.client_id,
    client_secret         = var.client_secret,
    tenant_id             = var.tenant_id,
  }
  )
  custom_metadata {
    max_versions = 5
    data = {
    }
  }
}

resource "vault_kv_secret_v2" "vault_creds" {
  mount                      = vault_mount.terraform.path
  name                       = "secrets/vault_creds"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    vault_address       = var.vault_address,
    vault_root_token    = var.vault_root_token,
  }
  )
  custom_metadata {
    max_versions = 5
    data = {
    }
  }
}