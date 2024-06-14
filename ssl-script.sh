#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -o errexit
set -o nounset
set -o pipefail

# Define the script root and temporary directory for certificates
SCRIPT_ROOT=$(dirname ${BASH_SOURCE})/..
TMP_DIR="/tmp/vpa-certs"

# Create the temporary directory for certificates
mkdir -p ${TMP_DIR}

# Create the OpenSSL configuration file for CA
cat > ${TMP_DIR}/vpa-openssl.cnf <<EOF
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
x509_extensions = v3_ca
prompt = no

[ req_distinguished_name ]
C = US
ST = State
L = City
O = Organization
OU = Organizational Unit
CN = vpa_webhook_ca

[ v3_ca ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer:always
basicConstraints = CA:true
EOF

# Generate CA certificate
openssl req -x509 -newkey rsa:2048 -keyout ${TMP_DIR}/ca.key -out ${TMP_DIR}/ca.crt -days 365 -nodes -config ${TMP_DIR}/vpa-openssl.cnf

# Create the OpenSSL configuration file for server certificate
cat > ${TMP_DIR}/vpa-server-openssl.cnf <<EOF
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[ req_distinguished_name ]
C = US
ST = State
L = City
O = Organization
OU = Organizational Unit
CN = vpa_webhook

[ v3_req ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = vpa-webhook.kube-system.svc
DNS.2 = vpa-webhook.kube-system
EOF

# Generate server certificate
openssl req -new -newkey rsa:2048 -keyout ${TMP_DIR}/server.key -out ${TMP_DIR}/server.csr -nodes -config ${TMP_DIR}/vpa-server-openssl.cnf
openssl x509 -req -in ${TMP_DIR}/server.csr -CA ${TMP_DIR}/ca.crt -CAkey ${TMP_DIR}/ca.key -CAcreateserial -out ${TMP_DIR}/server.crt -days 365 -extensions v3_req -extfile ${TMP_DIR}/vpa-server-openssl.cnf

# Create Kubernetes secret with the generated certificates
kubectl create secret tls vpa-tls-certs --cert=${TMP_DIR}/server.crt --key=${TMP_DIR}/server.key -n kube-system

# Run the original VPA process YAMLs script
$SCRIPT_ROOT/hack/vpa-up.sh create $*
