#!/bin/bash
set -euo pipefail

if [ "$(hostname)" != "abbey" ]; then
    echo "Script ini hanya untuk Abbey."
    exit 1
fi

CONF="/etc/nginx/sites-available/default"
BACKUP="/root/nginx-default.before-soal15-$(date +%Y%m%d-%H%M%S)"

test -f "$CONF" || {
    echo "Config Nginx tidak ditemukan."
    exit 1
}

echo "======================================"
echo " NOMOR 15 - ABBEY /orion"
echo "======================================"

echo
echo "===== BUAT DIREKTORI ORION ====="

mkdir -p /var/www/orion

cat > /var/www/orion/index.html <<'HTML'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Orion</title>
</head>
<body>
    <h1>Orion - Abbey</h1>
    <p>Konten ini dilayani secara statis oleh Nginx.</p>
</body>
</html>
HTML

chown -R www-data:www-data /var/www/orion
chmod 755 /var/www/orion
chmod 644 /var/www/orion/index.html

cp -a "$CONF" "$BACKUP"

echo
echo "===== TAMBAHKAN LOCATION ORION ====="

sed -i '/# BEGIN SOAL15 ORION/,/# END SOAL15 ORION/d' "$CONF"

TMP=$(mktemp)

awk '
BEGIN {
    in_static=0
    inserted=0
}
{
    if ($0 ~ /server_name[[:space:]]+static\.k05\.com;/) {
        in_static=1
    }

    if (in_static && !inserted &&
        $0 ~ /^[[:space:]]*location[[:space:]]+\/[[:space:]]*\{/) {

        print "    # BEGIN SOAL15 ORION"
        print "    location = /orion {"
        print "        return 301 /orion/;"
        print "    }"
        print ""
        print "    location /orion/ {"
        print "        alias /var/www/orion/;"
        print "        index index.html;"
        print "    }"
        print "    # END SOAL15 ORION"
        print ""

        inserted=1
    }

    print
}
END {
    if (!inserted)
        exit 2
}
' "$CONF" > "$TMP" || {
    echo "ERROR: location / pada static.k05.com tidak ditemukan."
    rm -f "$TMP"
    exit 1
}

cat "$TMP" > "$CONF"
rm -f "$TMP"

echo
echo "===== NGINX TEST ====="

if ! nginx -t; then
    cp -a "$BACKUP" "$CONF"
    echo "Konfigurasi gagal. Backup dipulihkan."
    exit 1
fi

echo
echo "===== RELOAD NGINX ====="
service nginx reload

echo
echo "===== TEST ORION ====="

curl -s -o /dev/null -w "HTTP %{http_code}\n" \
-H 'Host: static.k05.com' \
http://127.0.0.1/orion/

curl -s \
-H 'Host: static.k05.com' \
http://127.0.0.1/orion/ \
| grep -E 'Orion|statis'

echo
echo "===== SELESAI ====="
echo "Backup: $BACKUP"
