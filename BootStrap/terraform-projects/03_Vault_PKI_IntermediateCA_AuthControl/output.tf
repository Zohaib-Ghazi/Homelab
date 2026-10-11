# Output AppRole credentials for Proxmox VM provisioning
output "IntPKI_approle_role_id" {
  description = "AppRole Role ID for Proxmox VMs to authenticate with Vault for certificate issuance"
  value       = vault_approle_auth_backend_role.AppRole_cert-requests.role_id
  sensitive   = true
}

output "IntPKI_approle_secret_id" {
  description = "AppRole Secret ID for Proxmox VMs to authenticate with Vault for certificate issuance"
  value       = vault_approle_auth_backend_role_secret_id.IntPKI_approle_secret.secret_id
  sensitive   = true
}

# # Output for certificate policy
# output "IntPKI_cert_policy_name" {
#   description = "Name of the policy that allows certificate issuance"
#   value       = vault_policy.IntPKI-cert-policy.name
# }

# # Output AppRole auth path
# output "vault_TFapprole_path" {
#   description = "Path to the AppRole auth backend"
#   value       = vault_auth_backend.TF_approle.path
# }
