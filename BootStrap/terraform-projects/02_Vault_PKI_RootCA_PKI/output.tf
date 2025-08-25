#Output the root CA certificate
output "root_cert_2025" {
  value = vault_pki_secret_backend_root_cert.root_2025.certificate
}

#Save Root CA certificate to a file
resource "local_file" "root_2025_cert" {
  content  = vault_pki_secret_backend_root_cert.root_2025.certificate
  filename = "Naizoyden-RootCA.crt"
}

## Save the signed Intermediate CA certificate to a file
#resource "local_file" "intermediate_ca_cert" {
#  content  = vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate
#  filename = "intermediate.cert.pem"
#}

# Output the signed Intermediate CA certificate
output "signed_CSR" {
  value = vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate
}