resource "vault_auth_backend" "TF_userpass" {
   provider = vault.pki_int
   path = "userpass"
   type = "userpass"
}

# Create user for admin with admin-vault-policy
resource "vault_generic_endpoint" "TF-user" {
   provider = vault.pki_int
   path                 = "auth/${vault_auth_backend.TF_userpass.path}/users/${var.admin_name}"
   ignore_absent_fields = true
   data_json = <<EOT
   {
      "token_policies": ["admin-vault-policy"],
      "password": "${var.admin_password}"
   }
   EOT
}

# AppRole auth backend for Proxmox VMs to request certificates
resource "vault_auth_backend" "approle" {
  provider = vault.pki_int
  type     = "approle"
  path     = "approle"
}

# AppRole role for Proxmox VMs to request certificates
resource "vault_approle_auth_backend_role" "proxmox_vm_role" {
  provider       = vault.pki_int
  backend   = vault_auth_backend.approle.path
  role_name      = "proxmox-vm"
  token_policies = ["proxmox-cert-policy"]
  
  # Token TTL settings - tokens valid for 1 hour
  token_ttl     = 3600
  token_max_ttl = 10800
  
  # Allow tokens to be renewed up to max_ttl
  bind_secret_id = true
  secret_id_ttl  = 259200  # 3 days for secret_id validity
}

# Generate a static secret_id for initial provisioning
resource "vault_approle_auth_backend_role_secret_id" "proxmox_vm_secret" {
  provider       = vault.pki_int
  backend   = vault_auth_backend.approle.path
  role_name      = vault_approle_auth_backend_role.proxmox_vm_role.role_name
  metadata       = <<EOT
{
  "role": "proxmox-vm",
  "purpose": "certificate-management"
}
EOT
}