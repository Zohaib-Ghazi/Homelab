output "ansible_inventory" {
  value = <<EOT
  ${local.ansible_inventory}
  %{for i, ip in local.ip_list}
  homelab-vm-${i + 1} ansible_host=${ip} ansible_user=${var.ansible_user}
  %{endfor}
  EOT
}