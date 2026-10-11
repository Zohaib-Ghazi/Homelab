#The runbook for executing the ./homelab.sh script

1. Run script
2. When prompted, enter the password accept the ssh signature
3. Install root & int ca certificates to local cert stores




#The runbook for executing hte ./teardown.sh script

1. Run the teardown script
2. Remove the root & int ca certificates from local certificates stores
    sudo rm /usr/local/share/ca-certificates/vaultroot.crt
    sudo rm /usr/local/share/ca-certificates/vaultintca.crt
    sudo rm /etc/ssl/certs/vaultroot.pem
    sudo rm /etc/ssl/certs/vaultintca.pem
3. 