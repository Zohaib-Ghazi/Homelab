resource "vault_auth_backend" "TF_userpass" {
  type = "userpass"
}

resource "vault_generic_endpoint" "TF-user" {
   path                 = "auth/${vault_auth_backend.TF_userpass.path}/users/admin"
   ignore_absent_fields = true
   data_json = <<EOT
   {
      "token_policies": ["admin-vault-policy"],
      "password": "Passw0rd"
   }
   EOT
}