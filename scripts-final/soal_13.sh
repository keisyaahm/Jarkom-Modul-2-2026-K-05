#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 13

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 13"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    penny)
        (

# ======================================
# SOURCE NODE : penny
# SOURCE FILE : soal_13.sh
# ======================================
# #!/bin/bash
set -euo pipefail

[ "$(hostname)" = "penny" ] || {
    echo "Jalankan di Penny."
    exit 1
}

CONF="/etc/apache2/sites-available/soal13-redirect.conf"
BACKUP="/root/backup-soal13-penny-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"
cp -a /etc/apache2/sites-available /etc/apache2/sites-enabled "$BACKUP/"

cat > "$CONF" <<'CONF'
<VirtualHost *:80>
    ServerName penny.k05.com
    ServerAlias 10.66.4.2
    Redirect permanent "/" "http://www.k05.com/"
</VirtualHost>
CONF

# Lepaskan nama nonkanonik dari VirtualHost layanan utama.
sed -i \
    's/^[[:space:]]*ServerName penny\.k05\.com[[:space:]]*$/    ServerName www.k05.com/' \
    /etc/apache2/sites-available/000-default.conf

a2ensite soal13-redirect.conf

if ! apache2ctl configtest; then
    cp -a "$BACKUP/sites-available/." /etc/apache2/sites-available/
    a2dissite soal13-redirect.conf
    echo "Pemeriksaan gagal; konfigurasi layanan dipulihkan."
    exit 1
fi

service apache2 reload
echo "Penny: redirect 301 ke www.k05.com sudah dipasang."
echo "Backup: $BACKUP"

        )
        ;;

    abbey)
        (

# ======================================
# SOURCE NODE : abbey
# SOURCE FILE : soal_13.sh
# ======================================
# #!/bin/bash
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

        )
        ;;

    *)
        echo "Soal 13 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

