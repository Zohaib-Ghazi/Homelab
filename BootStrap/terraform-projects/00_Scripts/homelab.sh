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
src_bootstrap_certificates_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/04_BootStrap_Certificates"
output_path_vault="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/"

# echo "Starting Terraform deployment for Azure Remote Storage Infrastructure"
# cd $src_azure_remotestorage_path
# terraform init
# terraform apply -auto-approve
# echo "Completed deployment for Azure Remote Storage Infrastructure"

# echo
# echo

echo "Starting Terraform deployment for Vault TFBE Infrastructure"
# Navigate to TFBE infra directory, initialize Terraform, and apply the configuration
cd $src_vault_tfbe_infra_path 
terraform init
terraform apply -auto-approve
echo "Completed Terraform deployment for Vault TFBE Infrastructure"
echo
echo

#Call the script to retrieve vault keys
echo "Retrieving TFBE vault unseal keys"
#cd $src_scripts_dir
#./Retrieve-vaultkeys.sh "/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_tfbe.json" "10.0.0.101" "s_admin"
echo "Step 1: Removing old entries from known_hosts file for '10.0.0.101"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "10.0.0.101"
echo "Step 2: Retrieving TFBE vault unseal keys from host"
sudo scp -i ~/.ssh/ansible "s_admin@10.0.0.101:/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_tfbe.json"
echo
echo "TFBE vault keys copied to local host"

echo
echo

# Update vault root token in credentials.auto.tfvars file
echo "Updating TFBE vault root token in credentials.auto.tfvars file"
cd $src_scripts_dir
python3 TFBE_update_vault_token.py
echo "Completed updating TFBE vault root token in credentials.auto.tfvars file"
echo

# Call the script to retrieve self-signed CA certs
echo "Retrieving remote root certificate"
cd $src_scripts_dir
./Retrieve-Cert.sh "/usr/local/share/ca-certificates/vault-cert.crt" "/usr/local/share/ca-certificates/HomeLab_TFBE_RootCA.crt" "10.0.0.101" "s_admin"
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

# retrieve vault output values for TFBE_AppRoleID and TFBE_AppRole_SecretID and save to local files
echo "Retrieving TFBE_AppRole_ID & TFBE_AppRole_SecretID from Vault TFBE Auth Control"
cd $src_vault_tfbe_auth_path
terraform output TFBE_AppRoleID > "${output_path_vault}TFBE_AppRole_ID.txt"
terraform output TFBE_AppSecretID > "${output_path_vault}TFBE_AppRole_SecretID.txt"
echo
echo "Copied TF AppRole creds"

echo
echo

echo "Updating TFBE_AppRoleID & TFBE_AppRole_SecretID across terraform tfvars files: RootCA & IntCA infrastructure"
cd $src_scripts_dir
python3 update_approle_TFvarfiles.py
echo "Completed updating TFBE_AppRoleID & TFBE_AppRole_SecretID creds in terraform tfvars files"


echo "Starting Terraform deployment for Vault RootCA Infrastructure"
# Navigate to RootCA infra directory, initialize Terraform, and apply the configuration
cd $src_vault_rootca_infra_path
terraform init
terraform apply -auto-approve
echo "Completed Terraform deployment for Vault RootCA Infrastructure"

echo
echo

#Call the script to retrieve vault keys
echo "Retrieving RootCA vault unseal keys"
#cd $src_scripts_dir
#./Retrieve-vaultkeys.sh "/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_rootca.json" "10.0.0.102" "s_admin"
echo "Step 1: Removing old entries from known_hosts file for '10.0.0.102'"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "10.0.0.102"
echo "Step 2: Retrieving RootCA vault unseal keys from host"
sudo scp -i ~/.ssh/ansible "s_admin@10.0.0.102:/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_rootca.json"
echo
echo "RootCA vault keys copied to local host"


# Update vault root token in credentials.auto.tfvars file
echo "Updating RootCA vault root token in credentials.auto.tfvars file"
cd $src_scripts_dir
python3 RootCA_update_vault_token.py
echo "Completed updating RootCA vault root token in credentials.auto.tfvars file"
echo

# Call the script to retrieve self-signed CA certs
echo "Retrieving remote root certificate"
cd $src_scripts_dir
./Retrieve-Cert.sh "/usr/local/share/ca-certificates/vault-cert.crt" "/usr/local/share/ca-certificates/HomeLab_RootCA_RootCA.crt" "10.0.0.102" "s_admin"
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

#Call the script to retrieve vault keys
echo "Retrieving Vault PKI vault unseal keys"
#cd $src_scripts_dir
#./Retrieve-vaultkeys.sh "/opt/vault/unseal/vault_init.json" "/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/vault_tfbe.json" "10.0.0.101" "s_admin"

echo "Step 1: Removing old entries from known_hosts file for '10.0.0.103'"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "10.0.0.103"

echo "Step 2: Retrieving Vault PKI vault unseal keys from host"
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
echo "Retrieving Vault PKI IntCA root certificate"
cd $src_scripts_dir
./Retrieve-Cert.sh "/usr/local/share/ca-certificates/vault-cert.crt" "/usr/local/share/ca-certificates/HomeLab_IntCA_RootCA.crt" "10.0.0.103" "s_admin"
echo
echo "Vault PKI IntCA root certificate retrieved and successfully applied to local host"

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
terraform init
terraform apply -auto-approve
echo "Signed IntCA CSR in RootCA PKI directory"
echo

# Copy postscript.tf file from scripts directory to IntCA PKI directory
cp "${src_scripts_dir}/postscript_IntCA1.tf" "${src_vault_intca_pki_path}/postscript_IntCA1.tf"
echo "Copied postscript_IntCA1.tf file to IntCA PKI directory"
echo

# Run terraform apply again in IntCA PKI directory to import the signed IntCA certificate
cd $src_vault_intca_pki_path
terraform init
terraform apply -auto-approve
echo "Imported signed IntCA certificate"
echo

# Copy postscript_IntCA.tf file from scripts directory to IntCA PKI directory
cp "${src_scripts_dir}/postscript_IntCA2.tf" "${src_vault_intca_pki_path}/postscript_IntCA2.tf"
echo "Copied postscript_IntCA2.tf file to IntCA PKI directory"
echo

# Run terraform apply again in IntCA PKI directory to sign IntCA CSR and complete IntCA setup
cd $src_vault_intca_pki_path
terraform init
terraform apply -auto-approve
echo "Configured CA &* CRL distribution points, OCSP responder, and other post-configuration steps, including ACME DNS challenge setup for domain validation"
echo
echo
echo

# Run terraform apply in BootStrap Certificates directory to request certificates from Vault PKI IntCA
echo "Requesting certificates from Vault PKI IntCA using AppRole creds for BootStrap VMs"
cd $src_bootstrap_certificates_path
terraform init
terraform apply -auto-approve
echo "Completed certificate issuance to bootstrap VMs"
echo

# -- Future Plans Below -- 

echo "All Terraform deployments and configurations have been completed"

# echo "Starting Terraform deployment for Docker Infrastructure & Application"
# cd $src_jenkins_infra_pathasdfasd
# terraform init
# terraform apply -auto-approve
# echo "Completed deployment for Docker Infrastructure & Application"

# echo
# echo

# --- IGNORE ---





