#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <src_ca_path> <dst_ca_path> <host_ip> <ssh_username>"
    exit 1
fi

src_ca_path="$1"
dst_ca_path="$2"
host_ip="$3"
ssh_username="$4"

echo "Step 1: Removing old entries from known_hosts file for '$host_ip'"
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "$host_ip"
echo

echo "Step 2: Retrieving self-signed cert from host"
sudo scp -i ~/.ssh/ansible "${ssh_username}@${host_ip}:${src_ca_path}" "${dst_ca_path}"
echo

echo "Step 3: Updating CA certificates on local machine"
sudo update-ca-certificates
