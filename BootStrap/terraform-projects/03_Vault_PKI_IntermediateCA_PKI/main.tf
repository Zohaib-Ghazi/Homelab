# Enable PKI secrets engine at path "pki"
resource "vault_mount" "pki" {
  path        = "pki_int"
  type        = "pki"
  description = "Naizoyden Domain IntCA PKI Secrets Engine"

  default_lease_ttl_seconds = 43800 # 12 hours
  max_lease_ttl_seconds     = 157680000 # 5 years
}

# Configure CA & CRL URLs for the PKI secrets engine
resource "vault_pki_secret_backend_config_urls" "config-urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["https://PROD-IntermediateCA.naizoyden.net:8200/v1/pki/ca"]
  crl_distribution_points = ["https://PROD-IntermediateCA.naizoyden.net:8200/v1/pki/crl"]
}

# Generate Intermediate CA CSR
resource "vault_pki_secret_backend_intermediate_cert_request" "csr-request" {
  depends_on  = [ vault_mount.pki ]
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = "Naizoyden-IntermediateCA"
}

# Import the signed intermediate CA certificate into the PKI secrets engine
resource "vault_pki_secret_backend_intermediate_set_signed" "signed_intermediate" {
  depends_on = [ data.terraform_remote_state.RootCA_TF ]
  backend     = vault_mount.pki.path
  certificate = data.terraform_remote_state.RootCA_TF.outputs.signed_CSR
}

# Manage the issuer role created for the Intermediate CA
resource "vault_pki_secret_backend_issuer" "intermediate" {
  backend                        = vault_mount.pki.path
  issuer_ref                     = vault_pki_secret_backend_intermediate_set_signed.signed_intermediate.id
  issuer_name                    = "Naizoyden-IntermediateCA" 
  revocation_signature_algorithm = "SHA256WithRSA"
}

# Create a role for issuing certificates by the RootCA
resource "vault_pki_secret_backend_role" "IntCA_role" {
  backend          = vault_mount.pki.path
  name             = "IntCA-Issuing-Role"
  ttl             = 3600
  allow_ip_sans    = true
  key_type         = "ed25519"
  key_bits         = 256
  allowed_domains = ["naizoyden.net"]
  allow_subdomains = true
  allow_any_name   = true
}