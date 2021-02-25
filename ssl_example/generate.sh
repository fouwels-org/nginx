#!/bin/ash
CONFIG="openssl.cnf"

set -e
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -outform PEM -out private.pem
openssl req -new -x509 -sha512 -days 365000 -nodes -key private.pem -out certificate.pem -config ${CONFIG}
openssl pkcs12 -export -out certificate.p12 -nokeys -passout pass:nopass -in certificate.pem
