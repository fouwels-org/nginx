#!/bin/ash
CONFIG="openssl.cnf"
KEYS="../config_example/nginx/keys"

set -e
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -outform PEM -out ${KEYS}/private.pem
openssl req -new -x509 -sha512 -days 365000 -nodes -key ${KEYS}/private.pem -out ${KEYS}/certificate.pem -config ${CONFIG}
openssl pkcs12 -export -out ${KEYS}/certificate.p12 -nokeys -passout pass:nopass -in ${KEYS}/certificate.pem
openssl dhparam -out ${KEYS}/dhparam.pem 3072
