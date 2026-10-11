resource "vault_policy" "root-admin-policy" {
    name = "root-admin-policy"

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

# TODO: Validate access from rootca during bootstrap process
# resource "vault_policy" "root_ca_policy" {
#     name = "root-ca-policy"

#     policy = <<EOT
# path "terraform/data/secrets/*" {
#     capabilities = ["create", "read", "update", "list"]
# }
# EOT
# }

resource "vault_policy" "tf-admin-policy" {
    name = "tf-admin-policy"

    policy = <<EOT
# Create, update, and delete  key/value 
path "terraform/data/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete metadata 
path "terraform/metadata/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Allows the AppRole to create, update, or read the 'terraform' secrets engine mount
path "sys/mounts/terraform"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# (Optional) Frequently required for tuning the mount's TTLs or configurations
path "sys/mounts/terraform/tune" {
  capabilities = ["update", "read"]
}
EOT
}