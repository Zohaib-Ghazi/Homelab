resource "null_resource" "run_certificate_request_script" {
    #count      = var.skip_certificate_provisioning == false && var.vault_cert_role != null ? 1 : 0
    #depends_on = [null_resource.wait_for_ssh]
    for_each = var.certificate_vms

    provisioner "remote-exec" {
        inline = [
            "set -e",
            "mkdir -p /tmp/vault-setup",
            "echo 'Setting up certificate request...'",
        ]
        connection {
            type        = "ssh"
            user        = var.ansible_user
            private_key = file(var.private_key_path)
            host        = each.value.ip_address
            timeout     = "300s"
        }
    }

    # Copy the certificate request script to the VM
    provisioner "file" {
        source      = "${var.directory}/ansible-playbooks/files/vault-cert-request.sh"
        destination = "/tmp/vault-setup/vault-cert-request.sh"
        connection {
            type        = "ssh"
            user        = var.ansible_user
            private_key = file(var.private_key_path)
            host        = each.value.ip_address
        }
    }

    # Execute the certificate request script with AppRole credentials
    provisioner "remote-exec" {
        inline = [
            "set -e",
            "chmod +x /tmp/vault-setup/vault-cert-request.sh",
            "export VAULT_ADDR='${var.vault_address_pki}'",
            "export APPROLE_ROLE_ID='${local.APPROLE_ROLE_ID}'",
            "export APPROLE_SECRET_ID='${local.APPROLE_SECRET_ID}'",
            "bash /tmp/vault-setup/vault-cert-request.sh '${each.value.cert_role}' '${each.value.cert_name}' '${each.value.cert_san}' '${each.value.log_file}' '${var.vault_cert_name}' '${var.vault_cert_key}'",
            "sudo update-ca-certificates",
            "sudo systemctl restart vault",
            "rm -rf /tmp/vault-setup" # Comment during troubleshooting
        ]
        connection {
            type        = "ssh"
            user        = var.ansible_user
            private_key = file(var.private_key_path)
            host        = each.value.ip_address
            timeout     = "300s"
        }
    }
}