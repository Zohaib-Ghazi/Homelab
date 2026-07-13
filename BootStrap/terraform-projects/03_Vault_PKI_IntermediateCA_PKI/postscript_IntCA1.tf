#Read the terraform state file of Root CA from Azure blob storage
data "terraform_remote_state" "RootCA_TF" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatesa0dev"
    container_name       = "azurecloud-tfstate"
    key                  = "rootca_pki.tfstate"
  }
}

# Import the signed intermediate CA certificate into the PKI secrets engine
resource "vault_pki_secret_backend_intermediate_set_signed" "signed_intermediate" {
  depends_on = [ vault_mount.pki_int ]
  provider = vault.pki
  backend     = vault_mount.pki_int.path
  certificate = data.terraform_remote_state.RootCA_TF.outputs.signed_CSR_cert
}

#Importing the signed cert from the root CA into the intermediate PKI secrets engine as a trusted issuer
resource "vault_pki_secret_backend_issuer" "intermediate_issuer" {
  depends_on = [vault_pki_secret_backend_intermediate_set_signed.signed_intermediate]
  provider                        = vault.pki
  backend                        = vault_mount.pki_int.path
  issuer_ref                     = vault_pki_secret_backend_intermediate_set_signed.signed_intermediate.imported_issuers[0]
  issuer_name                    = "${var.issuer_name}" 
  revocation_signature_algorithm = "SHA256WithRSA"
}

# Create a role for issuing certificates by the Int CA
resource "vault_pki_secret_backend_role" "IntCA_role" {
  #depends_on = [ vault_pki_secret_backend_issuer.intermediate_issuer ]
  provider         = vault.pki
  backend          = vault_mount.pki_int.path
  issuer_ref = vault_pki_secret_backend_issuer.intermediate_issuer.issuer_ref
  
  #Name to be used to target this role when issuing certificates
  name             = "IntCA-Issuing-Role"
  ttl             = 86400 #1 day
  max_ttl         = 2592000 #30 days
  allow_ip_sans    = true #allow IP SANs in issued certificates
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains = ["naizoyden.net"] #restrict to specific domain(s)
  allow_subdomains = true
  allow_any_name   = true
  require_cn        = true #require common name in certificate requests. This addresses the error when ACME client requests a certificate without a common name, which is not allowed by the role configuration. By setting require_cn to true, we ensure that all certificate requests must include a common name, which is necessary for successful certificate issuance.
}
