# poehelp.com
Path of Exile Help Website

https://github.com/certbot/certbot/blob/main/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf
```
# This file contains important security parameters. If you modify this file
# manually, Certbot will be unable to automatically provide future security
# updates. Instead, Certbot will print and log an error message with a path to
# the up-to-date file that you will need to refer to when manually updating
# this file. Contents are based on https://ssl-config.mozilla.org

ssl_session_cache shared:le_nginx_SSL:10m;
ssl_session_timeout 1440m;
ssl_session_tickets off;

ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers off;

ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
```

run.sh
```
#!/bin/sh

set -e

echo "Checking for dhparams.pem"
if [ ! -f "/vol/proxy/ssl-dhparams.pem" ]; then
  echo "Generating dhparams.pem"
  openssl dhparam -out /vol/proxy/ssl-dhparams.pem 2048
fi

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
```


certify-init.sh
```
#!/bin/sh

set -e

until nc -z proxy 80; do
    echo "Waiting for proxy..."
    sleep 5s & wait ${!}
done

echo "Getting certificate..."

certbot certonly \
    --webroot \
    --webroot-path "/vol/www/" \
    -d "$DOMAIN" \
    --email "$EMAIL" \
    --rsa-key-size 4096 \
    --agree-tos \
    --noninteractive
```
