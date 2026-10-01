#!/bin/bash
set -euo pipefail

# Ganti jika VirtualHost nomor 11 berada di file lain.
CONF="${1:-/etc/apache2/sites-available/000-default.conf}"

if [ ! -f "$CONF" ]; then
    echo "File konfigurasi tidak ditemukan: $CONF"
    exit 1
fi

COUNT=$(awk '/^[[:space:]]*<VirtualHost[[:space:]]/ {n++}
END {print n+0}' "$CONF")

if [ "$COUNT" -ne 1 ]; then
    echo "Script memerlukan file dengan tepat satu VirtualHost."
    echo "Jalankan dengan: bash /root/soal_12.sh /path/konfigurasi-penny.conf"
    exit 1
fi

apt-get update
apt-get install -y apache2-utils

a2enmod auth_basic authn_file authz_user alias proxy

mkdir -p /var/www/admin
printf '%s\n' 'Penny Restricted Area' > /var/www/admin/index.html
chmod 755 /var/www/admin
chmod 644 /var/www/admin/index.html

echo "Masukkan password prabs sesuai soal."
echo "Dokumen menuliskan: pakar_pinter_jadi_gob***"

if [ -f /etc/apache2/.htpasswd ]; then
    htpasswd /etc/apache2/.htpasswd prabs
else
    htpasswd -c /etc/apache2/.htpasswd prabs
fi

chown root:www-data /etc/apache2/.htpasswd
chmod 640 /etc/apache2/.htpasswd

BACKUP="${CONF}.bak-no12-$(date +%Y%m%d-%H%M%S)"
cp -p "$CONF" "$BACKUP"

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

# Hapus blok buatan script sebelumnya, lalu tambahkan kembali.
# Pengecualian /admin diletakkan sebelum ProxyPass umum.
awk '
/^[[:space:]]*# BEGIN SOAL12/ {skip=1; next}
/^[[:space:]]*# END SOAL12/ {skip=0; next}
skip {next}
{
    print
    if ($0 ~ /^[[:space:]]*<VirtualHost[[:space:]]/) {
        print "# BEGIN SOAL12"
        print "ProxyPass /admin !"
        print "Alias /admin /var/www/admin"
        print "<Directory /var/www/admin>"
        print "    Options -Indexes"
        print "    AllowOverride None"
        print "    AuthType Basic"
        print "    AuthName \"Admin Penny\""
        print "    AuthBasicProvider file"
        print "    AuthUserFile /etc/apache2/.htpasswd"
        print "    Require user prabs"
        print "</Directory>"
        print "<LocationMatch \"^/admin(?:/|$)\">"
        print "    AuthType Basic"
        print "    AuthName \"Admin Penny\""
        print "    AuthBasicProvider file"
        print "    AuthUserFile /etc/apache2/.htpasswd"
        print "    Require user prabs"
        print "</LocationMatch>"
        print "# END SOAL12"
    }
}
' "$CONF" > "$TMP"

cat "$TMP" > "$CONF"

if ! apache2ctl configtest; then
    cp -p "$BACKUP" "$CONF"
    echo "Konfigurasi gagal. File sebelumnya sudah dipulihkan."
    exit 1
fi

if ! service apache2 reload; then
    cp -p "$BACKUP" "$CONF"
    service apache2 reload || true
    echo "Reload gagal. File sebelumnya sudah dipulihkan."
    exit 1
fi

echo "Konfigurasi nomor 12 selesai."
echo "Backup: $BACKUP"
