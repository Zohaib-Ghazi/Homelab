api_addr                = "https://PROD-RootCA.naizoyden.net:8200" #insecure until PKI has been deployed and certs generated/applied
#api_addr                = "https://vault.domain.net:8200" #DNS name for the cluster - incomplete #TODO
cluster_addr            = "https://PROD-RootCA.naizoyden.net:8201"
cluster_name            = "vault-cluster"
max_lease_ttl          = "24h" # Default max lease TTL for all secrets
default_lease_ttl       = "1h" # Default lease TTL for all secrets
disable_mlock           = true # System call preventing memory from being swapped to disk. Set to false in production environments with sufficient memory.
disable_cache          = true 
ui                      = true # Disable the UI in production environments
log_level              = "debug" # Set to "info" or "warn" in production environments
log_file             = "/opt/vault/logs/vault.log" # Ensure this directory exists and is writable by the vault user

listener "tcp" {
address       = "0.0.0.0:8200"
#tls_disable   = "true" # Set to "true" for testing purposes only
tls_cert_file = "/usr/local/share/ca-certificates/vault-cert.crt"
tls_key_file  = "/opt/vault/tls/vault-key.pem"
tls_disable_client_certs = true # Set to "true" for trusted environments only, until mTLS can be implemented
}

backend "file" {
path    = "/opt/vault/data"
node_id = "vault-RootCA"
}