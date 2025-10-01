# Configure the Terraform version and the required providers
terraform {
  required_version = "=1.12.2"

  required_providers {
    vault = {
        source  = "hashicorp/vault"
        version = "5.1.0"
    }
  }
}

# Configure the Vault Provider
provider "vault" {
  address = "${var.vault_address}"
  token = "${var.vault_root_token}"
  skip_child_token = true # to avoid "cannot re-use token" error

  # auth_login {
  #   path = "auth/approle/login"
  
  #   parameters = {
  #     role_id   = data.vault_approle_auth_backend_role_id.tfbe.role_id
  #     secret_id = vault_approle_auth_backend_role_secret_id.tfbe.secret_id
  #   }
  # }
}

# Configure the AzureRM Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}