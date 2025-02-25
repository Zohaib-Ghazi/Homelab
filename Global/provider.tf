terraform {
  required_version = ">1.9.8"

  required_providers {
    proxmox = {
        source = "telmate/proxmox"
        version = "3.0.1-rc4"
    }
  }
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