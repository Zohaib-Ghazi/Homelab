terraform {
  required_version = "=1.10.5"

  required_providers {
    proxmox = {
        source = "telmate/proxmox"
        version = "3.0.1-rc4"
    }
  }
}

locals {
    #List of IP addresses in given range
    ip_list = [for i in range(var.ip_range_start, var.ip_range_end): "10.0.0.${i}"]
    target_host = var.proxmox_target_host == "perf" ? var.proxmox_perf_host : var.proxmox_nas_host
    ansible_inventory = var.vm_name_suffix == "vault" ? "[vault]" : "[TF-VM]"
}

#Proxmox VM Resource Configuration
resource "proxmox_vm_qemu" "TF_VM" {
    
    #Count of VMs to be created
    count = length(local.ip_list)

    #VM Name & ID
    name = "TF-VM-${var.vm_name_suffix}-${count.index + 1}"
    vmid = var.vm_vmid
    #tags = #TODO: Implement tags for VMs

    #VM Target Host Node
    target_node = local.target_host
    
    #VM Template Image
    clone = var.vm_template
    full_clone = true
    os_type = "cloud-init" #Which provisioning method to use, based on the OS type. Options: ubuntu, centos, cloud-init.
    qemu_os = "l26" #Learn the purpose behind this flag #TODO: Set configurations as variables

    #VM QEMU Guest Agent State
    agent = var.qemu_agent
    
    #VM CPU & Memory Settings
    cores = var.vm_cores
    sockets = var.vm_sockets
    cpu = var.vm_cpu
    memory = var.vm_memory

    #VM Storage Configurations
    #TODO: Implement a more dynamic storage configuration
    onboot = false 
    #bootdisk = "scsi0" #The boot disk scsi #TODO: Set configurations as variables
    boot = "order=scsi0;ide2;net0" #Has to match the OS disk configuration of the template image #TODO: Set configurations as variables
    scsihw = "virtio-scsi-single" #Scsi hardware type #TODO: Set configurations as variables
    vm_state = "running"

    /*disk {
        type = "disk"
        slot = "scsi0"
        #format = "qcow2"
        storage = var.vm_storage_source
        size = var.vm_disk_size
        #id = "scsi0"
        #backup = true
        #storage_type = "lvm"
        #iothread = true
        #discard = true
        #cache = "writeback"
        #replicate = true
        #replicate_size = 1
        #replicate_schedule = "mon,tue,wed,thu,fri,sat,sun 03:00"
        #replicate_retention = 3
        #replicate_target = "proxmox-backup"
        #replicate_target_datastore = "local"
        #replicate_target_bandwidth = 10
    }*/

    /*disk {
        type = "cloudinit"
        slot = "ide2"
        #format = "qcow2"
        storage = var.vm_storage_source
        #cloudinit = true
    }*/

     # Setup the Cloud-init & Boot disks
    disks {
        ide {
            ide2 {
                cloudinit {
                    storage = var.vm_storage_source
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    size            = var.vm_disk_size
                    storage         = var.vm_storage_source
                    #format          = "qcow2"
                    #cache           = "writeback"
                    #storage_type    = "lvm"
                    iothread        = true
                    backup          = true
                    emulatessd      = true
                    #discard         = true
                }
            }
        }
    }
    
    #Display Settings
    #TODO: Potentially remove this section as it may not be needed
    vga {
      type = "serial0"
    }

    # Most cloud-init images require a serial device for their display
    serial {
        id   = 0
        type = "socket"
    }

    #Network Settings
    network {
        bridge = var.vm_network_bridge
        model  = var.vm_network_model
        #tag = VLANID #TODO: Configure VLANs once new FW/router has been purchased and implemented
    }
      
    #IP Configurations
    ipconfig0 = "ip=${local.ip_list[count.index]}/${var.subnet_mask},gw=${var.gateway}"
    nameserver = var.VM_DNS
    
    #Public SSH Keys
    sshkeys = var.sshkeys

    #Bootstrap Login Credentials
    ciuser = var.ciuser
    cipassword = var.cipassword


    #TODO: Confirm if below is needed and/or functional for proxmox VMs
    ## Lifecycle section tells Terraform to ignore any changes to network configuration, disk, sshkeys, and the node that the VMs is on. This allows configuration drift in those areas without triggering Terraform to destroy the VM and recreate it with the “correct” configuration.
    lifecycle {
     ignore_changes = [
       network, disk, sshkeys, target_node]
  }
}

#Ansible "Dynamic" Inventory File 
#TODO: Implement a more dynamic inventory file that can search and add based on input parameters
resource "local_file" "ansible_inventory" {
    filename = "${var.directory}/Inventory/inventory.ini"
    content = <<EOF
${local.ansible_inventory}
${join("\n", local.ip_list)}
EOF
}

resource "null_resource" "Module-Ansible-Execution" {
  provisioner "remote-exec" {
    inline = ["echo 'Ansible will now be able to reach this VM, and boy is it an insane VM to reach!'"]

    connection {
      type = "ssh"
      user = var.ansible_user
      private_key = file("${var.private_key_path}")
      host = "10.0.0.101" #self.ip_address df
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_CONFIG=${var.directory}/ansible-playbooks/ansible.cfg ansible-playbook -i ${var.directory}/Inventory/inventory.ini -u ${var.ansible_user} --private-key ${var.private_key_path} -e 'pub_key=${var.public_key_path}' ${var.directory}/ansible-playbooks/site.yml"
  }
}