#!/bin/bash

set -e

NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo " NOMOR 11 - ABBEY REVERSE PROXY"

if [ "$NODE" != "abbey" ]; then
    echo "ERROR: Script ini hanya boleh dijalankan di Abbey."
    exit 1
fi

echo
echo "===== 1. INSTALL NGINX ====="
apt-get update
apt-get install -y nginx curl

echo
echo "===== 2. BACKUP CONFIG ====="
cp -a /etc/nginx/sites-available/default \
/root/nginx-default.before-soal11 2>/dev/null || true

echo
echo "===== 3. CONFIG REVERSE PROXY ====="
cat > /etc/nginx/sites-available/default <<'CONF'
upstream core_backend {
    server 10.66.5.6:80;
    server 10.66.5.7:80;
}

server {
    listen 80;
    listen [::]:80;

    server_name abbey.k05.com static.k05.com;

    location / {
        proxy_pass http://core_backend;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}
CONF

echo
echo "===== 4. PASTIKAN SITE AKTIF ====="
ln -sf /etc/nginx/sites-available/default \
/etc/nginx/sites-enabled/default

echo
echo "===== 5. CONFIG TEST ====="
nginx -t

echo
echo "===== 6. RESTART NGINX ====="
service nginx restart

sleep 2

echo
echo "===== 7. PROCESS NGINX ====="
pgrep -a nginx || true

echo
echo "===== 8. PORT 80 ====="
ss -lntp | grep ':80' || true

echo
echo "===== ABBEY SELESAI ====="
