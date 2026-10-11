resource "vault_kv_secret_v2" "IntPKI_AppRole_creds" {
  provider = vault.tfbe
  #mount                      = vault_mount.terraform.path
  mount                      = "terraform"
  name                       = "secrets/IntPKI"
  cas                        = 1
  #delete_all_versions        = true
  data_json                  = jsonencode(
  {
    IntPKI_AppRoleID       = vault_approle_auth_backend_role.AppRole_cert-requests.role_id,
    IntPKI_AppSecretID    = vault_approle_auth_backend_role_secret_id.IntPKI_approle_secret.secret_id,
  }
  )
  custom_metadata {
    max_versions = 5
    data = {
    }
  }
}