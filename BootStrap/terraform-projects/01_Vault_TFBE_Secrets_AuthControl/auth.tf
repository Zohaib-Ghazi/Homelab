# Enable userpass auth method for human users
resource "vault_auth_backend" "root_userpass" {
   type = "userpass"
}

# Create user for admin with root-admin-policy
resource "vault_generic_endpoint" "root-user" {
   path                 = "auth/${vault_auth_backend.root_userpass.path}/users/${var.admin_name}"
   ignore_absent_fields = true
   data_json = <<EOT
   {
      "token_policies": ["root-admin-policy"],
      "password": "${var.admin_password}"
   }
   EOT
}

# Enable approle auth method for machine clients
resource "vault_auth_backend" "TF_approle" {
   type = "approle"
   path = "approle"
}