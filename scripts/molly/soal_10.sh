#!/bin/bash

set -e

NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo "======================================"
echo " NOMOR 10 - CORE DYNAMIC WEB"
echo " NODE: $NODE"
echo "======================================"

if [ "$NODE" != "oblada" ] && [ "$NODE" != "molly" ]; then
    echo "ERROR: Script nomor 10 hanya untuk oblada atau molly."
    exit 1
fi

echo
echo "===== 1. INSTALL NGINX + PHP-FPM ====="
apt-get update
apt-get install -y nginx php8.4-fpm curl

echo
echo "===== 2. BUAT DIREKTORI APLIKASI ====="
mkdir -p /var/www/core

echo
echo "===== 3. BUAT HALAMAN BERANDA ====="
cat > /var/www/core/index.php <<PHP
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Core ${NODE}</title>
</head>
<body>
    <h1>Beranda Core - ${NODE}</h1>

    <p>Web dinamis berjalan menggunakan Nginx dan PHP-FPM.</p>

    <p>Node aktif: ${NODE}</p>

    <p>PHP Version: <?php echo PHP_VERSION; ?></p>

    <p>
        <a href="/profil">Buka Halaman Profil</a>
    </p>
</body>
</html>
PHP

echo
echo "===== 4. BUAT HALAMAN PROFIL ====="
cat > /var/www/core/profil.php <<PHP
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profil ${NODE}</title>
</head>
<body>
    <h1>Profil - ${NODE}</h1>

    <p>Ini adalah halaman profil pada node core ${NODE}.</p>

    <p>Halaman ini diakses melalui clean URL /profil tanpa akhiran .php.</p>

    <p>
        <a href="/">Kembali ke Beranda</a>
    </p>
</body>
</html>
PHP

echo
echo "===== 5. PERMISSION ====="
chown -R www-data:www-data /var/www/core
chmod -R 755 /var/www/core

echo
echo "===== 6. KONFIGURASI NGINX ====="
cat > /etc/nginx/sites-available/default <<CONF
server {
    listen 80;
    listen [::]:80;

    server_name ${NODE}.k05.com core.k05.com;

    root /var/www/core;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location = /profil {
        rewrite ^/profil\$ /profil.php last;
    }

    location ~ \.php\$ {
        include fastcgi_params;

        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME \$fastcgi_script_name;

        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}
CONF

echo
echo "===== 7. PASTIKAN SITE AKTIF ====="
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

echo
echo "===== 8. TEST KONFIGURASI NGINX ====="
nginx -t

echo
echo "===== 9. RESTART PHP-FPM ====="
service php8.4-fpm restart

echo
echo "===== 10. RESTART NGINX ====="
service nginx restart

sleep 2

echo
echo "===== NOMOR 10 SELESAI DI $NODE ====="
