# output "RootCA_vm_name" {
#   description = "VM name suffix"
#   value = module.Vault-IntermediateCA.vm_name_suffix
# }

# output "azurecreds" {
#   description = "Azure Credentials from Vault"
#   value = data.vault_kv_secret_v2.azure_creds.data_json
#   sensitive = true
# }

# output "vault_creds" {
#   description = "Vault Credentials from Vault"
#   value = data.vault_kv_secret_v2.vault_creds.data_json
#   sensitive = true
# }

# output "TF_SPN_creds" {
#   description = "TF Service Principal Credentials from Vault"
#   value = data.vault_kv_secret_v2.TF_SPN.data_json
#   sensitive = true
# }