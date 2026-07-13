module "Vault-TrueNASStateBackend" {
    source = "../modules/proxmox-vm"
    vm_name_suffix = "TrueNAS"
    vm_template = "TrueNAS-Template-OVMF"
    vm_vmid = "399"
    vm_cores = 4
    vm_memory = 85831
    proxmox_target_host = "nas"
    vm_bios = "ovmf"
    vm_boot_order = "order=ide2;scsi0;net0" #Has to match the OS disk configuration of the template image #TODO: Set configurations as variables
    skip_ansible_provisioning = true
    vm_storage_source = "local-lvm"
    ansible_user = var.ansible_user
    ip_address = "10.0.0.233"
    public_key_path = var.public_key_path
    ciuser = var.ciuser
    cipassword = var.cipassword
    private_key_path = var.private_key_path
    sshkeys = var.sshkeys
    directory = var.directory
    inventory_path = var.inventory_path
}