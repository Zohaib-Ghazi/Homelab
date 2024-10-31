variable "proxmox_api_url" {
    description = "PVE (Node 1) Host Machine API URL"
    type = string
}

variable "proxmox_api_token_id" {
    description = "PVE (Node 1) API Token ID"
    type = string
    sensitive = true
}

variable "proxmox_api_token_secret" {
    description = "PVE (Node 1) API Token Secret"
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