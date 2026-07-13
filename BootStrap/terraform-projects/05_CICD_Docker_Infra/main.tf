module "Vault-TFStateBackend" {
    source = "../modules/proxmox-vm"
    vm_name_suffix = "Docker"
    vm_vmid = "304"
    proxmox_target_host = "perf"
    vm_storage_source = "local-lvm"
    ansible_user = var.ansible_user
    ip_address = "10.0.0.104"
    public_key_path = var.public_key_path
    ciuser = var.ciuser
    cipassword = var.cipassword
    private_key_path = var.private_key_path
    sshkeys = var.sshkeys
    directory = var.directory
    inventory_path = var.inventory_path
    vm_memory = "4096"
}