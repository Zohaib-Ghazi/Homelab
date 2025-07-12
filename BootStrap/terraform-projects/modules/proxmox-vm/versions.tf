terraform {
  required_version = "=1.10.5"

  required_providers {
    proxmox = {
        source = "telmate/proxmox"
        version = "3.0.1-rc4"
    }
  }
}