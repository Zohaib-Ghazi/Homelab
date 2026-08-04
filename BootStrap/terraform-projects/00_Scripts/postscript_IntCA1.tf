#Read the terraform state file of Root CA from Azure blob storage
data "terraform_remote_state" "RootCA_TF" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatesa0dev"
    container_name       = "azurecloud-tfstate"
    key                  = "rootca_pki.tfstate"
  }
}

# Import the signed intermediate CA certificate into the PKI secrets engine
resource "vault_pki_secret_backend_intermediate_set_signed" "signed_intermediate" {
  depends_on = [ vault_mount.pki_int ]
  provider = vault.pki
  backend     = vault_mount.pki_int.path
  certificate = data.terraform_remote_state.RootCA_TF.outputs.signed_CSR_cert
}

#Importing the signed cert from the root CA into the intermediate PKI secrets engine as a trusted issuer
resource "vault_pki_secret_backend_issuer" "intermediate_issuer" {
  depends_on = [vault_pki_secret_backend_intermediate_set_signed.signed_intermediate]
  provider                        = vault.pki
  backend                        = vault_mount.pki_int.path
  issuer_ref                     = vault_pki_secret_backend_intermediate_set_signed.signed_intermediate.imported_issuers[0]
  issuer_name                    = "${var.issuer_name}" 
  revocation_signature_algorithm = "SHA256WithRSA"
}

# Create a role for issuing certificates by the Int CA (legacy general role)
resource "vault_pki_secret_backend_role" "IntCA_role" {
  #depends_on = [ vault_pki_secret_backend_issuer.intermediate_issuer ]
  provider         = vault.pki
  backend          = vault_mount.pki_int.path
  issuer_ref = vault_pki_secret_backend_issuer.intermediate_issuer.issuer_ref
  
  #Name to be used to target this role when issuing certificates
  name             = "IntCA-Issuing-Role"
  ttl             = 2592000 #30 days
  max_ttl         = 157680000 #5 years
  allow_ip_sans    = true #allow IP SANs in issued certificates
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains = ["naizoyden.net", "homelab"] #restrict to specific domain(s)
  allow_subdomains = true
  allow_bare_domains = true
  allow_any_name   = true
  require_cn        = false #for ACME compatibility, we need to set this to false. ACME clients may request certificates without a common name, which is not allowed by the role configuration. By setting require_cn to false, we ensure that all certificate requests can be processed successfully, even if they do not include a common name.
  server_flag       = true
  organization      = ["HomeLab Inc."]
  country           = ["Canada"]
  locality          = ["Toronto"]
}

# ============================================================================
# Infrastructure Server Certificates (TFBE, RootCA, IntCA appliances)
# ============================================================================

resource "vault_pki_secret_backend_role" "infra_server" {
  provider   = vault.pki
  backend    = vault_mount.pki_int.path
  issuer_ref = vault_pki_secret_backend_issuer.intermediate_issuer.issuer_ref

  name               = "infra-server"
  ttl                = 2592000      # 30 days
  max_ttl            = 157680000    # 5 years
  allow_ip_sans      = true
  key_type           = "rsa"
  key_bits           = 4096
  allowed_domains    = ["naizoyden.net", "homelab"]
  allow_subdomains   = true
  allow_bare_domains = true
  allow_any_name     = false
  require_cn         = false
  server_flag        = true
  client_flag        = false
  organization       = ["HomeLab Inc."]
  country            = ["Canada"]
  locality           = ["Toronto"]
}

# ============================================================================
# Windows VM Certificates (Gaming VM, etc.)
# ============================================================================

resource "vault_pki_secret_backend_role" "windows_vm" {
  provider   = vault.pki
  backend    = vault_mount.pki_int.path
  issuer_ref = vault_pki_secret_backend_issuer.intermediate_issuer.issuer_ref

  name               = "windows-vm"
  ttl                = 2592000      # 30 days
  max_ttl            = 157680000    # 5 years
  allow_ip_sans      = true
  key_type           = "rsa"
  key_bits           = 4096
  allowed_domains    = ["naizoyden.net", "homelab"]
  allow_subdomains   = true
  allow_bare_domains = true
  allow_any_name     = false
  require_cn         = false
  server_flag        = true
  client_flag        = false
  organization       = ["HomeLab Inc."]
  country            = ["Canada"]
  locality           = ["Toronto"]
}

# ============================================================================
# Proxmox Cluster Certificates (SAN cert for cluster endpoints)
# ============================================================================

resource "vault_pki_secret_backend_role" "proxmox_cluster" {
  provider   = vault.pki
  backend    = vault_mount.pki_int.path
  issuer_ref = vault_pki_secret_backend_issuer.intermediate_issuer.issuer_ref

  name               = "proxmox-cluster"
  ttl                = 2592000      # 30 days
  max_ttl            = 157680000    # 5 years
  allow_ip_sans      = true
  key_type           = "rsa"
  key_bits           = 4096
  allowed_domains    = ["proxmox.homelab", "naizoyden.net", "homelab", "pve"]
  allow_subdomains   = true
  allow_bare_domains = true
  allow_any_name     = false
  require_cn         = false
  server_flag        = true
  client_flag        = false
  organization       = ["HomeLab Inc."]
  country            = ["Canada"]
  locality           = ["Toronto"]
}

# ============================================================================
# Proxmox Host Certificates (individual node certificates)
# ============================================================================

resource "vault_pki_secret_backend_role" "proxmox_host" {
  provider   = vault.pki
  backend    = vault_mount.pki_int.path
  issuer_ref = vault_pki_secret_backend_issuer.intermediate_issuer.issuer_ref

  name               = "proxmox-host"
  ttl                = 2592000      # 30 days
  max_ttl            = 157680000    # 5 years
  allow_ip_sans      = true
  key_type           = "rsa"
  key_bits           = 4096
  allowed_domains    = ["proxmox.homelab", "homelab", "pve", "naizoyden.net"]
  allow_subdomains   = true
  allow_bare_domains = true
  allow_any_name     = true
  require_cn         = false
  server_flag        = true
  client_flag        = false
  organization       = ["HomeLab Inc."]
  country            = ["Canada"]
  locality           = ["Toronto"]
}
