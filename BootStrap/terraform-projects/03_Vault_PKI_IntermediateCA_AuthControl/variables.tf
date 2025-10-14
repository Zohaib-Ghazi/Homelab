# variable "vault_root_token" {
#     description = "Vault Root Token"
#     type        = string
#     sensitive   = true
# }

variable "server_cert_domain" {
    description = "Domain name for the server certificate"
    type        = string
    default     = "naizoyden.net"
}

variable "client_cert_domain" {
    description = "Domain name for the client certificate"
    type        = string
    default     = "naizoyden.com"
}

variable "vault_address" {
  type    = string
  sensitive = true
}

variable "pki_int_vault_address" {
  type    = string
  sensitive = true
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

variable "pki_vault_role_id" {
  description = "PKI Vault AppRole Role ID"
  type        = string
  sensitive   = true
}

variable "pki_vault_secret_id" {
  description = "PKI Vault AppRole Secret ID"
  type        = string
  sensitive   = true
}

variable "pki_root_token" {
    description = "PKI Root Token"
    type        = string
    sensitive   = true
}