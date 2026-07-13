# # ---------------------------------
# # Issue a cert "the terraform way"
# # ---------------------------------

# # here we make a request for a "real" cert
# resource "vault_pki_secret_backend_cert" "test-cert" {
#     provider = vault.pki
#     # target the issuer
#     issuer_ref  = vault_pki_secret_backend_issuer.intermediate_issuer.issuer_ref
#     # using the issuing backend
#     backend     = vault_pki_secret_backend_role.IntCA_role.backend
#     # and the issuing role
#     name        = vault_pki_secret_backend_role.IntCA_role.name
#     # for a common name in our scope
#     common_name = "PROD-IntermediateCA.naizoyden.net"
#     ip_sans = ["10.0.0.103"]

#     # with a 1d ttl
#     ttl         = 86400 # 1 day
#     # to be used later to revoke it as no longer valid 
#     #revoke     = true
# }

# output "test-certificate-output" {
#  value = vault_pki_secret_backend_cert.test-cert
#  sensitive = true
# }

# output "test-serial_number" {
#  value = vault_pki_secret_backend_cert.test-cert.serial_number
# }
