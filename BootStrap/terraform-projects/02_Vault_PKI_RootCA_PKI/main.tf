# Enable PKI secrets engine at path "pki"
resource "vault_mount" "pki" {
  provider    = vault.pki
  path        = "pki"
  type        = "pki"
  description = "Root Certificate Authority for ${var.domain_name}"

  default_lease_ttl_seconds = 86400 # 1 day
  max_lease_ttl_seconds     = 315360000 # 10 years
}

#------------------------------------------- Generate Root CA -------------------------------------------
# This will generate a self-signed root CA certificate and store it in the Vault PKI secrets engine.
# The root CA will be valid for 10 years (315360000 seconds).
resource "vault_pki_secret_backend_root_cert" "root_2025" {
  provider    = vault.pki
  backend     = vault_mount.pki.path
  type        = "internal"
  key_type    = "ed25519"
  common_name = var.domain_name
  issuer_name = var.issuer_name
  ttl         = 315360000 # 10 years
  format      = "pem"
}

# Manage the issuer created for the root CA
resource "vault_pki_secret_backend_issuer" "root_2025" {
  #depends_on                     = [ vault_mount.pki ]
  provider                       = vault.pki
  backend                        = vault_pki_secret_backend_root_cert.root_2025.backend
  issuer_ref                     = vault_pki_secret_backend_root_cert.root_2025.issuer_id
  issuer_name                    = var.issuer_name
  #revocation_signature_algorithm = "SHA256WithRSA"
}

# Configure CA & CRL URLs for the PKI secrets engine
resource "vault_pki_secret_backend_config_urls" "config-urls" {
  #depends_on  = [ vault_mount.pki ]
  provider                 = vault.pki
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["${var.pki_vault_address}/v1/${vault_mount.pki.path}/ca"]
  crl_distribution_points = ["${var.pki_vault_address}/v1/${vault_mount.pki.path}/crl"]
}

# Create a role for issuing certificates by the RootCA
resource "vault_pki_secret_backend_role" "role" {
  #depends_on       = [ vault_mount.pki ]
  provider         = vault.pki
  backend          = vault_mount.pki.path
  name             = "RootCA-Issuing-Role"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "ed25519"
  #key_bits         = 256
  allowed_domains  = ["${var.domain_name}"]
  allow_subdomains = true
  allow_any_name   = true
}