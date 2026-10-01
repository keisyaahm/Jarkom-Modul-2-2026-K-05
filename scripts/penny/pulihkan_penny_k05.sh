#!/bin/bash
set -euo pipefail

[ "$(hostname)" = "penny" ] || {
    echo "Salah node: jalankan hanya di Penny"
    exit 1
}

export DEBIAN_FRONTEND=noninteractive
packages=()
command -v apache2ctl >/dev/null || packages+=(apache2)
command -v htpasswd >/dev/null || packages+=(apache2-utils)
command -v php-fpm8.4 >/dev/null || packages+=(php8.4-fpm)
command -v curl >/dev/null || packages+=(curl)

if ((${#packages[@]})); then
    apt-get update
    apt-get install -y "${packages[@]}"
fi

stamp=$(date +%Y%m%d-%H%M%S)
backup="/root/apache2.before-recovery-$stamp"
cp -a /etc/apache2 "$backup"
echo "Backup konfigurasi: $backup"

a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests \
    headers proxy_fcgi alias auth_basic authn_file authz_user

mkdir -p /var/www/admin /var/www/eternal

if [ ! -s /var/www/admin/index.html ]; then
    printf 'Penny Restricted Area\n' > /var/www/admin/index.html
fi

if [ ! -s /var/www/eternal/index.php ]; then
    cat > /var/www/eternal/index.php <<'PHP'
<!doctype html>
<html><body>
<h1>Eternal - Penny</h1>
<p>PHP berhasil dirender.</p>
<p>PHP Version: <?php echo PHP_VERSION; ?></p>
<p>Node: <?php echo gethostname(); ?></p>
</body></html>
PHP
fi

chmod 755 /var/www/admin /var/www/eternal
chmod 644 /var/www/admin/index.html /var/www/eternal/index.php

if [ ! -s /root/k05-prabs.htpasswd ]; then
    echo "Buat password user prabs sesuai soal No.12."
    echo "Ketik saat diminta; karakter password tidak ditampilkan."
    htpasswd -c /root/k05-prabs.htpasswd prabs
fi
install -o root -g www-data -m 640 \
    /root/k05-prabs.htpasswd /etc/apache2/.htpasswd

cat > /etc/apache2/sites-available/000-default.conf <<'CONF'
<VirtualHost *:80>
    ServerName penny.k05.com
    ServerAlias 10.66.4.2
    Redirect permanent / http://www.k05.com/
</VirtualHost>
CONF

cat > /etc/apache2/sites-available/www-k05.conf <<'CONF'
<VirtualHost *:80>
    ServerName www.k05.com
    ProxyRequests Off
    ProxyPreserveHost On
    RequestHeader set X-Real-IP "expr=%{REMOTE_ADDR}"

    ProxyPass /admin !
    Alias /admin /var/www/admin
    <Directory /var/www/admin>
        Options -Indexes
        AllowOverride None
        AuthType Basic
        AuthName "Admin Penny"
        AuthBasicProvider file
        AuthUserFile /etc/apache2/.htpasswd
        Require user prabs
    </Directory>
    <LocationMatch "^/admin(?:/|$)">
        AuthType Basic
        AuthName "Admin Penny"
        AuthBasicProvider file
        AuthUserFile /etc/apache2/.htpasswd
        Require user prabs
    </LocationMatch>

    ProxyPass /eternal !
    Alias /eternal /var/www/eternal
    <Directory /var/www/eternal>
        Options -Indexes
        AllowOverride None
        Require all granted
        DirectoryIndex index.php
        <FilesMatch "\.php$">
            SetHandler "proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost/"
        </FilesMatch>
    </Directory>

    <Proxy "balancer://vaultcluster">
        BalancerMember "http://10.66.5.4:80" route=obladi
        BalancerMember "http://10.66.5.5:80" route=desmond
        ProxySet lbmethod=byrequests
    </Proxy>
    ProxyPass / "balancer://vaultcluster/"
    ProxyPassReverse / "balancer://vaultcluster/"
</VirtualHost>
CONF

a2ensite 000-default.conf www-k05.conf

if ! apache2ctl configtest; then
    mv /etc/apache2 "/root/apache2.failed-recovery-$stamp"
    cp -a "$backup" /etc/apache2
    echo "Config gagal; konfigurasi sebelumnya dikembalikan."
    exit 1
fi

service php8.4-fpm restart
service apache2 restart

echo "===== HASIL PENNY ====="
ss -lntp | grep ':80' || true
curl -sS --max-time 5 -o /dev/null \
    -w 'eternal: HTTP %{http_code}\n' \
    -H 'Host: www.k05.com' http://127.0.0.1/eternal/ || true
curl -sS --max-time 5 -o /dev/null \
    -w 'admin tanpa login: HTTP %{http_code}\n' \
    -H 'Host: www.k05.com' http://127.0.0.1/admin/ || true
curl -sS --max-time 5 -o /dev/null \
    -w 'www root: HTTP %{http_code}\n' \
    -H 'Host: www.k05.com' http://127.0.0.1/ || true
echo "Backup: $backup"
