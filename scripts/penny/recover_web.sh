#!/bin/bash
set -e

echo "===== RECOVERY PENNY ====="

echo "nameserver 192.168.122.1" > /etc/resolv.conf

if ! command -v apache2ctl >/dev/null 2>&1 || \
   [ ! -x /etc/init.d/php8.4-fpm ]; then

    apt-get update
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y apache2 apache2-utils php8.4-fpm curl
fi

rm -rf /etc/apache2 /etc/php /var/www

cp -a /root/persist_web/apache2 /etc/apache2
cp -a /root/persist_web/php /etc/php
cp -a /root/persist_web/www /var/www

service php8.4-fpm restart
apache2ctl configtest
service apache2 restart

update-rc.d apache2 defaults 2>/dev/null || true
update-rc.d php8.4-fpm defaults 2>/dev/null || true

cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

echo "RECOVERY PENNY OK"
