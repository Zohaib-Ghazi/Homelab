## Save the CSR to a file
#resource "local_file" "csr_request_cert" {
#  content  = vault_pki_secret_backend_intermediate_cert_request.csr-request.csr
#  filename = "Naizyoden_IntCA_CSR.csr"
#}

# Output the Intermediate CA CSR
output "intermediate_csr" {
    value = vault_pki_secret_backend_intermediate_cert_request.csr-request.csr
}
