#!/usr/bin/env python3
"""
vault-cert-manager.py
Alternative Python-based certificate management utility for Vault PKI

Features:
- Request certificates via AppRole authentication
- Check certificate expiration and auto-renew if needed
- Manage certificate lifecycle with logging
- JSON output for automation
"""

import os
import sys
import json
import argparse
import logging
import subprocess
from datetime import datetime, timedelta
from pathlib import Path
import requests
from cryptography import x509
from cryptography.hazmat.backends import default_backend

# Configuration
VAULT_ADDR = os.getenv('VAULT_ADDR')
APPROLE_ROLE_ID = os.getenv('APPROLE_ROLE_ID')
APPROLE_SECRET_ID = os.getenv('APPROLE_SECRET_ID')
PKI_MOUNT = 'pki_int'
CERT_DIR = Path('/etc/vault/certs')
BACKUP_DIR = Path('/etc/vault/backups')
LOG_FILE = Path('/var/log/vault-cert-manager.log')

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)


class VaultCertManager:
    """Manage certificates in Vault PKI"""
    
    def __init__(self, vault_addr, role_id, secret_id):
        self.vault_addr = vault_addr
        self.role_id = role_id
        self.secret_id = secret_id
        self.token = None
        self.session = requests.Session()
        self.session.verify = os.getenv('VAULT_SKIP_VERIFY', 'false').lower() == 'false'
    
    def authenticate(self):
        """Authenticate with Vault using AppRole"""
        try:
            response = self.session.post(
                f'{self.vault_addr}/v1/auth/approle/login',
                json={
                    'role_id': self.role_id,
                    'secret_id': self.secret_id
                }
            )
            response.raise_for_status()
            self.token = response.json()['auth']['client_token']
            logger.info('Successfully authenticated with AppRole')
            return True
        except Exception as e:
            logger.error(f'AppRole authentication failed: {e}')
            return False
    
    def request_certificate(self, role_name, common_name, alt_names=None, ttl='2592000s'):
        """Request a certificate from a Vault PKI role"""
        if not self.token:
            logger.error('Not authenticated. Call authenticate() first.')
            return None
        
        try:
            payload = {
                'common_name': common_name,
                'ttl': ttl
            }
            
            if alt_names:
                if isinstance(alt_names, str):
                    payload['alt_names'] = alt_names
                else:
                    payload['alt_names'] = ','.join(alt_names)
            
            headers = {'X-Vault-Token': self.token}
            
            response = self.session.post(
                f'{self.vault_addr}/v1/{PKI_MOUNT}/issue/{role_name}',
                json=payload,
                headers=headers
            )
            response.raise_for_status()
            
            cert_data = response.json()['data']
            logger.info(f'Certificate issued: {common_name} (Serial: {cert_data["serial_number"]})')
            return cert_data
            
        except Exception as e:
            logger.error(f'Certificate request failed: {e}')
            return None
    
    def save_certificate(self, cert_data, cert_name):
        """Save certificate and key files to disk"""
        try:
            # Create directories
            CERT_DIR.mkdir(parents=True, exist_ok=True)
            BACKUP_DIR.mkdir(parents=True, exist_ok=True)
            
            # Backup existing files
            cert_file = CERT_DIR / f'{cert_name}.crt'
            key_file = CERT_DIR / f'{cert_name}.key'
            
            if cert_file.exists():
                timestamp = datetime.now().strftime('%s')
                subprocess.run(['sudo', 'cp', str(cert_file), f'{BACKUP_DIR}/{cert_name}.crt.{timestamp}'])
                subprocess.run(['sudo', 'cp', str(key_file), f'{BACKUP_DIR}/{cert_name}.key.{timestamp}'])
                logger.info(f'Backed up existing certificates')
            
            # Write new files with sudo
            cert_content = cert_data['certificate']
            key_content = cert_data['private_key']
            
            # Write certificate
            subprocess.run(['sudo', 'bash', '-c', f'cat > {cert_file}'], 
                         input=cert_content.encode(), check=True)
            subprocess.run(['sudo', 'chmod', '644', str(cert_file)], check=True)
            
            # Write private key
            subprocess.run(['sudo', 'bash', '-c', f'cat > {key_file}'], 
                         input=key_content.encode(), check=True)
            subprocess.run(['sudo', 'chmod', '600', str(key_file)], check=True)
            
            # Write CA chain if present
            if 'ca_chain' in cert_data and cert_data['ca_chain']:
                ca_chain = '\n'.join(cert_data['ca_chain'])
                chain_file = CERT_DIR / f'{cert_name}-ca-chain.crt'
                subprocess.run(['sudo', 'bash', '-c', f'cat > {chain_file}'], 
                             input=ca_chain.encode(), check=True)
                subprocess.run(['sudo', 'chmod', '644', str(chain_file)], check=True)
            
            logger.info(f'Certificate files saved to {CERT_DIR}')
            return True
            
        except Exception as e:
            logger.error(f'Failed to save certificate: {e}')
            return False
    
    def check_expiration(self, cert_name, renewal_threshold_days=30):
        """Check certificate expiration and determine if renewal is needed"""
        cert_file = CERT_DIR / f'{cert_name}.crt'
        
        if not cert_file.exists():
            logger.warning(f'Certificate not found: {cert_file}')
            return None
        
        try:
            with open(cert_file, 'rb') as f:
                cert = x509.load_pem_x509_certificate(f.read(), default_backend())
            
            expiry_date = cert.not_valid_after
            now = datetime.utcnow()
            days_until_expiry = (expiry_date - now).days
            
            logger.info(f'Certificate {cert_name} expires in {days_until_expiry} days ({expiry_date.isoformat()})')
            
            needs_renewal = days_until_expiry < renewal_threshold_days
            
            return {
                'cert_name': cert_name,
                'expiry_date': expiry_date.isoformat(),
                'days_until_expiry': days_until_expiry,
                'needs_renewal': needs_renewal
            }
            
        except Exception as e:
            logger.error(f'Failed to check certificate expiration: {e}')
            return None
    
    def revoke_token(self):
        """Revoke the authentication token"""
        if not self.token:
            return True
        
        try:
            headers = {'X-Vault-Token': self.token}
            self.session.post(
                f'{self.vault_addr}/v1/auth/token/revoke-self',
                headers=headers
            )
            logger.debug('Token revoked')
            return True
        except Exception as e:
            logger.warning(f'Failed to revoke token: {e}')
            return True


def cmd_request(args):
    """Handle certificate request command"""
    if not all([VAULT_ADDR, APPROLE_ROLE_ID, APPROLE_SECRET_ID]):
        logger.error('Missing required environment variables: VAULT_ADDR, APPROLE_ROLE_ID, APPROLE_SECRET_ID')
        return False
    
    manager = VaultCertManager(VAULT_ADDR, APPROLE_ROLE_ID, APPROLE_SECRET_ID)
    
    if not manager.authenticate():
        return False
    
    try:
        cert_data = manager.request_certificate(
            args.role,
            args.common_name,
            alt_names=args.alt_names,
            ttl=args.ttl
        )
        
        if not cert_data:
            return False
        
        if not manager.save_certificate(cert_data, args.cert_name):
            return False
        
        if args.json:
            output = {
                'status': 'success',
                'cert_name': args.cert_name,
                'serial_number': cert_data.get('serial_number'),
                'certificate_file': str(CERT_DIR / f'{args.cert_name}.crt'),
                'key_file': str(CERT_DIR / f'{args.cert_name}.key')
            }
            print(json.dumps(output))
        
        return True
        
    finally:
        manager.revoke_token()


def cmd_renew(args):
    """Handle certificate renewal command"""
    if not all([VAULT_ADDR, APPROLE_ROLE_ID, APPROLE_SECRET_ID]):
        logger.error('Missing required environment variables')
        return False
    
    manager = VaultCertManager(VAULT_ADDR, APPROLE_ROLE_ID, APPROLE_SECRET_ID)
    
    try:
        # Check expiration
        exp_info = manager.check_expiration(
            args.cert_name,
            args.renewal_threshold
        )
        
        if not exp_info:
            return False
        
        if args.json:
            print(json.dumps(exp_info))
        
        if not exp_info['needs_renewal']:
            logger.info('Certificate renewal not needed')
            return True
        
        # Authenticate and renew
        if not manager.authenticate():
            return False
        
        cert_data = manager.request_certificate(
            args.role,
            args.common_name,
            alt_names=args.alt_names,
            ttl=args.ttl
        )
        
        if not cert_data:
            return False
        
        return manager.save_certificate(cert_data, args.cert_name)
        
    finally:
        manager.revoke_token()


def cmd_check(args):
    """Handle certificate check command"""
    manager = VaultCertManager(VAULT_ADDR, APPROLE_ROLE_ID, APPROLE_SECRET_ID)
    
    exp_info = manager.check_expiration(
        args.cert_name,
        args.renewal_threshold
    )
    
    if not exp_info:
        return False
    
    if args.json:
        print(json.dumps(exp_info))
    else:
        print(f"Certificate: {exp_info['cert_name']}")
        print(f"  Expires: {exp_info['expiry_date']}")
        print(f"  Days until expiry: {exp_info['days_until_expiry']}")
        print(f"  Needs renewal: {exp_info['needs_renewal']}")
    
    return True


def main():
    parser = argparse.ArgumentParser(
        description='Vault PKI Certificate Manager',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
Examples:
  # Request a new certificate
  %(prog)s request --role proxmox-host --cn pve01 --cert-name pve01 \\
    --alt-names "pve01.proxmox.homelab,pve01.homelab"
  
  # Check certificate expiration
  %(prog)s check --cert-name pve01
  
  # Renew certificate if needed
  %(prog)s renew --role proxmox-host --cn pve01 --cert-name pve01 \\
    --alt-names "pve01.proxmox.homelab"
        '''
    )
    
    parser.add_argument('-j', '--json', action='store_true', help='Output JSON format')
    
    subparsers = parser.add_subparsers(dest='command', help='Command to execute')
    
    # Request command
    req_parser = subparsers.add_parser('request', help='Request a new certificate')
    req_parser.add_argument('--role', required=True, help='Vault PKI role name')
    req_parser.add_argument('--cn', '--common-name', dest='common_name', required=True, help='Certificate common name')
    req_parser.add_argument('--cert-name', default=None, help='Certificate file name (defaults to common name)')
    req_parser.add_argument('--alt-names', help='Alternative names (comma-separated)')
    req_parser.add_argument('--ttl', default='2592000s', help='Certificate TTL (default: 2592000s)')
    req_parser.set_defaults(func=cmd_request)
    
    # Check command
    check_parser = subparsers.add_parser('check', help='Check certificate expiration')
    check_parser.add_argument('--cert-name', required=True, help='Certificate name')
    check_parser.add_argument('--renewal-threshold', type=int, default=30, help='Days before expiry to consider renewal needed')
    check_parser.set_defaults(func=cmd_check)
    
    # Renew command
    renew_parser = subparsers.add_parser('renew', help='Renew certificate if needed')
    renew_parser.add_argument('--role', required=True, help='Vault PKI role name')
    renew_parser.add_argument('--cn', '--common-name', dest='common_name', required=True, help='Certificate common name')
    renew_parser.add_argument('--cert-name', required=True, help='Certificate file name')
    renew_parser.add_argument('--alt-names', help='Alternative names (comma-separated)')
    renew_parser.add_argument('--renewal-threshold', type=int, default=30, help='Days threshold for renewal')
    renew_parser.add_argument('--ttl', default='2592000s', help='Certificate TTL')
    renew_parser.set_defaults(func=cmd_renew)
    
    # Set default cert-name for request
    def set_default_cert_name(args):
        if args.command == 'request' and args.cert_name is None:
            args.cert_name = args.common_name
        return args
    
    args = parser.parse_args()
    args = set_default_cert_name(args)
    
    if not args.command:
        parser.print_help()
        return 1
    
    try:
        success = args.func(args)
        return 0 if success else 1
    except Exception as e:
        logger.error(f'Unexpected error: {e}')
        return 1


if __name__ == '__main__':
    sys.exit(main())
