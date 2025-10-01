terraform {
  required_version = "=1.12.2"

  required_providers {
    vault = {
        source  = "hashicorp/vault"
        version = "5.1.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.44.0"
    }
  }
}

# Auth Vault Provider (for retrieving Azure credentials)
provider "vault" {
  alias = "auth"
  address = var.auth_vault_address
  skip_child_token = true
  # Authenticate using AppRole and the retrieved role_id and secret_id
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = var.auth_vault_role_id
      secret_id = var.auth_vault_secret_id
    }
  }
}

#  Vault Provider (for PKI operations)
provider "vault" {
  #alias = "pki"
  address = var.vault_address
  token = var.pki_root_token # Temporary token for testing; replace with AppRole auth below
  skip_child_token = true
  # Authenticate using AppRole and the retrieved role_id and secret_id
  # auth_login {
  #   path = "auth/approle/login"

  #   parameters = {
  #     role_id   = var.pki_vault_role_id
  #     secret_id = var.pki_vault_secret_id
  #   }
  # }
}

# Configure the AzureRM Provider
provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
  client_id       = local.client_id
  client_secret   = local.client_secret
  tenant_id       = local.tenant_id
}