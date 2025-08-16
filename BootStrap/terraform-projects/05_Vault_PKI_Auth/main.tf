provider "vault" {
    address = "https://PROD-RootCA.naizoyden.net:8200"
    token = "${var.vault_root_token}"
}

resource "vault_auth_backend" "TF_userpass" {
  type = "userpass"
}

resource "vault_generic_endpoint" "TF-user" {
   path                 = "auth/${vault_auth_backend.TF_userpass.path}/users/TF-vault-user"
   ignore_absent_fields = true
   data_json = <<EOT
{
   "token_policies": ["developer-vault-policy"],
   "password": "Passw0rd"
}
EOT
}

resource "vault_policy" "developer-vault-policy" {
   name = "developer-vault-policy"

   policy = <<EOT
   path "dev-secrets/+/creds" {
   capabilities = ["create", "update"]
}
path "dev-secrets/+/creds" {
   capabilities = ["read"]
}
## Vault TF provider requires ability to create a child token
path "auth/token/create" {
   capabilities = ["create", "update", "sudo"]
}
EOT
}