variable "vault_addr" {
  type    = string
  default = "https://PROD-RootCA.naizoyden.net:8200"
}

variable "vault_root_token" {
    description = "Vault Root Token"
    type        = string
    sensitive   = true
}