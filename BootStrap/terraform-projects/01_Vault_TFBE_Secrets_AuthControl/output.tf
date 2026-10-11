# output "rootca_role_id" {
#   value = data.vault_approle_auth_backend_role_id.rootca.role_id
# }

# output "rootca_secret_id" {
#   value = vault_approle_auth_backend_role_secret_id.rootca.secret_id
#   sensitive = true
# }

output "TFBE_AppRoleID" {
  value = data.vault_approle_auth_backend_role_id.tf_admin_approle_id.role_id
}

output "TFBE_AppSecretID" {
  value = vault_approle_auth_backend_role_secret_id.tf_admin_approle_secretid.secret_id
  sensitive = true
}

# output "TF_SPN_role_id" {
#   value = data.vault_approle_auth_backend_role_id.TF_SPN.role_id
# }

# output "TF_SPN_secret_id" {
#   value = vault_approle_auth_backend_role_secret_id.TF_SPN.secret_id
#   sensitive = true
# }

output "subscription_id" {
  value = var.subscription_id
  sensitive = true
}

output "client_id" {
  value = var.client_id
  sensitive = true
}

output "client_secret" {
  value = var.client_secret
  sensitive = true
}

output "tenant_id" {
  value = var.tenant_id
  sensitive = true
}