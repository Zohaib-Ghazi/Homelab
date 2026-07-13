#!/bin/bash
# pass the name of the cert as the first argument to the script, common name as second argument, ip_sans as third, and TTL in seconds as fourth. Example: `./create-server-certs.sh grafana docker01.home 192.168.1.80 31556952`
set -eu
echo Creating cert for $1
echo Common name: $2
echo IP Sans: $3
echo TTL: $4
#source ./env-vars.sh # missing script
mkdir -p output/$1
vault write -format=json pki-int-ca/issue/IntCA-Issuing-Role ttl=$4 common_name="$2" ip_sans="$3" > output/$1.json
cat output/$1.json | jq -r '.data.certificate' > output/$1/$1_cert.pem
cat output/$1.json | jq -r '.data.private_key' > output/$1/$1_key.pem
cat output/$1.json | jq -r '.data.issuing_ca' > output/$1/ca.pem
cat output/$1.json | jq -r '.data.ca_chain[]' > output/$1/ca_chain.pem