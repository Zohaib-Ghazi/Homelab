# Remove old entries for the servers from known_hosts to avoid SSH key conflicts

ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.101"
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.102"
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.103"
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.104"

# Connect 
#ssh -i ~/.ssh/ansible s_admin@10.0.0.101 "vault operator unseal $(jq -r '.unseal_keys_b64[0]' /opt/vault/unseal/vault_init.json)"
ssh -i ~/.ssh/ansible s_admin@10.0.0.101 "vault operator unseal UoYYQpcxjn++oCMOUgb5eetqTJp5G87S9UG6FOM46Fk="
ssh -i ~/.ssh/ansible s_admin@10.0.0.102 "vault operator unseal rWKt8pwMelT7Iydt8lQd5gf6pSuF2Lj8ArSfylKZZU0="
ssh -i ~/.ssh/ansible s_admin@10.0.0.103 "vault operator unseal bzf0NF9zx040h0aJxqeSEjezAf4jvciUcorCmBFX90U="
