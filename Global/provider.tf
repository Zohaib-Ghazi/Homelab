terraform {
  required_version = "1.9.8"

  required_providers {
    proxmox = {
        source = "telmate/proxmox"
        version = "3.0.1-rc4"
    }
  }
}

#Proxmox API Connectivity Info
provider "proxmox" {
    pm_api_url = var.proxmox_api_perf_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret

    #Insecure until PKI has been implemented and deployed to apps, services & infra
    pm_tls_insecure = true
}