# data "vault_approle_auth_backend_role_id" "rootca" {
#   backend   = vault_auth_backend.TF_approle.path
#   role_name = vault_approle_auth_backend_role.rootca.role_name
# }

# resource "vault_approle_auth_backend_role_secret_id" "rootca" {
#   backend   = vault_auth_backend.TF_approle.path
#   role_name = vault_approle_auth_backend_role.rootca.role_name
# }

data "vault_approle_auth_backend_role_id" "tf_admin_approle_id" {
  backend   = vault_auth_backend.TF_approle.path
  role_name = vault_approle_auth_backend_role.tf_admin_approle.role_name
}

resource "vault_approle_auth_backend_role_secret_id" "tf_admin_approle_secretid" {
  backend   = vault_auth_backend.TF_approle.path
  role_name = vault_approle_auth_backend_role.tf_admin_approle.role_name
}

# data "vault_approle_auth_backend_role_id" "TF_SPN" {
#   backend   = vault_auth_backend.TF_approle.path
#   role_name = vault_approle_auth_backend_role.TF_SPN.role_name
# }

# resource "vault_approle_auth_backend_role_secret_id" "TF_SPN" {
#   backend   = vault_auth_backend.TF_approle.path
#   role_name = vault_approle_auth_backend_role.TF_SPN.role_name
# }