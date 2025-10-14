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
  #depends_on = [ vault_mount.pki_int ]
  provider = vault.pki
  backend     = vault_mount.pki_int.path
  certificate = data.terraform_remote_state.RootCA_TF.outputs.signed_CSR
}

# Create a role for issuing certificates by the RootCA
resource "vault_pki_secret_backend_role" "IntCA_role" {
  #depends_on = [ vault_pki_secret_backend_issuer.intermediate_issuer ]
  provider         = vault.pki
  backend          = vault_mount.pki_int.path
  name             = "IntCA-Issuing-Role"
  ttl             = 3600
  allow_ip_sans    = true
  key_type         = "ed25519"
  key_bits         = 256
  allowed_domains = ["naizoyden.net"]
  allow_subdomains = true
  allow_any_name   = true
}

# #Manage the issuer role created for the Intermediate CA --- unclear purpose
# resource "vault_pki_secret_backend_issuer" "intermediate_issuer" {
#   provider                        = vault.pki
#   backend                        = vault_mount.pki_int.path
#   issuer_ref                     = vault_pki_secret_backend_intermediate_set_signed.signed_intermediate.id
#   issuer_name                    = "Naizoyden-IntermediateCA" 
#   revocation_signature_algorithm = "SHA256WithRSA"
# }