#Output the root CA certificate
output "root_cert_2025" {
  value = vault_pki_secret_backend_root_cert.root_2025.certificate
}

#Save Root CA certificate to a file
resource "local_file" "root_2025_cert" {
  content  = vault_pki_secret_backend_root_cert.root_2025.certificate
  filename = "Naizoyden-RootCA.crt"
}

# #Comment out - debugging
# output "backend_root_object" {
#   value = vault_pki_secret_backend_root_cert.root_2025
# }

# #Comment out - debugging
# output "issuer_id" {
#   value = vault_pki_secret_backend_root_cert.root_2025.issuer_id
# }

# #Comment out - debugging
# output "signed_object" {
#   value = vault_pki_secret_backend_root_sign_intermediate.signed_IntCACert
# }