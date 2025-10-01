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

echo "Starting Terraform deployment for Azure Remote Storage Infrastructure"
cd $src_azure_remotestorage_path
terraform init
terraform apply -auto-approve
echo "Completed deployment for Azure Remote Storage Infrastructure"

echo
echo

echo "Starting Terraform deployment for Vault TFBE Infrastructure"
# Navigate to TFBE infra directory, initialize Terraform, and apply the configuration
cd $src_vault_tfbe_infra_path
terraform init
terraform apply -auto-approve
echo "Completed Terraform deployment for Vault TFBE Infrastructure"

echo
echo

# Call the script to retrieve self-signed CA certs
echo "Retrieving remote root certificate"
cd $src_scripts_dir
./Retrieve-Cert.sh "/usr/local/share/ca-certificates/vault-cert.crt" "/usr/local/share/ca-certificates/TFBE.crt" "10.0.0.101" "s_admin"
echo
echo "TFBE cert retrieved and successfully applied to local host"

echo
echo

echo "Starting Terraform deployment for Vault TFBE Auth Control"
# Navigate to TFBE Auth Control directory, initialize Terraform, and apply the configuration
cd $src_vault_tfbe_auth_path
terraform init
terraform apply -auto-approve
echo "Completed Terraform deployment for Vault TFBE Auth Control"

echo
echo


echo "Starting Terraform deployment for Vault PKI RootCA Infrastructure"
# Navigate to RootCA infra directory, initialize Terraform, and apply the configuration
cd $src_vault_rootca_infra_path
terraform init
terraform apply -auto-approve
echo "Completed Terraform deployment for Vault PKI RootCA Infrastructure"

echo
echo

# Call the script to retrieve self-signed CA certs
echo "Retrieving remote root certificate"
cd $src_scripts_dir
./Retrieve-Cert.sh "/usr/local/share/ca-certificates/vault-cert.crt" "/usr/local/share/ca-certificates/RootCA.crt" "10.0.0.102" "s_admin"
echo
echo "Root CA cert retrieved and successfully applied to local host"

echo
echo

echo "Starting Terraform deployment for RootCA Auth Control"
cd $src_vault_rootca_auth_path
terraform init
terraform apply -auto-approve
echo "Completed Terraform deployment for RootCA Auth Control"

echo
echo

echo "Starting Terraform deployment for Vault PKI IntCA Infrastructure"
# Navigate to IntCA infra directory, initialize Terraform, and apply the configuration
cd $src_vault_intca_infra_path
terraform init
terraform apply -auto-approve
echo "Completed Terraform deployment for Vault PKI IntCA Infrastructure"

echo
echo

# Call the script to retrieve self-signed CA certs
echo "Retrieving remote root certificate"
cd $src_scripts_dir
./Retrieve-Cert.sh "/usr/local/share/ca-certificates/vault-cert.crt" "/usr/local/share/ca-certificates/IntCA.crt" "10.0.0.103" "s_admin"
echo
echo "Int CA cert retrieved and successfully applied to local host"

echo
echo

echo "Starting Terraform deployment for IntCA Auth Control"
cd $src_vault_intca_auth_path
terraform init
terraform apply -auto-approve
echo "Completed Terraform deployment for IntCA Auth Control"

echo
echo

echo "Starting Terraform deployment for Vault PKI RootCA"
#Navigate to RootCA PKI directory, initialize Terraform, and apply the configuration
cd $src_vault_rootca_pki_path
terraform init
terraform apply -auto-approve
echo "Completed Terraform deployment for Vault PKI RootCA"

echo "Starting Terraform deployment for Vault PKI IntCA"
#Navigate to IntCA PKI directory, initialize Terraform, and apply the configuration
cd $src_vault_intca_pki_path
terraform init
terraform apply -auto-approve
echo "Completed Terraform deployment for Vault PKI IntCA"