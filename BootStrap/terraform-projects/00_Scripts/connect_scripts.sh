# Remove old entries for the servers from known_hosts to avoid SSH key conflicts

ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.101"
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.102"
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.103"
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.104"

# Connect 
#ssh -i ~/.ssh/ansible s_admin@10.0.0.101 "vault operator unseal $(jq -r '.unseal_keys_b64[0]' /opt/vault/unseal/vault_init.json)"

ssh -i ~/.ssh/ansible s_admin@10.0.0.101 "vault operator unseal kuhrOivJODNKD+9PLosWG66qiajbp85wt4u0UXb1Eao="
ssh tfbe "vault operator unseal C92rw2hZUlghHFFM4K61AIM4xgpeP3vw7RXmWJdtHEA="
ssh -i ~/.ssh/ansible s_admin@10.0.0.102 "vault operator unseal s+KjwflY4C//+WUVUr/1/XeENzoaF2ZPnO9hvF2gffY="
ssh rootca "vault operator unseal s+KjwflY4C//+WUVUr/1/XeENzoaF2ZPnO9hvF2gffY="
ssh -i ~/.ssh/ansible s_admin@10.0.0.103 "vault operator unseal IdITqCz6577GUzYMRJZPY5WkrqHUaNZySUQ4+1llng4="
ssh intca "vault operator unseal IdITqCz6577GUzYMRJZPY5WkrqHUaNZySUQ4+1llng4="
