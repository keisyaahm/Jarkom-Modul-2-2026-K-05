#!/bin/bash
set -e

echo "===== RECOVERY OBLADI ====="

cat > /etc/resolv.conf <<'RES'
nameserver 192.168.122.1
RES

if ! command -v apache2ctl >/dev/null 2>&1; then
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 curl
fi

rm -rf /etc/apache2 /var/www
cp -a /root/persist_web/apache2 /etc/apache2
cp -a /root/persist_web/www /var/www

apache2ctl configtest
service apache2 restart
update-rc.d apache2 defaults 2>/dev/null || true

cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

echo "RECOVERY OBLADI OK"
