# Enable userpass auth method for human users
resource "vault_auth_backend" "TF_userpass" {
   type = "userpass"
}

# Create user for admin with admin-vault-policy
resource "vault_generic_endpoint" "TF-user" {
   path                 = "auth/${vault_auth_backend.TF_userpass.path}/users/${var.admin_name}"
   ignore_absent_fields = true
   data_json = <<EOT
   {
      "token_policies": ["admin-vault-policy"],
      "password": "${var.admin_password}"
   }
   EOT
}

# Enable approle auth method for machine clients
resource "vault_auth_backend" "TF_approle" {
   type = "approle"
   path = "approle"
}

# Create approle for root_ca client 
resource "vault_approle_auth_backend_role" "rootca" {
   backend       = vault_auth_backend.TF_approle.path
   role_name    = "root_ca_approle"
   token_policies = ["root_ca_policy"]
   secret_id_ttl = "0" # Secret ID does not expire
   token_ttl     = "1800" # Token is valid for 30 min (in sec)
   token_max_ttl = "3600" # Token can be renewed up to 1 hour (in sec)
}

# Create approle for int_ca client
resource "vault_approle_auth_backend_role" "intca" {
  backend       = vault_auth_backend.TF_approle.path
  role_name    = "int_ca_approle"
  token_policies = ["pki_int_ca_policy"]
  secret_id_ttl = "0" # Secret ID does not expire
  token_ttl     = "1800" # Token is valid for 30 min (in sec)
  token_max_ttl = "3600" # Token can be renewed up to 1 hour (in sec)
}

# Create approle for TF clients
resource "vault_approle_auth_backend_role" "TF_SPN" {
  backend       = vault_auth_backend.TF_approle.path
  role_name    = "tf_client_approle"
  token_policies = ["tfbe-state-policy"]
  secret_id_ttl = "0" # Secret ID does not expire
  token_ttl     = "1800" # Token is valid for 30 min (in sec)
  token_max_ttl = "3600" # Token can be renewed up to 1 hour (in sec)
}