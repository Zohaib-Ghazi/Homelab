variable "vm_name_suffix" {
    description = "VM Name Suffix"
    type = string
}

variable "vm_template" {
    description = "VM Template"
    type = string
    default = "Ubuntu-22.04-minimal-cloudinit-template"
}

variable "vm_cores" {
    description = "VM Cores"
    type = number
    default = 2
}

variable "vm_sockets" {
    description = "VM Sockets"
    type = number
    default = 1
}

variable "vm_vmid" {
    description = "VM ID"
    type = string
}

variable "vm_cpu" {
    description = "VM CPU"
    type = string
    default = "host"
}

variable "vm_memory" {
    description = "VM Memory"
    type = number
    default = 2048
}

variable "vm_network_model" {
    description = "VM Network Model"
    type = string
    default = "virtio"
}

variable "vm_disk_size" {
    description = "VM Disk Size"
    type = string
    default = "32G"
}

variable "vm_storage_source" {
    description = "VM Storage Source"
    type = string
    default = "NFS-VMs" 
}

variable "nfs_storage" {
    description = "NFS Storage"
    type = string
    default = "NFS-VMs"
}

variable "vm_network_bridge" {
    description = "VM Network Bridge"
    type = string
    default = "vmbr0"
}

variable "ip_address" {
    description = "VM IP Address"
    type = string
    #default = "10.0.0.105"
}

variable "ip_range_start" {
    description = "IP Range Start"
    type = string
    default = "101"
}

variable "ip_range_end" {
    description = "IP Range Start"
    type = string
    default = "102"
}

variable "subnet_mask" {
    description = "Subnet Mask"
    type = string
    default = "24"
}

variable "gateway" {
    description = "Gateway"
    type = string
    default = "10.0.0.1"
}
 
variable "proxmox_perf_host" {
    description = "Proxmox Performance Node Name"
    type = string
    default = "pve"
}

variable "proxmox_nas_host" {
    description = "Proxmox NAS Node Name"
    type = string
    default = "pve2"
}
variable "proxmox_target_host" {
    description = "Proxmox Host Node Name"
    type = string
}
variable "VM_DNS" {
    description = "Public DNS Server IPs"
    type = string
    default = "1.1.1.1 8.8.8.8"
}

variable "ciuser" {
    description = "Service Account - ciuser"
    type = string
    #sensitive = true
}

variable "cipassword" {
    description = "Service Account Password - ciuser"
    type = string
    #sensitive = true
}

variable "sshkeys" {
    description = "Public SSH Keys"
    type = string
}

variable "ansible_user" {
    description = "Ansible service account"
    type = string
    #sensitive = true
}

variable "private_key_path" {
    description = "Private Key Path"
    type = string
    #should i add a sensitive=true here? #TODO: Check if this is required
}

variable "public_key_path" {
    description = "Public Key Path"
    type = string
}

variable "directory" {
    description = "Current Working Directory for Terraform & Ansible"
    type = string
}

variable "qemu_agent" {
    description = "QEMU Agent"
    type = number
    default = 1
}

variable "ansible_vault_folderpath" {
    description = "Ansible Vault Folder Path"
    type = string
    default = "../../../ansible-playbooks/roles/vault/files/"
}