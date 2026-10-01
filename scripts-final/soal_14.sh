#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 14

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 14"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    obladi)
        (

# ======================================
# SOURCE NODE : obladi
# SOURCE FILE : soal_14.sh
# ======================================
# #!/bin/bash
set -euo pipefail

NODE=$(hostname)
case "$NODE" in
    obladi|desmond) ;;
    *) echo "Script ini untuk Obladi atau Desmond."; exit 1 ;;
esac

SITE="/etc/apache2/sites-available/000-default.conf"
test -f "$SITE"

BACKUP="/root/backup-soal14-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"
cp -a "$SITE" "$BACKUP/"

a2enmod remoteip

cat > /etc/apache2/conf-available/soal14-realip.conf <<'CONF'
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 10.66.4.2

LogFormat "%a peer=%{c}a %l %u %t \"%r\" %>s %b" soal14_realip
CONF

# Gunakan format yang mencatat IP klien dan IP koneksi proxy.
sed -i -E \
    's@^[[:space:]]*CustomLog[[:space:]].*@    CustomLog ${APACHE_LOG_DIR}/access.log soal14_realip@' \
    "$SITE"

a2enconf soal14-realip

if ! apache2ctl configtest; then
    cp -a "$BACKUP/000-default.conf" "$SITE"
    a2disconf soal14-realip
    echo "Konfigurasi gagal; site sebelumnya dipulihkan."
    exit 1
fi

service apache2 reload
echo "Nomor 14 aktif pada $NODE."
echo "Log: /var/log/apache2/access.log"

        )
        ;;

    desmond)
        (

# ======================================
# SOURCE NODE : desmond
# SOURCE FILE : soal_14.sh
# ======================================
# #!/bin/bash
set -euo pipefail

NODE=$(hostname)
case "$NODE" in
    obladi|desmond) ;;
    *) echo "Script ini untuk Obladi atau Desmond."; exit 1 ;;
esac

SITE="/etc/apache2/sites-available/000-default.conf"
test -f "$SITE"

BACKUP="/root/backup-soal14-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"
cp -a "$SITE" "$BACKUP/"

a2enmod remoteip

cat > /etc/apache2/conf-available/soal14-realip.conf <<'CONF'
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 10.66.4.2

LogFormat "%a peer=%{c}a %l %u %t \"%r\" %>s %b" soal14_realip
CONF

# Gunakan format yang mencatat IP klien dan IP koneksi proxy.
sed -i -E \
    's@^[[:space:]]*CustomLog[[:space:]].*@    CustomLog ${APACHE_LOG_DIR}/access.log soal14_realip@' \
    "$SITE"

a2enconf soal14-realip

if ! apache2ctl configtest; then
    cp -a "$BACKUP/000-default.conf" "$SITE"
    a2disconf soal14-realip
    echo "Konfigurasi gagal; site sebelumnya dipulihkan."
    exit 1
fi

service apache2 reload
echo "Nomor 14 aktif pada $NODE."
echo "Log: /var/log/apache2/access.log"

        )
        ;;

    oblada)
        (

# ======================================
# SOURCE NODE : oblada
# SOURCE FILE : soal_14.sh
# ======================================
# #!/bin/bash
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

        )
        ;;

    molly)
        (

# ======================================
# SOURCE NODE : molly
# SOURCE FILE : soal_14.sh
# ======================================
# #!/bin/bash
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

        )
        ;;

    *)
        echo "Soal 14 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

