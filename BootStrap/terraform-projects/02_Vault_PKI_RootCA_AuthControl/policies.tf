resource "vault_policy" "root-admin-policy" {
    provider = vault.pki
    name = "root-admin-policy"

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