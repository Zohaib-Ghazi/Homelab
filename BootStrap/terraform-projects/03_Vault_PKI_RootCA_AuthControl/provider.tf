terraform {
  required_version = "=1.12.2"

  required_providers {
    vault = {
        source  = "hashicorp/vault"
        version = "5.1.0"
    }
  }
}

provider "vault" {
    address = "https://PROD-RootCA.naizoyden.net:8200"
    token = "${var.vault_root_token}"
}