terraform {
  required_version = "=1.12.2"

  required_providers {
    vault = {
        source  = "hashicorp/vault"
        version = "5.1.0"
    }
  }
}

# Primary Vault Provider (for retrieving Azure credentials)
provider "vault" {
  address = var.vault_address
  alias = "tfbe"
  skip_child_token = true
  # Authenticate using AppRole and the retrieved role_id and secret_id
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = var.vault_role_id
      secret_id = var.vault_secret_id
    }
  }
}