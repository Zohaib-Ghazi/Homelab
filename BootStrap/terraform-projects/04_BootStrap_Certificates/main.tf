resource "null_resource" "run_certificate_request_script" {
    #count      = var.skip_certificate_provisioning == false && var.vault_cert_role != null ? 1 : 0
    #depends_on = [null_resource.wait_for_ssh]

    provisioner "remote-exec" {
        inline = [
            "set -e",
            "mkdir -p /tmp/vault-setup",
            "echo 'Setting up certificate request...'",
        ]
        connection {
            type        = "ssh"
            user        = var.ansible_user
            private_key = file("${var.private_key_path}")
            host        = "${var.ip_address}"
            timeout     = "300s"
        }
    }

    # Copy the certificate request script to the VM
    provisioner "file" {
        source      = "${var.directory}/terraform-projects/00_Scripts/vault-cert-request.sh"
        destination = "/tmp/vault-setup/vault-cert-request.sh"
        connection {
            type        = "ssh"
            user        = var.ansible_user
            private_key = file("${var.private_key_path}")
            host        = "${var.ip_address}"
        }
    }

    # Execute the certificate request script with AppRole credentials
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/vault-setup/vault-cert-request.sh",
            "export VAULT_ADDR='${var.vault_address}'",
            "export APPROLE_ROLE_ID='${var.appRole_RoleID}'",
            "export APPROLE_SECRET_ID='${var.appRole_SecretID}'",
            "bash /tmp/vault-setup/vault-cert-request.sh '${var.vault_cert_role}' '${var.vm_name_suffix}' '${var.vault_cert_san}'",
            "rm -rf /tmp/vault-setup"
        ]
        connection {
            type        = "ssh"
            user        = var.ansible_user
            private_key = file("${var.private_key_path}")
            host        = "${var.ip_address}"
            timeout     = "300s"
        }
    }
}