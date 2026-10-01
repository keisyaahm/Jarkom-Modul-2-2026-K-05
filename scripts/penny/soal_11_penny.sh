#!/bin/bash

set -e

NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo "======================================"
echo " NOMOR 11 - PENNY REVERSE PROXY"
echo "======================================"

if [ "$NODE" != "penny" ]; then
    echo "ERROR: Script ini hanya boleh dijalankan di Penny."
    exit 1
fi

echo
echo "===== 1. INSTALL APACHE ====="
apt-get update
apt-get install -y apache2 curl

echo
echo "===== 2. ENABLE MODULE ====="
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_byrequests
a2enmod headers

echo
echo "===== 3. BACKUP CONFIG ====="
cp -a /etc/apache2/sites-available/000-default.conf \
/root/000-default.conf.before-soal11 2>/dev/null || true

echo
echo "===== 4. CONFIG REVERSE PROXY ====="
cat > /etc/apache2/sites-available/000-default.conf <<'CONF'
<VirtualHost *:80>

    ServerName penny.k05.com
    ServerAlias www.k05.com

    ProxyRequests Off

    # Forward Host asli pengunjung
    ProxyPreserveHost On

    # Forward IP asli pengunjung
    RequestHeader set X-Real-IP "expr=%{REMOTE_ADDR}"

    <Proxy "balancer://vaultcluster">
        BalancerMember "http://10.66.5.4:80" route=obladi
        BalancerMember "http://10.66.5.5:80" route=desmond
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass "/" "balancer://vaultcluster/"
    ProxyPassReverse "/" "balancer://vaultcluster/"

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
CONF

echo
echo "===== 5. CONFIG TEST ====="
apache2ctl configtest

echo
echo "===== 6. RESTART APACHE ====="
service apache2 restart

sleep 2

echo
echo "===== 7. PROCESS APACHE ====="
pgrep -a apache2 || true

echo
echo "===== 8. PORT 80 ====="
ss -lntp | grep ':80' || true

echo
echo "===== PENNY SELESAI ====="
