#!/bin/bash
# acme-setup-existing-vm.sh
# Setup ACME client (certbot) on existing VMs for automatic certificate renewal
# Usage: ./acme-setup-existing-vm.sh <domain> [email] [certificate-name]
# Example: ./acme-setup-existing-vm.sh pve01.proxmox.homelab admin@naizoyden.net pve01

set -e

# Configuration
VAULT_ADDR="${VAULT_ADDR:?Error: VAULT_ADDR not set}"
PKI_MOUNT="pki_int"
ACME_DIR_URL="${VAULT_ADDR}/v1/${PKI_MOUNT}/acme/directory"
CERT_DIR="/etc/vault/certs"
LOG_DIR="/var/log/acme"

# Script arguments
PRIMARY_DOMAIN="${1:?Error: Primary domain required (e.g., pve01.proxmox.homelab)}"
EMAIL="${2:-admin@homelab}"
CERT_NAME="${3:-${PRIMARY_DOMAIN%.*}}"  # Use hostname part of domain if not specified

# Logging
mkdir -p "$LOG_DIR"
log_file="$LOG_DIR/acme-setup.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $@" | tee -a "$log_file"
}

log "[*] Starting ACME client setup for domain: $PRIMARY_DOMAIN"

# Detect distribution and install dependencies
if command -v apt-get &> /dev/null; then
    log "[*] Detected Debian/Ubuntu - installing certbot..."
    sudo apt-get update
    sudo apt-get install -y certbot
    CERT_DIR_SYSTEM="/etc/letsencrypt/live/$PRIMARY_DOMAIN"
elif command -v yum &> /dev/null; then
    log "[*] Detected RHEL/CentOS - installing certbot..."
    sudo yum install -y certbot
    CERT_DIR_SYSTEM="/etc/letsencrypt/live/$PRIMARY_DOMAIN"
else
    log "[!] Warning: Could not detect package manager. Please install certbot manually."
    exit 1
fi

log "[+] Certbot installed successfully"

# Create certificate directories
sudo mkdir -p "$CERT_DIR"

log "[*] Registering with ACME server..."

# Register with ACME server (non-interactive)
certbot register \
    --server "$ACME_DIR_URL" \
    --non-interactive \
    --agree-tos \
    --email "$EMAIL" \
    --no-eff-email || log "[!] Registration may have failed, but continuing..."

log "[+] ACME registration complete"

log "[*] Requesting certificate for $PRIMARY_DOMAIN..."

# Request certificate with standalone authenticator
sudo certbot certonly \
    --server "$ACME_DIR_URL" \
    --standalone \
    --non-interactive \
    --agree-tos \
    --email "$EMAIL" \
    --preferred-challenges http \
    --domain "$PRIMARY_DOMAIN" \
    --cert-name "$CERT_NAME"

log "[+] Certificate requested successfully"

# Symlink certificates to standard location
if [[ -d "$CERT_DIR_SYSTEM" ]]; then
    sudo ln -sf "$CERT_DIR_SYSTEM/fullchain.pem" "$CERT_DIR/$CERT_NAME.crt" || true
    sudo ln -sf "$CERT_DIR_SYSTEM/privkey.pem" "$CERT_DIR/$CERT_NAME.key" || true
    sudo ln -sf "$CERT_DIR_SYSTEM/chain.pem" "$CERT_DIR/$CERT_NAME-ca-chain.crt" || true
    log "[+] Certificates symlinked to $CERT_DIR"
else
    log "[!] Warning: Could not find certbot certificate directory"
fi

# Setup automatic renewal via cron
log "[*] Setting up automatic renewal via cron..."

CRON_JOB="0 3 * * * certbot renew --server $ACME_DIR_URL --quiet --no-eff-email"
CRON_FILE="/etc/cron.d/certbot-acme-renewal"

if ! sudo grep -q "certbot renew" "$CRON_FILE" 2>/dev/null; then
    echo "$CRON_JOB" | sudo tee "$CRON_FILE" > /dev/null
    log "[+] Cron job created for automatic renewal"
else
    log "[!] Cron job already exists"
fi

log "[+] ACME setup complete for $PRIMARY_DOMAIN"
log "    Certificate location: $CERT_DIR/$CERT_NAME.crt"
log "    Private Key location: $CERT_DIR/$CERT_NAME.key"
log "    CA Chain location: $CERT_DIR/$CERT_NAME-ca-chain.crt"
log "    ACME automatic renewal configured in: $CRON_FILE"

# Verify certificate
log "[*] Verifying certificate..."
openssl x509 -in "$CERT_DIR/$CERT_NAME.crt" -text -noout | grep -A2 "Subject:" || true
openssl x509 -enddate -noout -in "$CERT_DIR/$CERT_NAME.crt" || true

log "[+] ACME setup complete!"
