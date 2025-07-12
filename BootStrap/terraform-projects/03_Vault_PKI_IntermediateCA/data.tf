data "terraform_remote_state" "RootCA_VM" {
  backend = "local"
  config = {
    path = "../02_Vault_PKI_RootCA/terraform.tfstate"
  }
}