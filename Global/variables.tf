variable "proxmox_api_perf_url" {
    description = "PVE1 Performance Node Host Machine API URL"
    type = string
}

variable "proxmox_api_stor_url" {
    description = "PVE2 Storage Node Host Machine API URL"
    type = string
}

variable "proxmox_api_token_id" {
    description = "PVE Datacenter API Token ID for Terraform User"
    type = string
    sensitive = true
}

variable "proxmox_api_token_secret" {
    description = "PVE Datacenter API Token Secret for Terraform User"
    type = string
    sensitive = true
}

variable "VM_DNS" {
    description = "DNS Server IP(s)"
    type = string
    default = "1.1.1.1 8.8.8.8"
}

variable "ciuser" {
    description = "Service Account - ciuser"
    type = string
    sensitive = true
}

variable "cipassword" {
    description = "Service Account Password - ciuser"
    type = string
    sensitive = true
}

variable "sshkeys" {
    description = "Service Account Password - ciuser"
    type = string
    sensitive = true
}