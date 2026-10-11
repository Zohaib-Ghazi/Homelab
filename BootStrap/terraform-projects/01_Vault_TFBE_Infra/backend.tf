# Remote backend with AzureRM
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatesa0dev"
    container_name       = "azurecloud-tfstate"
    key                  = "TFBE_infra.tfstate"
  }
}