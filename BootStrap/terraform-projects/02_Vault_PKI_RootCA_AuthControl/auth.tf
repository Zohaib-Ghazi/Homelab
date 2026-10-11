resource "vault_auth_backend" "root_userpass" {
   provider = vault.pki
   path = "userpass"
   type = "userpass"
}

# Create user for admin with root-admin-policy
resource "vault_generic_endpoint" "root-user" {
   provider = vault.pki
   path                 = "auth/${vault_auth_backend.root_userpass.path}/users/${var.admin_name}"
   ignore_absent_fields = true
   data_json = <<EOT
   {
      "token_policies": ["root-admin-policy"],
      "password": "${var.admin_password}"
   }
   EOT
}