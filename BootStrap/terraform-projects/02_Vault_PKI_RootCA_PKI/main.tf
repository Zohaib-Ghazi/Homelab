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
  key_type    = "rsa"
  key_bits    = 4096
  #common_name = var.domain_name
  common_name = "${var.domain_name} Root CA" ## TODO: 04/05: To implement after tearing down homelab and rebuilding with new domain name 
  issuer_name = var.issuer_name
  ttl         = 315360000 # 10 years
  format      = "pem"
  #ou          = "Production"
  country     = "Canada"
  locality    = "Toronto"
  province    = "Ontario"
}

# the backend issuer is the element of the vault pki that enables people to requests issuing certs against this root 
resource "vault_pki_secret_backend_issuer" "root_2025" {
  #depends_on                     = [ vault_mount.pki ]
  provider                       = vault.pki
  backend                        = vault_mount.pki.path
  issuer_ref                     = vault_pki_secret_backend_root_cert.root_2025.issuer_id
  issuer_name                    = vault_pki_secret_backend_root_cert.root_2025.issuer_name
  revocation_signature_algorithm = "SHA256WithRSA"
}

# the backend role is the api parameters that are allowed to be used when signing issuing certs
resource "vault_pki_secret_backend_role" "role" {
  #depends_on       = [ vault_mount.pki ]
  provider         = vault.pki
  backend          = vault_mount.pki.path
  name             = "RootCA-Issuing-Role"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["${var.domain_name}"]
  allow_subdomains = true
  allow_any_name   = true
}

# Configure CA & CRL URLs for the PKI secrets engine
resource "vault_pki_secret_backend_config_urls" "config-urls" {
  #depends_on  = [ vault_mount.pki ]
  provider                 = vault.pki
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["${var.pki_vault_address_insecure}/v1/${vault_mount.pki.path}/ca"]
  crl_distribution_points = ["${var.pki_vault_address_insecure}/v1/${vault_mount.pki.path}/crl"]
  ocsp_servers = ["${var.pki_vault_address}/v1/${vault_mount.pki.path}/ocsp"]
  enable_templating = true
}

# Config pki cluster & AIA URLs
resource "vault_pki_secret_backend_config_cluster" "config-cluster" {
  provider                 = vault.pki
  backend  = vault_mount.pki.path
  path     = "${var.pki_vault_address}/v1/${vault_mount.pki.path}"
  aia_path = "${var.pki_vault_address_insecure}/v1/${vault_mount.pki.path}"
}