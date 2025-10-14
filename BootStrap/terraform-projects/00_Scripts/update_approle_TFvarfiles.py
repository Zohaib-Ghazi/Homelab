import os

# Paths
role_id_path = "../output/TF_SPN_role_id.txt"
secret_id_path = "../output/TF_SPN_secret_id.txt"
tfvars_paths = [
    "../02_Vault_PKI_RootCA_AuthControl/credentials.auto.tfvars",
    "../02_Vault_PKI_RootCA_Infra/credentials.auto.tfvars",
    "../02_Vault_PKI_RootCA_PKI/credentials.auto.tfvars",
    "../03_Vault_PKI_IntermediateCA_AuthControl/credentials.auto.tfvars",
    "../03_Vault_PKI_IntermediateCA_Infra/credentials.auto.tfvars",
    "../03_Vault_PKI_IntermediateCA_PKI/credentials.auto.tfvars",
    "../04_CICD_Jenkins_Infra/credentials.auto.tfvars",
]

# Read new role_id from file
with open(role_id_path) as f:
    new_role_id = f.read().strip().strip('"')

# Read new secret_id from file
with open(secret_id_path) as f:
    new_secret_id = f.read().strip().strip('"')

# Update each tfvars file
for tfvars_path in tfvars_paths:
    if not os.path.isfile(tfvars_path):
        print(f"Warning: {tfvars_path} does not exist, skipping.")
        continue

    with open(tfvars_path, "r") as f:
        lines = f.readlines()

    with open(tfvars_path, "w") as f:
        for line in lines:
            if line.strip().startswith("vault_role_id"):
                f.write(f'vault_role_id = "{new_role_id}"\n')
            elif line.strip().startswith("vault_secret_id"):
                f.write(f'vault_secret_id = "{new_secret_id}"\n')
            else:
                f.write(line)