#!/bin/bash
set -euo pipefail

NODE=$(hostname)
case "$NODE" in
    oblada|molly) ;;
    *) echo "Script ini untuk Oblada atau Molly."; exit 1 ;;
esac

SITE="/etc/nginx/sites-available/default"
CONF="/etc/nginx/conf.d/soal14-realip.conf"
test -f "$SITE"

# Pastikan Nginx mendukung modul real IP.
if ! nginx -V 2>&1 | grep -q -- '--with-http_realip_module'; then
    echo "Nginx belum memiliki http_realip_module."
    exit 1
fi

BACKUP="/root/backup-soal14-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"
cp -a "$SITE" "$BACKUP/default"

HAD_CONF=0
if [ -f "$CONF" ]; then
    cp -a "$CONF" "$BACKUP/soal14-realip.conf"
    HAD_CONF=1
fi

cat > "$CONF" <<'CONF'
set_real_ip_from 10.66.3.2;
real_ip_header X-Real-IP;
real_ip_recursive off;

log_format soal14_realip
    '$remote_addr peer=$realip_remote_addr '
    '[$time_local] "$request" $status $body_bytes_sent';
CONF

sed -i -E \
    's@^[[:space:]]*access_log[[:space:]].*@    access_log /var/log/nginx/access.log soal14_realip;@' \
    "$SITE"

if ! nginx -t; then
    cp -a "$BACKUP/default" "$SITE"

    if [ "$HAD_CONF" -eq 1 ]; then
        cp -a "$BACKUP/soal14-realip.conf" "$CONF"
    else
        rm -f "$CONF"
    fi

    echo "Konfigurasi gagal; file sebelumnya dipulihkan."
    exit 1
fi

service nginx reload
echo "Nomor 14 aktif pada $NODE."
echo "Log: /var/log/nginx/access.log"
