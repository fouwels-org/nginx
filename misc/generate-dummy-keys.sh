#!/bin/ash

# SPDX-FileCopyrightText: 2021 Belcan Advanced Solution
# SPDX-FileCopyrightText: 2021 Kaelan Thijs Fouwels <kaelan.thijs@fouwels.com>
#
# SPDX-License-Identifier: MIT

# Generate Dummy Keys

CONFIG="openssl.cnf"
KEYS="../config_example/nginx/keys"

set -e
mkdir -p $KEYS

# Generate the private key
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -outform PEM -out ${KEYS}/private.pem
chmod 666 ${KEYS}/private.pem

# Generate the certificate
openssl req -new -x509 -sha512 -days 365000 -nodes -key ${KEYS}/private.pem -out ${KEYS}/certificate.pem -config ${CONFIG}
chmod 666 ${KEYS}/certificate.pem

# Export certificate chain
openssl pkcs12 -export -out ${KEYS}/certificate.p12 -nokeys -passout pass:nopass -in ${KEYS}/certificate.pem
chmod 666 ${KEYS}/certificate.p12

# Generate dhparam for TLS 1.2
openssl dhparam -out ${KEYS}/dhparam.pem 3072
chmod 666 ${KEYS}/dhparam.pem