#!/bin/bash
# vault-cert-renew.sh
# Check certificate expiration and renew if needed (30 days before expiry)
# Usage: ./vault-cert-renew.sh <role-name> <cert-name> [san1,san2,...]
# This script is designed to be run via cron for automatic renewal

set -e

# Configuration
VAULT_ADDR="${VAULT_ADDR:?Error: VAULT_ADDR not set}"
APPROLE_ROLE_ID="${APPROLE_ROLE_ID:?Error: APPROLE_ROLE_ID not set}"
APPROLE_SECRET_ID="${APPROLE_SECRET_ID:?Error: APPROLE_SECRET_ID not set}"
PKI_MOUNT="pki_int"
CERT_DIR="/etc/vault/certs"
RENEWAL_THRESHOLD_DAYS=30  # Renew if cert expires in less than 30 days
LOG_FILE="/var/log/vault-cert-renewal.log"

# Script arguments
ROLE_NAME="${1:?Error: Role name required}"
CERT_NAME="${2:?Error: Certificate name required}"
SAN_LIST="${3:-}"

# Logging function
log() {
    local level=$1
    shift
    local message="$@"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | tee -a "$LOG_FILE"
}

# Check if certificate file exists
if [[ ! -f "$CERT_DIR/$CERT_NAME.crt" ]]; then
    log "WARN" "Certificate not found: $CERT_DIR/$CERT_NAME.crt"
    log "INFO" "Requesting initial certificate for $CERT_NAME..."
    "$SCRIPT_DIR/vault-cert-request.sh" "$ROLE_NAME" "$CERT_NAME" "$SAN_LIST"
    exit 0
fi

# Get certificate expiration date
EXPIRY_DATE=$(openssl x509 -enddate -noout -in "$CERT_DIR/$CERT_NAME.crt" | cut -d= -f2)
EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s)
CURRENT_EPOCH=$(date +%s)
DAYS_UNTIL_EXPIRY=$(( ($EXPIRY_EPOCH - $CURRENT_EPOCH) / 86400 ))

log "INFO" "Certificate: $CERT_NAME | Expires in: $DAYS_UNTIL_EXPIRY days"

# Check if renewal is needed
if [[ $DAYS_UNTIL_EXPIRY -lt $RENEWAL_THRESHOLD_DAYS ]]; then
    log "WARN" "Certificate expiring in $DAYS_UNTIL_EXPIRY days - initiating renewal"
    
    # Authenticate to Vault
    LOGIN_RESPONSE=$(curl -s -X POST "$VAULT_ADDR/v1/auth/approle/login" \
      -H "Content-Type: application/json" \
      -d "{\"role_id\":\"$APPROLE_ROLE_ID\",\"secret_id\":\"$APPROLE_SECRET_ID\"}")
    
    VAULT_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.auth.client_token' 2>/dev/null)
    
    if [[ -z "$VAULT_TOKEN" || "$VAULT_TOKEN" == "null" ]]; then
        log "ERROR" "Failed to authenticate with AppRole"
        exit 1
    fi
    
    # Build request
    REQUEST_JSON="{\"common_name\": \"$CERT_NAME\", \"ttl\": \"2592000s\"}"
    
    if [[ -n "$SAN_LIST" ]]; then
        REQUEST_JSON=$(echo "$REQUEST_JSON" | jq --arg sans "$SAN_LIST" '. + {alt_names: $sans}')
    fi
    
    # Request new certificate
    CERT_RESPONSE=$(curl -s -X POST "$VAULT_ADDR/v1/$PKI_MOUNT/issue/$ROLE_NAME" \
      -H "X-Vault-Token: $VAULT_TOKEN" \
      -H "Content-Type: application/json" \
      -d "$REQUEST_JSON")
    
    CERTIFICATE=$(echo "$CERT_RESPONSE" | jq -r '.data.certificate' 2>/dev/null)
    PRIVATE_KEY=$(echo "$CERT_RESPONSE" | jq -r '.data.private_key' 2>/dev/null)
    CA_CHAIN=$(echo "$CERT_RESPONSE" | jq -r '.data.ca_chain[]' 2>/dev/null)
    
    if [[ -z "$CERTIFICATE" || "$CERTIFICATE" == "null" ]]; then
        log "ERROR" "Failed to issue renewal certificate"
        exit 1
    fi
    
    # Backup old certificate
    TIMESTAMP=$(date +%s)
    sudo cp "$CERT_DIR/$CERT_NAME.crt" "$CERT_DIR/$CERT_NAME.crt.backup.$TIMESTAMP"
    sudo cp "$CERT_DIR/$CERT_NAME.key" "$CERT_DIR/$CERT_NAME.key.backup.$TIMESTAMP"
    
    # Write new certificates
    echo "$CERTIFICATE" | sudo tee "$CERT_DIR/$CERT_NAME.crt" > /dev/null
    echo "$PRIVATE_KEY" | sudo tee "$CERT_DIR/$CERT_NAME.key" > /dev/null
    sudo chmod 600 "$CERT_DIR/$CERT_NAME.key"
    sudo chmod 644 "$CERT_DIR/$CERT_NAME.crt"
    
    if [[ -n "$CA_CHAIN" ]]; then
        echo "$CA_CHAIN" | sudo tee "$CERT_DIR/$CERT_NAME-ca-chain.crt" > /dev/null
        sudo chmod 644 "$CERT_DIR/$CERT_NAME-ca-chain.crt"
    fi
    
    # Revoke the token
    curl -s -X POST "$VAULT_ADDR/v1/auth/token/revoke-self" \
      -H "X-Vault-Token: $VAULT_TOKEN" > /dev/null 2>&1 || true
    
    log "INFO" "Certificate renewed successfully"
else
    log "INFO" "Certificate still valid - renewal not needed"
fi
