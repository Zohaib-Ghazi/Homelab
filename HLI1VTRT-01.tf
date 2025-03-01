#Naming scheme: HL = home lab; X1 = Production; SSTF = support services Terraform
#Version 1.0.0
resource "proxmox_vm_qemu" "HLI1VTRT-01" {
    
    #VM General Settings
    target_node = var.proxmox_nas_host 
    vmid = "301"
    name = "HLI1VTRT01"
    desc = "Production Vault Root CA"

    #VM Advanced Settings
    onboot = false 
    bootdisk = "scsi0" #The bood disk scsi
    boot = "order=scsi0" #Has to match the OS disk configuration of the template image
    scsihw = "virtio-scsi-single" #Scsi hardware type

    #VM Template Image to Clone
    clone = "Ubuntu-22.04-minimal-cloudinit-template"
    full_clone = true

    agent = 1 #QEMU Guest Agent Installed?
    
    #VM CPU & Memory Settings
    cores = 2
    sockets = 1
    cpu = "host"    
    memory = 2048

    #VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
        #tag = VLANID
    }

    #VM Cloud-Init Settings
    os_type = "cloud-init" #The OS type of the image clone
    nameserver = var.VM_DNS
    #ipconfig0 = "ip=10.0.0.130/24,gw=10.0.0.1"
    #ipconfig0 = "ip=dhcp"
    skip_ipv6 = true
    qemu_os = "l26"

    #Network Configurations: IP Address and Gateway
    ipconfig0 = "ip=10.0.0.101/24,gw=10.0.0.1"
    
    # (Optional) Host VM User Credentials
    ciuser = var.ciuser
    cipassword = var.cipassword
    
    #Public SSH Keys
    sshkeys = <<EOF
    ${var.sshkeys}
    EOF

    #Confirm if needed
    vga {
      type = "serial0"
    }

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
 
  ## Lifecycle section tells Terraform to ignore any changes to network configuration, disk, sshkeys, and the node that the VMs is on. This allows configuration drift in those areas without triggering Terraform to destroy the VM and recreate it with the “correct” configuration.
  lifecycle {
     ignore_changes = [
       network, disk, sshkeys, target_node]
  }
}

resource "null_resource" "HLI1VTRT-01-Ansible-Execution" {
  provisioner "remote-exec" {
    inline = ["echo 'Ansible can now reach this resource!'"]

    connection {
      type = "ssh"
      user = var.ansible_user
      private_key = file("${var.private_key_path}")
      host = "10.0.0.101" #self.ip_address 
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_CONFIG=${var.directory}/ansible-playbooks/ansible.cfg ansible-playbook -i ${var.directory}/Inventory/inventory -u ${var.ansible_user} --private-key ${var.private_key_path} -e 'pub_key=${var.public_key_path}' ${var.directory}/ansible-playbooks/site.yml"
  } 
}