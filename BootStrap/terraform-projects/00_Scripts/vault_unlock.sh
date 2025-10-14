# Script to unlock vault_TFBE, PKI_IntermediateCA servers after bootup
src_scripts_dir="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/00_Scripts"
src_vault_tfbe_infra_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/01_Vault_TFBE_Infra"
src_vault_intca_infra_path="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/03_Vault_PKI_IntermediateCA_Infra"
output_path_vault="/mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output/"

echo "Starting vault unlock process for TFBE server"
cd $src_vault_tfbe_infra_path
#Call the script to retrieve vault keys
echo "Retrieving remote vault keys"
cat $output_path_vault/vault_tfbe.json | jq -r '.unseal_keys_b64' 
#> output/$1/$1_cert.pem


cat /mnt/c/Users/Zohaib/HomeLab/Homelab/BootStrap/terraform-projects/output//vault_tfbe.json | jq -r '.unseal_keys_b64' 