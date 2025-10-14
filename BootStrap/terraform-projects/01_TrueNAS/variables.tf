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

variable "inventory_path" {
    description = "Ansible inventory path of the current project"
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

variable "vm_name_suffix" {
    description = "VM Name Suffix"
    type = string
<<<<<<<< HEAD:BootStrap/terraform-projects/01_TrueNAS/variables.tf
    default = "TrueNAS"
}

variable "vm_template" {
    description = "VM Template"
    type = string
    default = "TrueNAS-Template-OVMF"
}

variable "vm_bios" {
    description = "VM BIOS Type"
    type = string
    default = "seabios"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
========
    default = "TFBE"
}

# variable "subscription_id" {}
# variable "client_id" {}
# variable "client_secret" {}
# variable "tenant_id" {}


variable "vault_address" {
  type    = string
  sensitive = true
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
>>>>>>>> 5ca188b (Introduced Docker & Jenkins into baseline setup):BootStrap/terraform-projects/04_CICD_Docker_Infra/variables.tf
