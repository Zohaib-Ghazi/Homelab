variable "vault_address" {
    description = "Vault Server Address"
    type        = string
    
}

variable "vault_root_token" {
    description = "Vault Root Token"
    type        = string
    sensitive   = true
}

variable "admin_name" {
    description = "Vault Admin Username"
    type        = string
    sensitive   = true
}

variable "admin_password" {
    description = "Vault Admin Password"
    type        = string
    sensitive   = true
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}