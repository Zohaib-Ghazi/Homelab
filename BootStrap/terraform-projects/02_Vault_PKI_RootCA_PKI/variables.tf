# variable "vault_root_token" {
#     description = "Vault Root Token"
#     type        = string
#     sensitive   = true
# }

variable "domain_name" {
    description = "Domain name for the server certificate"
    type        = string
    default     = "naizoyden.net"
}

variable "issuer_name" {
    description = "Issuer name for the Root CA"
    type        = string
    default     = "Naizoyden-RootCA"
}

variable "client_cert_domain" {
    description = "Domain name for the client certificate"
    type        = string
    default     = "naizoyden.com"
}

variable "pki_root_token" {
    description = "PKI Root Token"
    type        = string
    sensitive   = true
}

variable "vault_address" {
  type    = string
  sensitive = true
}

variable "pki_vault_address" {
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

variable "pki_vault_role_id" {
  description = "Auth Vault AppRole Role ID"
  type        = string
  sensitive   = true
}

variable "pki_vault_secret_id" {
  description = "Auth Vault AppRole Secret ID"
  type        = string
  sensitive   = true
}
