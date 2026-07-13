# Enable PKI secrets engine at path "pki"
resource "vault_mount" "pki_int" {
  provider    = vault.pki
  path        = "pki_int"
  type        = "pki"
  description = "Intermediate Authority for ${var.domain_name}"

  default_lease_ttl_seconds = 43800 # 12 hours
  max_lease_ttl_seconds     = 157680000 # 5 years
}

# Generate Intermediate CA CSR
resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate-csr-request" {
  #depends_on  = [ vault_mount.pki_int ]
  provider    = vault.pki
  backend     = vault_mount.pki_int.path
  type        = "internal"
  common_name = "${var.domain_name} Intermediate CA"
  format      = "pem"
  private_key_format  = "der"
  key_type    = "rsa"
  key_bits    = 4096
}