#Output the vname suffix
output "vm_name_suffix" {
  description = "VM name suffix"
  value = proxmox_vm_qemu.TF_VM.name
  #value = var.vm_name_suffix
}

#Output the VM ID
output "vm_id" {
  description = "VM ID"
  value = proxmox_vm_qemu.TF_VM.vmid
}

#Output the IP address
output "ip_address" {
  description = "IP address"
  value = proxmox_vm_qemu.TF_VM.ipconfig0
}

#Output the DNS Config
output "dns_config" {
  description = "DNS Configuration"
  value = proxmox_vm_qemu.TF_VM.nameserver
}

#Using local_file to write the output to a file
resource "local_file" "vault_output" {
  #filename = "${var.ansible_vault_folderpath}rootca_vault_output.json"
  filename = "rootca_vault_output.json"
  content  = <<EOT
  VM Name Suffix: ${var.vm_name_suffix}
  IP Address: ${var.ip_address}
  EOT
}