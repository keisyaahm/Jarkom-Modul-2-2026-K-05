#!/bin/bash
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
