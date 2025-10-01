#!/bin/bash
set -e

# Define paths to the Terraform project directories
src_scripts_dir="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/00_Scripts"
src_vault_rootca_infra_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/02_Vault_PKI_RootCA_Infra"
src_vault_intca_infra_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/03_Vault_PKI_IntermediateCA_Infra"
src_vault_rootca_pki_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/02_Vault_PKI_RootCA_PKI"
src_vault_intca_pki_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/03_Vault_PKI_IntermediateCA_PKI"
src_vault_rootca_auth_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/02_Vault_PKI_RootCA_AuthControl"
src_vault_intca_auth_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/03_Vault_PKI_IntermediateCA_AuthControl"
src_vault_tfbe_infra_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/01_Vault_TFBE_Infra"
src_vault_tfbe_auth_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/01_Vault_TFBE_Secrets_AuthControl"
src_azure_remotestorage_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/01_AzureCloud_StorageAccount"

echo "Tearing down Terraform-managed infrastructure..."

cd $src_vault_intca_auth_path
terraform init
terraform destroy -auto-approve

echo "Teardown complete."

echo
echo

echo "Tearing down Terraform-managed infrastructure..."

cd $src_vault_intca_infra_path
terraform init
terraform destroy -auto-approve

echo "Teardown complete."

echo
echo

echo "Tearing down Terraform-managed infrastructure..."

cd $src_vault_rootca_auth_path
terraform init
terraform destroy -auto-approve

echo "Teardown complete."

echo
echo

echo "Tearing down Terraform-managed infrastructure..."

cd $src_vault_rootca_infra_path
terraform init
terraform destroy -auto-approve

echo "Teardown complete."

echo
echo

echo "Tearing down Terraform-managed infrastructure..."

cd $src_vault_tfbe_auth_path
terraform init
terraform destroy -auto-approve

echo "Teardown complete."

echo
echo

echo "Tearing down Terraform-managed infrastructure..."

cd $src_vault_tfbe_infra_path
terraform init
terraform destroy -auto-approve

echo "Teardown complete."

echo
echo

echo "Tearing down Terraform-managed infrastructure..."

cd $src_azure_remotestorage_path
terraform destroy -auto-approve

echo "Teardown complete."

echo
echo

exit 0