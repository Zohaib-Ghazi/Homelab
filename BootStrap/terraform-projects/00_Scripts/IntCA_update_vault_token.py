import re
import os
import json

# Paths
json_path = "../output/vault_intca.json"
tfvars_paths = [
    "../03_Vault_PKI_IntermediateCA_AuthControl/credentials.auto.tfvars",
    "../03_Vault_PKI_IntermediateCA_PKI/credentials.auto.tfvars"
]

# Read new token from JSON
with open(json_path) as f:
    data = json.load(f)
new_token = data["root_token"]

for tfvars_path in tfvars_paths:
    if not os.path.isfile(tfvars_path):
        print(f"Warning: {tfvars_path} does not exist, skipping.")
        continue
    
    # Read and update tfvars file
    with open(tfvars_path, "r") as f:
        lines = f.readlines()

    with open(tfvars_path, "w") as f:
        for line in lines:
            if line.strip().startswith("pki_root_token"):
                f.write(f'pki_root_token = "{new_token}"\n')
            else:
                f.write(line)