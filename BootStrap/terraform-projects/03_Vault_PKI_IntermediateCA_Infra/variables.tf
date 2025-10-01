variable "proxmox_perf_host" {
    description = "Proxmox Performance Node Name"
    type = string
    default = "pve"
}

variable "proxmox_nas_host" {
    description = "Proxmox NAS Node Name"
    type = string
    default = "pve2"
}
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
    description = "Public DNS Server IPs"
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

variable "ansible_user" {
    description = "Ansible service account"
    type = string
}

variable "private_key_path" {
    description = "Private Key Path"
    type = string
    #should i add a sensitive=true here?
}

variable "public_key_path" {
    description = "Public Key Path"
    type = string
}

variable "directory" {
    description = "Current Working Directory for Terraform & Ansible"
    type = string
}

variable "ip_address" {
    description = "IP Address"
    type = string
    default = "99.99.99.99"
}

variable "ip_range_start" {
    description = "IP Range Start"
    type = string
    default = "10.0.0.101"
}

variable "ip_range_end" {
    description = "IP Range Start"
    type = string
    default = "10.0.0.200"
}

variable "subnet_mask" {
    description = "Subnet Mask"
    type = string
    default = "24"
}

variable "gateway" {
    description = "Gateway"
    type = string
    default = "10.0.0.1"
}

variable "ansible_vault_folderpath" {
    description = "Ansible Vault Folder Path"
    type = string
    default = "../../../ansible-playbooks/roles/vault_SubCA/files/"
}

variable "vault_address" {
    description = "Vault Server Address"
    type        = string
    
}

# variable "vault_root_token" {
#     description = "Vault Root Token"
#     type        = string
#     sensitive   = true
# }

variable "subscription_id" {
    description = "Azure Subscription ID"
    type = string
    default = ""
}

variable "client_id" {
    description = "Azure Client ID"
    type = string
    default = ""
}

variable "client_secret" {
    description = "Azure Client Secret"
    type = string
    default = ""
}

variable "tenant_id" {
    description = "Azure Tenant ID"
    type = string
    default = ""
}

variable "vault_role_id" {
  description = "Vault AppRole Role ID"
  type        = string
  sensitive   = true
}

variable "vault_secret_id" {
  description = "Vault AppRole Secret ID"
  type        = string
  sensitive   = true
}

variable "inventory_path" {
    description = "Ansible inventory path of the current project"
    type = string
}