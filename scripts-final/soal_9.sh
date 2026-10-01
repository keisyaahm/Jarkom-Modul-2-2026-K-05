#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 9

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 9"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    obladi)
        (

# ======================================
# SOURCE NODE : obladi
# SOURCE FILE : soal_9.sh
# ======================================
# #!/bin/bash

set -e

NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo "======================================"
echo " NOMOR 9 - STATIC WEB VAULT"
echo " NODE: $NODE"
echo "======================================"

if [ "$NODE" != "obladi" ] && [ "$NODE" != "desmond" ]; then
    echo "ERROR: Script hanya untuk obladi atau desmond."
    exit 1
fi

echo
echo "===== 1. SET RESOLVER ====="
cat > /etc/resolv.conf <<RESOLV
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RESOLV

echo
echo "===== 2. TEST DNS ====="
getent hosts deb.debian.org

echo
echo "===== 3. INSTALL APACHE ====="
apt-get update
apt-get install -y apache2 curl

echo
echo "===== 4. GLOBAL SERVERNAME ====="
cat > /etc/apache2/conf-available/servername.conf <<CONF
ServerName ${NODE}.k05.com
CONF

a2enconf servername >/dev/null

echo
echo "===== 5. BUAT DIREKTORI ARSIP ====="
mkdir -p /var/www/html/arsip

echo "File Arsip dari Node: $NODE" \
> /var/www/html/arsip/${NODE}_file.txt

echo "Dokumen Rahasia Vault $NODE" \
> /var/www/html/arsip/secret.txt

echo
echo "===== 6. CONFIG APACHE ====="
cat > /etc/apache2/sites-available/000-default.conf <<CONF
<VirtualHost *:80>

    ServerName ${NODE}.k05.com
    ServerAlias vault.k05.com

    DocumentRoot /var/www/html

    <Directory /var/www/html/arsip>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
CONF

echo
echo "===== 7. CONFIG TEST ====="
apache2ctl configtest

echo
echo "===== 8. RESTART APACHE ====="
service apache2 restart

sleep 2

echo
echo "===== 9. VERIFY PROCESS ====="
pgrep -a apache2

echo
echo "===== 10. VERIFY PORT ====="
ss -lntp | grep ':80'

echo
echo "===== 11. VERIFY HTTP ====="
curl -s -o /dev/null \
-w "HTTP %{http_code}\n" \
"http://${NODE}.k05.com/arsip/"

echo
echo "===== 12. VERIFY SECRET ====="
curl -s "http://${NODE}.k05.com/arsip/secret.txt"

echo
echo
echo "===== NOMOR 9 SELESAI DI $NODE ====="

        )
        ;;

    desmond)
        (

# ======================================
# SOURCE NODE : desmond
# SOURCE FILE : soal_9.sh
# ======================================
# #!/bin/bash

set -e

NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo "======================================"
echo " NOMOR 9 - STATIC WEB VAULT"
echo " NODE: $NODE"
echo "======================================"

if [ "$NODE" != "obladi" ] && [ "$NODE" != "desmond" ]; then
    echo "ERROR: Script hanya untuk obladi atau desmond."
    exit 1
fi

echo
echo "===== 1. SET RESOLVER ====="
cat > /etc/resolv.conf <<RESOLV
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RESOLV

echo
echo "===== 2. TEST DNS ====="
getent hosts deb.debian.org

echo
echo "===== 3. INSTALL APACHE ====="
apt-get update
apt-get install -y apache2 curl

echo
echo "===== 4. GLOBAL SERVERNAME ====="
cat > /etc/apache2/conf-available/servername.conf <<CONF
ServerName ${NODE}.k05.com
CONF

a2enconf servername >/dev/null

echo
echo "===== 5. BUAT DIREKTORI ARSIP ====="
mkdir -p /var/www/html/arsip

echo "File Arsip dari Node: $NODE" \
> /var/www/html/arsip/${NODE}_file.txt

echo "Dokumen Rahasia Vault $NODE" \
> /var/www/html/arsip/secret.txt

echo
echo "===== 6. CONFIG APACHE ====="
cat > /etc/apache2/sites-available/000-default.conf <<CONF
<VirtualHost *:80>

    ServerName ${NODE}.k05.com
    ServerAlias vault.k05.com

    DocumentRoot /var/www/html

    <Directory /var/www/html/arsip>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
CONF

echo
echo "===== 7. CONFIG TEST ====="
apache2ctl configtest

echo
echo "===== 8. RESTART APACHE ====="
service apache2 restart

sleep 2

echo
echo "===== 9. VERIFY PROCESS ====="
pgrep -a apache2

echo
echo "===== 10. VERIFY PORT ====="
ss -lntp | grep ':80'

echo
echo "===== 11. VERIFY HTTP ====="
curl -s -o /dev/null \
-w "HTTP %{http_code}\n" \
"http://${NODE}.k05.com/arsip/"

echo
echo "===== 12. VERIFY SECRET ====="
curl -s "http://${NODE}.k05.com/arsip/secret.txt"

echo
echo
echo "===== NOMOR 9 SELESAI DI $NODE ====="

        )
        ;;

    *)
        echo "Soal 9 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

