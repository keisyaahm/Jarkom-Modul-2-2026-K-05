NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo "===== NOMOR 10: CONFIGURING NGINX + PHP-FPM ON $NODE ====="
NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo "===== NOMOR 10: CONFIGURING NGINX + PHP-FPM ON $NODE ====="

# 1. Update & Install Nginx + PHP-FPM
apt-get update
apt-get install -y nginx php-fpm php-cli

# 2. Cari socket PHP-FPM otomatis
PHP_SOCK=$(find /run/php -name 'php*-fpm.sock' | head -n1)

# 3. Buat folder web & file PHP
mkdir -p /var/www/core

cat > /var/www/core/index.php <<PHP
<?php
echo "Beranda Core - Node: $NODE\n";
?>
PHP

cat > /var/www/core/profil.php <<PHP
<?php
echo "Profil Core - Node: $NODE\n";
?>
PHP

# 4. Konfigurasi VirtualHost Nginx dengan Clean URL /profil
cat > /etc/nginx/sites-available/default <<CONF
server {
    listen 80;
    server_name ${NODE}.k05.com core.k05.com;

    root /var/www/core;
    index index.php index.html;

    location = /profil {
        try_files /profil.php =404;
    }

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:${PHP_SOCK};
    }
}
CONF

# 5. Restart Services
nginx -t
service php*-fpm restart 2>/dev/null || true
service nginx restart

echo "===== VERIFIKASI LOKAL $NODE ====="
curl -s http://localhost/
curl -s http://localhost/profil
