#Not currently used, but can be used to create approle for root_ca client
# # Create approle for root_ca client 
# resource "vault_approle_auth_backend_role" "rootca" {
#    backend       = vault_auth_backend.TF_approle.path
#    role_name    = "root-ca-approle"
#    token_policies = ["root_ca_policy"]
#    secret_id_ttl = "0" # Secret ID does not expire
#    token_ttl     = "1800" # Token is valid for 30 min (in sec)
#    token_max_ttl = "3600" # Token can be renewed up to 1 hour (in sec)
# }

# Create approle for int_ca client
resource "vault_approle_auth_backend_role" "tf_admin_approle" {
  backend       = vault_auth_backend.TF_approle.path
  role_name    = "tf_admin_approle"
  token_policies = ["tf-admin-policy"]
  secret_id_ttl = "0" # Secret ID does not expire
  token_ttl     = "1800" # Token is valid for 30 min (in sec)
  token_max_ttl = "3600" # Token can be renewed up to 1 hour (in sec)
}

# Not currently used, but can be used to create approle for TF_SPN client
# # Create approle for TF clients
# resource "vault_approle_auth_backend_role" "TF_SPN" {
#   backend       = vault_auth_backend.TF_approle.path
#   role_name    = "tf_client_approle"
#   token_policies = ["tfbe-state-policy"]
#   secret_id_ttl = "0" # Secret ID does not expire
#   token_ttl     = "1800" # Token is valid for 30 min (in sec)
#   token_max_ttl = "3600" # Token can be renewed up to 1 hour (in sec)
# }

# resource "vault_pki_secret_backend_role" "role-server-cer" {
#   depends_on = [ vault_mount.terraform ]
#   backend = vault_mount.pki_int.path
#   name = "server-cert-for-${var.server_cert_domain}"
#   allowed_domains = [ var.server_cert_domain ]
#   allow_subdomains = true
#   allow_glob_domains = false
#   allow_any_name = false
#   enforce_hostnames = true
#   allow_ip_sans = true
#   server_flag = true
#   client_flag = false 
#   ou = ["Development"]
#   organization = ["HomeLab Inc."]
#   country = ["Canada"]
#   locality = ["Toronto"]
#   # 2 years
#   max_ttl = 63113904 
#   # 30 days
#   ttl = 2592000
#   no_store = false
# }

# resource "vault_pki_secret_backend_role" "vault-client-cert" {
#   depends_on = [ vault_mount.pki_int ]
#   backend = vault_mount.pki_int.path
#   name = "client-cert-for-${var.client_cert_domain}"
#   allowed_domains = [ var.client_cert_domain ]
#   allow_subdomains = false
#   allow_glob_domains = false
#   allow_bare_domains = true # needed for email address verification
#   allow_any_name = false 
#   enforce_hostnames = true
#   allow_ip_sans = true
#   #allowed_other_sans = ["1.2.840.113549.1.9.1;utf8:emailAddress"]
#   server_flag = true
#   client_flag = true 
#   ou = ["Development"]
#   organization = ["HomeLab Inc."]
#   country = ["Canada"]
#   locality = ["Toronto"]
#   # 2 years
#   max_ttl = 63113904 
#   # 30 days
#   ttl = 2592000
#   no_store = false
# }