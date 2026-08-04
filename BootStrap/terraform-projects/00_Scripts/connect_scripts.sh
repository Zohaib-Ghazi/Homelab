# Remove old entries for the servers from known_hosts to avoid SSH key conflicts

ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.101"
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.102"
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.103"
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.104"

# Connect 
#ssh -i ~/.ssh/ansible s_admin@10.0.0.101 "vault operator unseal $(jq -r '.unseal_keys_b64[0]' /opt/vault/unseal/vault_init.json)"
ssh -i ~/.ssh/ansible s_admin@10.0.0.101 "vault operator unseal 36GyGb2DLu2ElEbwjJhyFnv/VuAiKVpA/ehmjMKiGDc="
ssh -i ~/.ssh/ansible s_admin@10.0.0.103 "vault operator unseal HRmkmZawtxQ9RzsUO3bp6zRtzYEmNBZVTSZHe/BBkwM="
ssh -i ~/.ssh/ansible s_admin@10.0.0.102 "vault operator unseal 36GyGb2DLu2ElEbwjJhyFnv/VuAiKVpA/ehmjMKiGDc="
