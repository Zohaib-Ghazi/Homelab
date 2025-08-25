# Import the signed intermediate CA certificate into the PKI secrets engine
data "terraform_remote_state" "RootCA_TF" {
  backend = "local"

  config = {
    path = "../02_Vault_PKI_RootCA_PKI/terraform.tfstate"
  }
}