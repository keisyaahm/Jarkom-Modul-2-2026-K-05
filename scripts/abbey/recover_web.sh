#!/bin/bash
set -e

echo "===== RECOVERY ABBEY ====="

echo "nameserver 192.168.122.1" > /etc/resolv.conf

if ! command -v nginx >/dev/null 2>&1; then
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx curl
fi

rm -rf /etc/nginx /var/www

cp -a /root/persist_web/nginx /etc/nginx
cp -a /root/persist_web/www /var/www

nginx -t
service nginx restart
update-rc.d nginx defaults 2>/dev/null || true

cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

echo "RECOVERY ABBEY OK"
