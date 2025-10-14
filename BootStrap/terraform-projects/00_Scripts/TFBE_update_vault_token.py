import re
import json

# Paths
json_path = "../output/vault_tfbe.json"
tfvars_path = "../01_Vault_TFBE_Secrets_AuthControl/credentials.auto.tfvars"

# Read new token from JSON
with open(json_path) as f:
    data = json.load(f)
new_token = data["root_token"]

# Read and update tfvars file
with open(tfvars_path, "r") as f:
    lines = f.readlines()

with open(tfvars_path, "w") as f:
    for line in lines:
        if line.strip().startswith("vault_root_token"):
            f.write(f'vault_root_token = "{new_token}"\n')
        else:
            f.write(line)