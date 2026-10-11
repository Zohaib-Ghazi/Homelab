resource "vault_policy" "root-admin-policy" {
    provider = vault.pki_int
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

# Policy for Proxmox VMs to issue certificates via AppRole
resource "vault_policy" "IntPKI-cert-policy" {
    provider = vault.pki_int
    name = "IntPKI-cert-policy"

    policy = <<EOT
# Allow reading the intermediate CA certificate
path "pki_int/ca/pem" {
    capabilities = ["read"]
}

# Allow issuing certificates from any role in pki_int
path "pki_int/issue/*" {
    capabilities = ["create", "update"]
}

# Allow reading certificate data
path "pki_int/cert/*" {
    capabilities = ["read"]
}

# Allow appending to certificate issuing path (required for cert requests)
path "pki_int/sign/*" {
    capabilities = ["create", "update"]
}

# Allow token self-renewal
path "auth/token/renew-self" {
    capabilities = ["update"]
}

# Allow token lookup
path "auth/token/lookup-self" {
    capabilities = ["read"]
}
EOT
}