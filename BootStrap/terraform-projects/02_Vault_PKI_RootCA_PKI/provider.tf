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
    address = "${var.vault_addr}"
    token = "${var.vault_root_token}"
}