module "Vault-IntCA" {
    source = "../modules/proxmox-vm"
    vm_name_suffix = "IntermediateCA"
    vm_vmid = "303"
    proxmox_target_host = "perf"
    vm_storage_source = "local-lvm"
    ansible_user = var.ansible_user
    ip_address = "10.0.0.103"
    public_key_path = var.public_key_path
    ciuser = var.ciuser
    cipassword = var.cipassword
    private_key_path = var.private_key_path
    sshkeys = var.sshkeys
    directory = var.directory
    ansible_vault_folderpath = "../../../ansible-playbooks/roles/vault_SubCA/files/"
    inventory_path = var.inventory_path
}