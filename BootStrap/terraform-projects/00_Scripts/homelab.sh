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
src_jenkins_infra_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/04_CICD_Jenkins_Infra"
output_path_vault="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/"

# echo "Starting Terraform deployment for Azure Remote Storage Infrastructure"
# cd $src_azure_remotestorage_path
# terraform init
# terraform apply -auto-approve
# echo "Completed deployment for Azure Remote Storage Infrastructure"

# echo
# echo

# echo "Starting Terraform deployment for Vault TFBE Infrastructure"
# # Navigate to TFBE infra directory, initialize Terraform, and apply the configuration
# cd $src_vault_tfbe_infra_path 
# terraform init
# terraform apply -auto-approve
# echo "Completed Terraform deployment for Vault TFBE Infrastructure"
# echo
# echo

# #Call the script to retrieve vault keys
# echo "Retrieving remote vault keys"
# #cd $src_scripts_dir
# #./Retrieve-vaultkeys.sh "/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_tfbe.json" "10.0.0.101" "s_admin"
# echo "Step 1: Removing old entries from known_hosts file for '10.0.0.101"
# sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "10.0.0.101"
# echo "Step 2: Retrieving vault keys from host"
# sudo scp -i ~/.ssh/ansible "s_admin@10.0.0.101:/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_tfbe.json"
# echo
# echo "TFBE vault keys copied to local host"

# echo
# echo

# # Update vault root token in credentials.auto.tfvars file
# echo "Updating TFBE vault root token in credentials.auto.tfvars file"
# cd $src_scripts_dir
# python3 TFBE_update_vault_token.py
# echo "Completed updating TFBE vault root token in credentials.auto.tfvars file"
# echo

# # Call the script to retrieve self-signed CA certs
# echo "Retrieving remote root certificate"
# cd $src_scripts_dir
# ./Retrieve-Cert.sh "/usr/local/share/ca-certificates/vault-cert.crt" "/usr/local/share/ca-certificates/TFBE.crt" "10.0.0.101" "s_admin"
# echo
# echo "TFBE cert retrieved and successfully applied to local host"

# echo
# echo

# echo "Starting Terraform deployment for Vault TFBE Auth Control"
# # Navigate to TFBE Auth Control directory, initialize Terraform, and apply the configuration
# cd $src_vault_tfbe_auth_path
# terraform init
# terraform apply -auto-approve
# echo "Completed Terraform deployment for Vault TFBE Auth Control"

# echo
# echo

# # retrieve vault output values for TF_SPN_role_id and TF_SPN_secret_id and save to local files
# echo "Retrieving TF_SPN Role ID & Secret ID from Vault TFBE Auth Control"
# cd $src_vault_tfbe_auth_path
# terraform output TF_SPN_role_id > "${output_path_vault}TF_SPN_role_id.txt"
# terraform output TF_SPN_secret_id > "${output_path_vault}TF_SPN_secret_id.txt"
# echo
# echo "TFBE SPN creds copied to local host"

# echo
# echo

# echo "Updating TF_SPN Role ID & Secret ID across terraform tfvars files:RootCA, IntCA & Jenkins"
# cd $src_scripts_dir
# python3 update_approle_TFvarfiles.py
# echo "Completed updating TF_SPN Role ID & Secret ID creds in terraform tfvars files"


# echo "Starting Terraform deployment for Vault PKI RootCA Infrastructure"
# # Navigate to RootCA infra directory, initialize Terraform, and apply the configuration
# cd $src_vault_rootca_infra_path
# terraform init
# terraform apply -auto-approve
# echo "Completed Terraform deployment for Vault PKI RootCA Infrastructure"

# echo
# echo

# #Call the script to retrieve vault keys
# echo "Retrieving remote vault keys"
# #cd $src_scripts_dir
# #./Retrieve-vaultkeys.sh "/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_rootca.json" "10.0.0.102" "s_admin"
# echo "Step 1: Removing old entries from known_hosts file for '10.0.0.102'"
# sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "10.0.0.102"
# echo "Step 2: Retrieving vault keys from host"
# sudo scp -i ~/.ssh/ansible "s_admin@10.0.0.102:/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_rootca.json"
# echo
# echo "RootCA vault keys copied to local host"


# # Update vault root token in credentials.auto.tfvars file
# echo "Updating RootCA vault root token in credentials.auto.tfvars file"
# cd $src_scripts_dir
# python3 RootCA_update_vault_token.py
# echo "Completed updating RootCA vault root token in credentials.auto.tfvars file"
# echo

# # Call the script to retrieve self-signed CA certs
# echo "Retrieving remote root certificate"
# cd $src_scripts_dir
# ./Retrieve-Cert.sh "/usr/local/share/ca-certificates/vault-cert.crt" "/usr/local/share/ca-certificates/RootCA.crt" "10.0.0.102" "s_admin"
# echo
# echo "Root CA cert retrieved and successfully applied to local host"

# echo
# echo


 
# echo "Starting Terraform deployment for RootCA Auth Control"
# cd $src_vault_rootca_auth_path
# terraform init
# terraform apply -auto-approve
# echo "Completed Terraform deployment for RootCA Auth Control"

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

#Call the script to retrieve vault keys
echo "Retrieving remote vault keys"
#cd $src_scripts_dir
#./Retrieve-vaultkeys.sh "/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_tfbe.json" "10.0.0.101" "s_admin"
echo "Step 1: Removing old entries from known_hosts file for '10.0.0.103'"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "10.0.0.103"
echo "Step 2: Retrieving vault keys from host"
sudo scp -i ~/.ssh/ansible "s_admin@10.0.0.103:/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_intca.json"
echo
echo "IntCA vault keys copied to local host"


# Update vault root token in credentials.auto.tfvars file
echo "Updating IntCA vault root token in credentials.auto.tfvars file"
cd $src_scripts_dir
python3 IntCA_update_vault_token.py
echo "Completed updating IntCA vault root token in credentials.auto.tfvars file"
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


# Copy IntCACSR.tf file from scripts directory to RootCA PKI directory
cp "${src_scripts_dir}/IntCACSR.tf" "${src_vault_rootca_pki_path}/IntCACSR.tf"
echo "Copied IntCACSR.tf file to RootCA PKI directory"
echo

# Run terraform apply again in RootCA PKI directory to sign IntCA CSR
cd $src_vault_rootca_pki_path
terraform apply -auto-approve
echo "Signed IntCA CSR in RootCA PKI directory"
echo

# Copy postscript.tf file from scripts directory to IntCA PKI directory
cp "${src_scripts_dir}/postscript_IntCA1.tf" "${src_vault_intca_pki_path}/postscript_IntCA1.tf"
echo "Copied postscript_IntCA1.tf file to IntCA PKI directory"
echo

# Run terraform apply again in IntCA PKI directory to import the signed IntCA certificate
cd $src_vault_intca_pki_path
terraform apply -auto-approve
echo "Imported signed IntCA certificate"
echo

# Copy postscript_IntCA.tf file from scripts directory to IntCA PKI directory
cp "${src_scripts_dir}/postscript_IntCA2.tf" "${src_vault_intca_pki_path}/postscript_IntCA2.tf"
echo "Copied postscript_IntCA2.tf file to IntCA PKI directory"
echo

# Run terraform apply again in IntCA PKI directory to sign IntCA CSR and complete IntCA setup
cd $src_vault_intca_pki_path
terraform apply -auto-approve
echo "Configuring CA &* CRL distribution points, OCSP responder, and other post-configuration steps, including ACME DNS challenge setup for domain validation"
echo
echo
echo

echo "All Terraform deployments and configurations completed"

# echo "Starting Terraform deployment for Docker Infrastructure & Application"
# cd $src_jenkins_infra_pathasdfasd
# terraform init
# terraform apply -auto-approve
# echo "Completed deployment for Docker Infrastructure & Application"

# echo
# echo

# --- IGNORE ---





