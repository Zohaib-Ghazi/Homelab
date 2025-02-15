# Proxmox Full-Clone of Ubuntu 22.04
# ---
# Create a new VM from a clone - Reference: Christian Lempa

resource "proxmox_vm_qemu" "VM-Terraform" {
    
    #VM General Settings
    target_node = "pve"
    vmid = "30${count.index + 1}"
    count = 3
    name = "VM-Terraform-${count.index + 1}"
    desc = "Terraform Test VM's"

    #VM Advanced Settings
    onboot = true 
    boot = "order=scsi0" #Has to match the OS disk configuration of the template image
    scsihw = "virtio-scsi-single"
    full_clone = true

    #VM OS Settings
    clone = "Ubuntu-22.04-minimal-cloudinit-template"

    #VM QEMU Guest Agent Settings
    agent = 1
    
    #VM CPU & Memory Settings
    cores = 2
    sockets = 1
    cpu = "host"    
    memory = 2048

    #VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    #VM Cloud-Init Settings
    os_type = "cloud-init"
    nameserver = var.VM_DNS
    #ipconfig0 = "ip=10.0.0.130/24,gw=10.0.0.1"
    ipconfig0 = "ip=dhcp"
    skip_ipv6 = true
    qemu_os = "l26"

    # (Optional) IP Address and Gateway
    # ipconfig0 = "ip=0.0.0.0/0,gw=0.0.0.0"
    
    # (Optional) Host VM User Credentials
    ciuser = var.ciuser
    cipassword = var.cipassword
    
    # (Optional) Pre-configured list of public SSH KEYs (includes Workstation, pve 1 + pve 2)
    sshkeys = var.sshkeys

    #Confirm if needed
    vga {
      type = "serial0"
    }

    #Confirm if needed
    serial {
        id   = 0
        type = "socket"
    }

    #VM Storage Configurations
    disks {
        scsi {
          scsi0 {
            disk {
              storage = "NFS-VMs"
              size = "32G"
            }
          }
        }
        ide {
            ide2 {
                cloudinit {
                    storage = "NFS-VMs"
                }
            }
      }
    }

  # Ignore changes to the network
  ## MAC address is generated on every apply, causing
  ## TF to think this needs to be rebuilt on every apply
  #lifecycle {
  #   ignore_changes = [
  #     network
  #   ]
  #}
}