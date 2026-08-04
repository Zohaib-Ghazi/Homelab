variable "vm_name_suffix" {
    description = "VM Name Suffix"
    type = string
}

variable "ip_address" {
    description = "VM IP Address"
    type = string
    default = "10.0.0.101"
}

variable "ansible_user" {
    description = "Ansible service account"
    type = string
    #sensitive = true
}

variable "private_key_path" {
    description = "Private Key Path"
    type = string
    #should i add a sensitive=true here? #TODO: Check if this is required
}

variable "directory" {
    description = "Current Working Directory for Terraform & Ansible"
    type = string
}

variable "inventory_path" {
    description = "Ansible inventory path of the current project"
    type = string
}

# Certificate provisioning variables
variable "skip_certificate_provisioning" {
    description = "Whether to skip Vault certificate provisioning. Set to true to skip, false to request certificate."
    type = bool
    default = false
}

variable "vault_address" {
    description = "Vault server address for certificate provisioning (e.g., https://vault.homelab:8200)"
    type = string
    default = null
}

variable "vault_cert_role" {
    description = "Vault PKI role to use for certificate issuance (e.g., proxmox-host, infra-server)"
    type = string
    default = null
}

variable "vault_cert_san" {
    description = "Subject Alternative Names for the certificate (comma-separated)"
    type = string
    default = ""
}

variable "appRole_RoleID" {
    description = "Vault AppRole Role ID for certificate provisioning"
    type = string
    sensitive = true
    default = null
}

variable "appRole_SecretID" {
    description = "Vault AppRole Secret ID for certificate provisioning"
    type = string
    sensitive = true
    default = null
}