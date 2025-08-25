# Enable PKI secrets engine at path "pki"
resource "vault_mount" "pki" {
  path        = "pki"
  type        = "pki"
  description = "Naizoyden Domain RootCA PKI Secrets Engine"

  default_lease_ttl_seconds = 86400 # 1 day
  max_lease_ttl_seconds     = 315360000 # 10 years
}

#------------------------------------------- Generate Root CA -------------------------------------------
# This will generate a self-signed root CA certificate and store it in the Vault PKI secrets engine.
# The root CA will be valid for 10 years (315360000 seconds).
resource "vault_pki_secret_backend_root_cert" "root_2025" {
  depends_on  = [ vault_mount.pki ]
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = "Naizoyden-RootCA" 
  ttl         = 315360000 # 10 years
  format      = "pem"
}

# Configure CA & CRL URLs for the PKI secrets engine
resource "vault_pki_secret_backend_config_urls" "config-urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["https://PROD-RootCA.naizoyden.net:8200/v1/pki/ca"]
  crl_distribution_points = ["https://PROD-RootCA.naizoyden.net:8200/v1/pki/crl"]
}

# Manage the issuer created for the root CA
resource "vault_pki_secret_backend_issuer" "root_2025" {
  backend                        = vault_pki_secret_backend_root_cert.root_2025.backend
  issuer_ref                     = vault_pki_secret_backend_root_cert.root_2025.issuer_id
  issuer_name                    = "Naizoyden-RootCA" 
  revocation_signature_algorithm = "SHA256WithRSA"
}

# Create a role for issuing certificates by the RootCA
resource "vault_pki_secret_backend_role" "role" {
  backend          = vault_mount.pki.path
  name             = "RootCA-Issuing-Role"
  ttl             = 3600
  allow_ip_sans    = true
  key_type         = "ed25519"
  key_bits         = 256
  allowed_domains = ["naizoyden.net"]
  allow_subdomains = true
  allow_any_name   = true
}

# Sign the Intermediate CA CSR with the Root CA
resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  depends_on = [ data.terraform_remote_state.IntCA_TF ]
  backend     = vault_mount.pki.path
  common_name = "Naizoyden-IntermediateCA"
  csr         = data.terraform_remote_state.IntCA_TF.outputs.intermediate_csr
  issuer_ref  = vault_pki_secret_backend_root_cert.root_2025.issuer_id
  format      = "pem_bundle"
  ttl         = 15480000 # 180 days
}



