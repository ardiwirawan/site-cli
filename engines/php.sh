#!/bin/bash
APP_NAME=$1
DOMAIN=$2
APP_PATH=$3
ENABLE_SSL=$4
SSL_EMAIL=$5

PHP_VERSION="8.2"
ENGINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$(cd "$ENGINE_DIR/.." && pwd)"
TPL_DIR="$SCRIPT_DIR/templates/nginx"


mkdir -p "$APP_PATH"

CONF_FILE="/etc/nginx/sites-available/$APP_NAME.conf"


# Generate nginx config (HTTP first)
sed \
  -e "s/{{DOMAIN}}/$DOMAIN/g" \
  -e "s#{{ROOT}}#$APP_PATH#g" \
  -e "s/{{PHP}}/$PHP_VERSION/g" \
  "$TPL_DIR/php.conf.tpl" > "$CONF_FILE"

ln -sf "$CONF_FILE" /etc/nginx/sites-enabled/

if [ ! -s "$CONF_FILE" ]; then
  echo "❌ ERROR: nginx config empty. Aborting."
  exit 1
fi

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
    || echo "SSL gagal, site tetap HTTP"
fi

echo "PHP site ready"
