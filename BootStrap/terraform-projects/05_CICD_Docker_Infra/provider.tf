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
    
    proxmox = {
        source = "telmate/proxmox"
        version = "3.0.1-rc4"
    }
  }
}

# Primary Vault Provider (for retrieving Azure credentials)
provider "vault" {
  address = var.vault_address
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

# Configure the AzureRM Provider
provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
  client_id       = local.client_id
  client_secret   = local.client_secret
  tenant_id       = local.tenant_id
}

#Proxmox API Connectivity Info
#Argument List: https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md#argument-reference
provider "proxmox" {
    pm_api_url = var.proxmox_api_perf_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret

    #Insecure until PKI has been implemented and deployed to apps, services & infra
    pm_tls_insecure = true
    pm_timeout = 1200
}