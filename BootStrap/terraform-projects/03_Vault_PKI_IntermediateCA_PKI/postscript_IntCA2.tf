# Configure Issuing CA & CRL URLs for the PKI secrets engine
resource "vault_pki_secret_backend_config_urls" "config-urls" {
  #depends_on              = [ vault_mount.pki_int ]
  provider               = vault.pki
  backend                 = vault_mount.pki_int.path
  issuing_certificates    = ["${var.pki_vault_address_insecure}/v1/${vault_mount.pki_int.path}/ca"]
  crl_distribution_points = ["${var.pki_vault_address_insecure}/v1/${vault_mount.pki_int.path}/crl"]
  ocsp_servers = ["${var.pki_vault_address}/v1/${vault_mount.pki_int.path}/ocsp"]
  enable_templating = true
}

# Configure Cluster CA and AIA URLs for the PKI secrets engine
resource "vault_pki_secret_backend_config_cluster" "config-cluster" {
  provider               = vault.pki
  backend  = vault_mount.pki_int.path
  path     = "${var.pki_vault_address}/v1/${vault_mount.pki_int.path}"
  aia_path = "${var.pki_vault_address_insecure}/v1/${vault_mount.pki_int.path}"
}

resource "vault_generic_endpoint" "pki_int_tune" {
    provider               = vault.pki
  path                 = "sys/mounts/${vault_mount.pki_int.path}/tune"
  ignore_absent_fields = true
  disable_delete       = true
  data_json            = <<EOT
{
  "allowed_response_headers": [
      "Last-Modified",
      "Location",
      "Replay-Nonce",
      "Link"
    ],
  "passthrough_request_headers": [
    "If-Modified-Since"
  ]
}
EOT
}

# Enable ACME support for the Intermediate CA PKI secrets engine
resource "vault_generic_endpoint" "pki_int_acme" {
  # depends_on           = [vault_pki_secret_backend_role.learn]
  provider               = vault.pki
  path                 = "${vault_mount.pki_int.path}/config/acme"
  ignore_absent_fields = true
  disable_delete       = true

  data_json = <<EOT
{
    "enabled": true
}
EOT
}