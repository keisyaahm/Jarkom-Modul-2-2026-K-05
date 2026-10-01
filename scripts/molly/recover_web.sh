#!/bin/bash
set -e

echo "===== RECOVERY MOLLY ====="

echo "nameserver 192.168.122.1" > /etc/resolv.conf

if ! command -v nginx >/dev/null 2>&1 || \
   [ ! -x /etc/init.d/php8.4-fpm ]; then

    apt-get update
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y nginx php8.4-fpm curl
fi

rm -rf /etc/nginx /etc/php /var/www

cp -a /root/persist_web/nginx /etc/nginx
cp -a /root/persist_web/php /etc/php
cp -a /root/persist_web/www /var/www

service php8.4-fpm restart
nginx -t
service nginx restart

update-rc.d nginx defaults 2>/dev/null || true
update-rc.d php8.4-fpm defaults 2>/dev/null || true

cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

echo "RECOVERY MOLLY OK"
