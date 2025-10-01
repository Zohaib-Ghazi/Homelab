resource "vault_policy" "admin-vault-policy" {
    provider = vault.pki_int
    name = "admin-vault-policy"

    policy = <<EOT
path "*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
   
## Vault TF provider requires ability to create a child token
path "auth/token/create" {
    capabilities = ["create", "update", "sudo"]
}
EOT
}