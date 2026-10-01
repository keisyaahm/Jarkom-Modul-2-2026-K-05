#!/bin/bash
set -euo pipefail

if [ "$(hostname)" != "penny" ]; then
    echo "Script ini hanya untuk Penny."
    exit 1
fi

CONF="/etc/apache2/sites-available/000-default.conf"
BACKUP="/root/000-default.before-soal15-$(date +%Y%m%d-%H%M%S)"

test -f "$CONF" || {
    echo "Config tidak ditemukan: $CONF"
    exit 1
}

echo "======================================"
echo " NOMOR 15 - PENNY /eternal"
echo "======================================"

echo
echo "===== INSTALL PHP-FPM ====="
apt-get update
apt-get install -y php8.4-fpm

echo
echo "===== ENABLE MODULE ====="
a2enmod proxy_fcgi setenvif alias

echo
echo "===== START PHP-FPM ====="
service php8.4-fpm restart

test -S /run/php/php8.4-fpm.sock || {
    echo "Socket PHP-FPM tidak ditemukan."
    ls -lah /run/php/ || true
    exit 1
}

echo
echo "===== BUAT DIREKTORI ETERNAL ====="
mkdir -p /var/www/eternal

cat > /var/www/eternal/index.php <<'PHP'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Eternal</title>
</head>
<body>
    <h1>Eternal - Penny</h1>
    <p>PHP berhasil dirender.</p>
    <p>PHP Version: <?php echo PHP_VERSION; ?></p>
    <p>Node: <?php echo gethostname(); ?></p>
</body>
</html>
PHP

chown -R www-data:www-data /var/www/eternal
chmod 755 /var/www/eternal
chmod 644 /var/www/eternal/index.php

cp -a "$CONF" "$BACKUP"

sed -i '/# BEGIN SOAL15 ETERNAL/,/# END SOAL15 ETERNAL/d' "$CONF"

TMP=$(mktemp)

awk '
{
    print

    if ($0 ~ /^[[:space:]]*<VirtualHost[[:space:]]/) {
        print "    # BEGIN SOAL15 ETERNAL"
        print "    ProxyPass /eternal !"
        print "    Alias /eternal /var/www/eternal"
        print ""
        print "    <Directory /var/www/eternal>"
        print "        Options -Indexes"
        print "        AllowOverride None"
        print "        Require all granted"
        print ""
        print "        <FilesMatch \"\\.php$\">"
        print "            SetHandler \"proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost/\""
        print "        </FilesMatch>"
        print "    </Directory>"
        print "    # END SOAL15 ETERNAL"
    }
}
' "$CONF" > "$TMP"

cat "$TMP" > "$CONF"
rm -f "$TMP"

echo
echo "===== CONFIG TEST ====="

if ! apache2ctl configtest; then
    cp -a "$BACKUP" "$CONF"
    echo "Konfigurasi gagal. Backup dipulihkan."
    exit 1
fi

echo
echo "===== RESTART SERVICE ====="
service php8.4-fpm restart
service apache2 restart

echo
echo "===== TEST LOKAL ====="

curl -s -o /dev/null -w "HTTP %{http_code}\n" \
-H 'Host: www.k05.com' \
http://127.0.0.1/eternal/

curl -s \
-H 'Host: www.k05.com' \
http://127.0.0.1/eternal/ \
| grep -E 'Eternal|PHP berhasil|PHP Version|Node'

echo
echo "===== SELESAI ====="
echo "Backup: $BACKUP"
