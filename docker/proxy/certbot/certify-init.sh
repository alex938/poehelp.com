#!/bin/bash

'''
checks if the DOMAIN and EMAIL environment variables are set, waits for the proxy to be available, and then uses certbot to obtain a certificate for the specified domain.
'''

set -e

# Check if DOMAIN and EMAIL are set
if [ -z "$DOMAIN" ]; then
    echo "Error: DOMAIN environment variable is not set."
    exit 1
fi

if [ -z "$EMAIL" ]; then
    echo "Error: EMAIL environment variable is not set."
    exit 1
fi

until nc -z proxy 80; do
    echo "Waiting for proxy to be available"
    sleep 5s & wait ${!}
done

echo "Getting certificate..."
if ! certbot certonly \
    --webroot \
    --webroot-path "/vol/www/" \
    -d "$DOMAIN" \
    --email "$EMAIL" \
    --rsa-key-size 4096 \
    --agree-tos \
    --noninteractive; then
    echo "Error: certbot failed to obtain the certificate."
    exit 1
fi

echo "Certificate obtained successfully."