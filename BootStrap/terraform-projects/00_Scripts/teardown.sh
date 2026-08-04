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

# echo "Tearing down Terraform-managed infrastructure..."
# cd $src_jenkins_infra_path
# terraform init
# terraform destroy -auto-approve
# echo "Teardown complete."

# echo
# echo

# Delete IntCACSR.tf file from RootCA PKI directory
rm "${src_vault_rootca_pki_path}/IntCACSR.tf"
echo "Deleted IntCACSR.tf file from RootCA PKI directory"
echo

# Delete postscript.tf file from IntCA PKI directory
rm "${src_vault_intca_pki_path}/postscript_IntCA1.tf"
echo "Deleted postscript_IntCA1.tf file from IntCA PKI directory"
echo

# Delete postscript.tf file from IntCA PKI directory
rm "${src_vault_intca_pki_path}/postscript_IntCA2.tf"
echo "Deleted postscript_IntCA2.tf file from IntCA PKI directory"
echo

echo "Tearing down IntCA PKI "
cd $src_vault_intca_pki_path
terraform init
terraform destroy -auto-approve
echo "Teardown of IntCA PKI complete."

echo
echo

echo "Tearing down RootCA PKI"
cd $src_vault_rootca_pki_path
terraform init
terraform destroy -auto-approve
echo "Teardown of RootCA PKI complete."

echo
echo

echo "Tearing down IntCA Auth"
cd $src_vault_intca_auth_path
terraform init
terraform destroy -auto-approve

echo "Teardown of IntCA Auth complete."

echo
echo

echo "Tearing down IntCA Infra infrastructure"
cd $src_vault_intca_infra_path
terraform init
terraform destroy -auto-approve

echo "Teardown of IntCA Infra infrastructure complete."

echo
echo

echo "Tearing down RootCA Auth"

cd $src_vault_rootca_auth_path
terraform init
terraform destroy -auto-approve

echo "Teardown of RootCA Auth complete."

echo
echo

echo "Tearing down RootCA Infra infrastructure"

cd $src_vault_rootca_infra_path
terraform init
terraform destroy -auto-approve

echo "Teardown of RootCA Infra infrastructure complete."

echo
echo

echo "Tearing down TFBE Auth"

cd $src_vault_tfbe_auth_path
terraform init
terraform destroy -auto-approve

echo "Teardown of TFBE Auth complete."

echo
echo

echo "Tearing down TFBE Infra infrastructure"

cd $src_vault_tfbe_infra_path
terraform init
terraform destroy -auto-approve

echo "Teardown of TFBE Infra infrastructure complete."

echo
echo

echo "Tearing down Azure Cloud Storage Account"

cd $src_azure_remotestorage_path
terraform destroy -auto-approve

echo "Teardown of Azure Cloud Storage Account complete."

echo
echo

exit 0