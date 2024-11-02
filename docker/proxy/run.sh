#!/bin/bash

'''
This script is used to generate the dhparams.pem file and check for the fullchain.pem file.
'''

set -e

echo "Checking for dhparams.pem"
if [ ! -f "/vol/nginx/ssl-dhparams.pem" ]; then
  echo "Generating dhparams.pem"
  openssl dhparam -out /vol/proxy/ssl-dhparams.pem 2048
fi

# avoid replacing these with envsubst
export host=\$host
export request_uri=\$request_uri

echo "Check for fullchain.pem"
if [ ! -f "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" ]; then
  echo "No SSL certificate found, enabling HTTP only"
  envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
else
  echo "SSL cerf exists, enabling HTTPs"
  envsubst < /etc/nginx/default-ssl.conf.tpl > /etc/nginx/conf.d/default.conf
fi

nginx -g 'daemon off;'
