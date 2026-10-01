#!/bin/bash
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
