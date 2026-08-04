# Output AppRole credentials for Proxmox VM provisioning
output "proxmox_vm_role_id" {
  description = "AppRole Role ID for Proxmox VMs to authenticate with Vault"
  value       = vault_approle_auth_backend_role.proxmox_vm_role.role_id
  sensitive   = true
}

output "proxmox_vm_secret_id" {
  description = "AppRole Secret ID for Proxmox VMs to authenticate with Vault"
  value       = vault_approle_auth_backend_role_secret_id.proxmox_vm_secret.secret_id
  sensitive   = true
}

# Output for certificate policy
output "proxmox_cert_policy_name" {
  description = "Name of the policy that allows certificate issuance"
  value       = vault_policy.proxmox-cert-policy.name
}

# Output AppRole auth path
output "vault_approle_path" {
  description = "Path to the AppRole auth backend"
  value       = vault_auth_backend.approle.path
}
