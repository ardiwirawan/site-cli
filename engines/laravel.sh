#!/bin/bash
APP_NAME=$1
DOMAIN=$2
APP_PATH=$3
ENABLE_SSL=$4
SSL_EMAIL=$5

PHP_VERSION="8.2"
TPL_DIR="$(dirname "$0")/../templates/nginx"

mkdir -p "$APP_PATH/public"

CONF_FILE="/etc/nginx/sites-available/$APP_NAME.conf"

sed \
  -e "s/{{DOMAIN}}/$DOMAIN/g" \
  -e "s#{{ROOT}}#$APP_PATH/public#g" \
  -e "s/{{PHP}}/$PHP_VERSION/g" \
  "$TPL_DIR/laravel.conf.tpl" > "$CONF_FILE"

ln -s "$CONF_FILE" /etc/nginx/sites-enabled/

# Generate nginx config (HTTP first)
sed \
  -e "s/{{DOMAIN}}/$DOMAIN/g" \
  -e "s#{{ROOT}}#$APP_PATH/public#g" \
  -e "s/{{PHP}}/$PHP_VERSION/g" \
  "$TPL_DIR/laravel.conf.tpl" > "$CONF_FILE"

ln -sf "$CONF_FILE" /etc/nginx/sites-enabled/

echo "Testing nginx config"
nginx -t
systemctl reload nginx

# SSL
if [[ "$ENABLE_SSL" == "y" || "$ENABLE_SSL" == "Y" ]]; then
  echo "Requesting SSL for $DOMAIN (email: $SSL_EMAIL)"

  certbot --nginx \
    -d "$DOMAIN" \
    --non-interactive \
    --agree-tos \
    -m "$SSL_EMAIL" \
    || echo "Generate SSL gagal, site tetap HTTP"
fi

echo "Laravel site ready"
