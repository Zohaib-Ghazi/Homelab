# Configure the backend to store the Terraform state in Azure Blob Storage
terraform {
    backend "azurerm" {
        resource_group_name  = "tfstate-rg"
        storage_account_name = "tfstatesa0dev"
        container_name       = "azurecloud-tfstate"
        key                  = "rootca_pki.tfstate"
    }
}