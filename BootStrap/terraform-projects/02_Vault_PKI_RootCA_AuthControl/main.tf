resource "vault_auth_backend" "TF_userpass" {
   provider = vault.pki
   path = "userpass"
   type = "userpass"
}

# Create user for admin with admin-vault-policy
resource "vault_generic_endpoint" "TF-user" {
   provider = vault.pki
   path                 = "auth/${vault_auth_backend.TF_userpass.path}/users/${var.admin_name}"
   ignore_absent_fields = true
   data_json = <<EOT
   {
      "token_policies": ["admin-vault-policy"],
      "password": "${var.admin_password}"
   }
   EOT
}