#Read the terraform state file of Int CA from Azure blob storage
data "terraform_remote_state" "IntCA_TF" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatesa0dev"
    container_name       = "azurecloud-tfstate"
    key                  = "intca_pki.tfstate"
  }
}

# Have Root CA sign the Intermediate CSR
resource "vault_pki_secret_backend_root_sign_intermediate" "signed_IntCACert" {
  provider   = vault.pki
  backend     = vault_mount.pki.path
  common_name = "${var.domain_name} Intermediate CA"
  csr         = data.terraform_remote_state.IntCA_TF.outputs.intermediate_csr
  #issuer_ref  = vault_pki_secret_backend_root_cert.root_2025.issuer_id #try setting to intca issuer id next
  format      = "pem_bundle"
  ou          = "Production"
  organization = "Homelab"
  ttl         = 15480000 # 180 days
}


# Save the signed Intermediate CA certificate to a file
resource "local_file" "signed_intermediate" {
# depends_on = [ data.terraform_remote_state.IntCA_TF ]
  #provider = vault.pki
  content  = vault_pki_secret_backend_root_sign_intermediate.signed_IntCACert.certificate
  filename = "Signed_IntCA_cert.pem"
  #file permissions = "0400"
}

# Save the signed Intermediate CA certificate to a file
resource "local_file" "signed_intermediate2" {
# depends_on = [ data.terraform_remote_state.IntCA_TF ]
    #provider = vault.pki
    content  = vault_pki_secret_backend_root_sign_intermediate.signed_IntCACert.certificate_bundle
    filename = "Signed_IntCA_cert_bundle.pem"
    #file permissions = "0400"
}

# Output the signed Intermediate CA certificate
output "signed_CSR" {
    #depends_on = [ data.terraform_remote_state.IntCA_TF ]
    value = vault_pki_secret_backend_root_sign_intermediate.signed_IntCACert.certificate
}