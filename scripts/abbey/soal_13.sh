#!/bin/bash
set -euo pipefail

[ "$(hostname)" = "abbey" ] || {
    echo "Jalankan di Abbey."
    exit 1
}

CONF="/etc/nginx/sites-available/default"
BACKUP="/root/nginx-default.before-soal13-$(date +%Y%m%d-%H%M%S)"
cp -a "$CONF" "$BACKUP"

cat > "$CONF" <<'CONF'
upstream core_backend {
    server 10.66.5.6:80;
    server 10.66.5.7:80;
}

server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name abbey.k05.com 10.66.3.2;

    return 302 http://static.k05.com$request_uri;
}

server {
    listen 80;
    listen [::]:80;
    server_name static.k05.com;

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

if ! nginx -t; then
    cp -a "$BACKUP" "$CONF"
    echo "Pemeriksaan gagal; konfigurasi sebelumnya dipulihkan."
    exit 1
fi

service nginx reload
echo "Abbey: redirect 302 ke static.k05.com sudah dipasang."
echo "Backup: $BACKUP"
