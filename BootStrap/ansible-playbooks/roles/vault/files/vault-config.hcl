api_addr                = "https://10.0.0.101:8200" #insecure until PKI has been deployed and certs generated/applied
cluster_addr            = "https://10.0.0.101:8201"
cluster_name            = "vault-cluster"
disable_mlock           = true
ui                      = true # Disable the UI in production environments

listener "tcp" {
address       = "0.0.0.0:8200"
#tls_disable   = "true" # Set to "true" for testing purposes only
tls_cert_file = "/opt/vault/tls/vault-cert.pem"
tls_key_file  = "/opt/vault/tls/vault-key.pem"
}

backend "raft" {
path    = "/opt/vault/data"
node_id = "vault-node1"
}