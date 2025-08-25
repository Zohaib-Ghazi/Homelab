#!/bin/bash

src_ca_path="/usr/local/share/ca-certificates/vault-cert.crt"
dst_ca_path="/usr/local/share/ca-certificates/PROD-RootCA.crt"
dst_Intca_path="/usr/local/share/ca-certificates/PROD-IntCA.crt"
#ssh_path="-i ~/.ssh/ansible"
ssh_creds_RtCA="s_admin@10.0.0.101"
ssh_creds_IntCA="s_admin@10.0.0.102"

echo "Step 1: Removing old entries from known_hosts file for '10.0.0.101'"
echo
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.101"
echo
echo "Step 2: Retrieving self-signed root cert from RootCA" 
echo
sudo scp -i ~/.ssh/ansible $ssh_creds_RtCA:$src_ca_path $dst_ca_path
echo
echo "Step 3: Removing old entries from known_hosts file for '10.0.0.102'"
echo
ssh-keygen -f "/home/zohaib/.ssh/known_hosts" -R "10.0.0.102"
echo
echo "Step 4: Retrieving self-signed root cert from IntCA" 
echo
sudo scp -i ~/.ssh/ansible $ssh_creds_IntCA:$src_ca_path $dst_ca_path
echo
echo "Step 5: Updating CA certificates on local machine"
echo
sudo update-ca-certificates