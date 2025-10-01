resource "vault_policy" "admin-vault-policy" {
    name = "admin-vault-policy"

    policy = <<EOT
path "*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
   
## Vault TF provider requires ability to create a child token
path "auth/token/create" {
    capabilities = ["create", "update", "sudo"]
}

# Read system health check
path "sys/health"
{
  capabilities = ["read", "sudo"]
}

# Create and manage ACL policies broadly across Vault

# List existing policies
path "sys/policies/acl"
{
  capabilities = ["list"]
}

# Create and manage ACL policies
path "sys/policies/acl/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Enable and manage authentication methods broadly across Vault

# Manage auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# Enable and manage the key/value secrets engine at `secret/` path

# List, create, update, and delete key/value secrets
path "terraform/data/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage secrets engines
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing secrets engines.
path "sys/mounts"
{
  capabilities = ["read"]
}
EOT
}

resource "vault_policy" "root_ca_policy" {
    name = "root_ca_policy"

    policy = <<EOT
path "terraform/state/root_ca" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
EOT
}

resource "vault_policy" "int_ca_policy" {
    name = "int_ca_policy"

    policy = <<EOT
path "terraform/state/int_ca" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

path "terraform/state/root_ca" {
    capabilities = ["read", "list"]
}
EOT
}

resource "vault_policy" "TF_state_policy" {
    name = "tfbe-state-policy"

    policy = <<EOT
    path "terraform/data/secrets/*" {
        capabilities = ["read", "list"]
    }
EOT
}