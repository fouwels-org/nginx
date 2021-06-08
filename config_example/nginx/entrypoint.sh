#!/bin/ash
CONFIG="/etc/nginx/entrypoint/openssl.cnf"
KEYS="/home/nginx/keys"
set -e

if [ ! -f /keys/private.pem ]; then
    echo "${KEYS}/private.pem not found, generating"
    set -x
    openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -outform PEM -out ${KEYS}/private.pem
    chmod 400 /keys/private.pem
    set +x
fi

if [ ! -f /keys/certificate.pem ]; then
    echo "${KEYS}/certificate.pem not found, generating"
    set -x
    openssl req -new -x509 -sha512 -days 365000 -nodes -key${KEYS}/private.pem -out ${KEYS}/certificate.pem -config ${CONFIG}
    openssl pkcs12 -export -out ${KEYS}/certificate.p12 -nokeys -passout pass:nopass -in ${KEYS}/certificate.pem
    chmod 444 ${KEYS}/certificate.pem
    chmod 444 ${KEYS}/certificate.p12
    set +x
fi

echo "Host certificate "
cat ${KEYS}/certificate.pem

echo "Entrypoint complete, handing over"
exec "$@"