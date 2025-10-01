variable "location" {
  description = "Azure region for HomeLab resources"
  default     = "canadacentral"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "storage_account_name" {
  description = "Storage Account name for Terraform state"
  default     = "tfstatesa0dev" # must be globally unique
}

variable "resource_group_name" {
  description = "Resource Group name for Terraform state"
  default     = "tfstate-rg"
}

variable "container_name" {
  description = "Storage Container name for Terraform state"
  default     = "azurecloud-tfstate"
}

variable "key_name" {
  description = "Key name for Terraform state file"
  default     = "terraform.tfstate"
}