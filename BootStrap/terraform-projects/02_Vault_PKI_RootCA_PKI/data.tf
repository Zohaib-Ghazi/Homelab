# Import csr request from intermediate CA PKI project
data "terraform_remote_state" "IntCA_TF" {
  backend = "local"

  config = {
    path = "../03_Vault_PKI_IntermediateCA_PKI/terraform.tfstate"
  }
}