#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 7

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 7"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    alpha)
        (

# ======================================
# SOURCE NODE : alpha
# SOURCE FILE : soal_7_client_check.sh
# ======================================
# #!/bin/bash

NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo "======================================"
echo " NOMOR 7 - CLIENT CHECK $NODE"
echo "======================================"

echo
echo "===== 1. HOSTNAME ====="
hostname

echo
echo "===== 2. RESOLVER ====="
cat /etc/resolv.conf

echo
echo "===== 3. VAULT ====="
dig vault.k05.com A +short

echo
echo "===== 4. CORE ====="
dig core.k05.com A +short

echo
echo "===== 5. WWW CNAME ====="
dig www.k05.com CNAME +short

echo
echo "===== 6. STATIC CNAME ====="
dig static.k05.com CNAME +short

echo
echo "===== 7. WWW TARGET IP ====="
dig penny.k05.com A +short

echo
echo "===== 8. STATIC TARGET IP ====="
dig abbey.k05.com A +short

echo
echo "===== 9. PRAB SOA ====="
dig @10.66.5.2 k05.com SOA +short

echo
echo "===== 10. TEDD SOA ====="
dig @10.66.5.3 k05.com SOA +short

echo
echo "===== 11. DNS SERVER USED ====="
dig core.k05.com A | grep 'SERVER:'

        )
        ;;

    delta)
        (

# ======================================
# SOURCE NODE : delta
# SOURCE FILE : soal_7_client_check.sh
# ======================================
# #!/bin/bash

NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo "======================================"
echo " NOMOR 7 - CLIENT CHECK $NODE"
echo "======================================"

echo
echo "===== 1. HOSTNAME ====="
hostname

echo
echo "===== 2. RESOLVER ====="
cat /etc/resolv.conf

echo
echo "===== 3. VAULT ====="
dig vault.k05.com A +short

echo
echo "===== 4. CORE ====="
dig core.k05.com A +short

echo
echo "===== 5. WWW CNAME ====="
dig www.k05.com CNAME +short

echo
echo "===== 6. STATIC CNAME ====="
dig static.k05.com CNAME +short

echo
echo "===== 7. WWW TARGET IP ====="
dig penny.k05.com A +short

echo
echo "===== 8. STATIC TARGET IP ====="
dig abbey.k05.com A +short

echo
echo "===== 9. PRAB SOA ====="
dig @10.66.5.2 k05.com SOA +short

echo
echo "===== 10. TEDD SOA ====="
dig @10.66.5.3 k05.com SOA +short

echo
echo "===== 11. DNS SERVER USED ====="
dig core.k05.com A | grep 'SERVER:'

        )
        ;;

    prab)
        (

# ======================================
# SOURCE NODE : prab
# SOURCE FILE : soal_7.sh
# ======================================
NODE=$(hostname | tr '[:upper:]' '[:lower:]')

if [ "$NODE" = "prab" ]; then
    echo "===== NOMOR 7: CONFIGURING VAULT, CORE, WWW, AND STATIC RECORDS ====="

    cat > /etc/bind/k05/k05.com <<'ZONE'
$TTL 300
@ IN SOA prab.k05.com. root.k05.com. (
    2026092804 ; Serial Baru (Naik dari 2026092803)
    3600       ; Refresh
    900        ; Retry
    604800     ; Expire
    300        ; Minimum TTL
)

@    IN NS prab.k05.com.
@    IN NS tedd.k05.com.

; ROUTER
rootkit IN A 10.66.5.1

; DNS SERVERS
prab    IN A 10.66.5.2
tedd    IN A 10.66.5.3

; APEX DOMAIN (MENGARAH KE PENNY)
@       IN A 10.66.4.2

; CLIENTS
alpha   IN A 10.66.1.2
beta    IN A 10.66.1.3
gamma   IN A 10.66.1.4
delta   IN A 10.66.2.2
epsilon IN A 10.66.2.3

; PROXIES
abbey   IN A 10.66.3.2
penny   IN A 10.66.4.2

; BACKENDS
obladi  IN A 10.66.5.4
desmond IN A 10.66.5.5
oblada  IN A 10.66.5.6
molly   IN A 10.66.5.7

; REPOSITORI VAULT (STATIC) MULTIPLE A RECORD
vault   IN A 10.66.5.4
vault   IN A 10.66.5.5

; REPOSITORI CORE (DYNAMIC) MULTIPLE A RECORD
core    IN A 10.66.5.6
core    IN A 10.66.5.7

; CANONICAL ALIASES (CNAME)
www     IN CNAME penny.k05.com.
static  IN CNAME abbey.k05.com.
ZONE

    echo "===== CEK CONFIGURATION ZONE ====="
    named-checkzone k05.com /etc/bind/k05/k05.com

    echo "===== RESTARTING BIND9 ====="
    pkill named 2>/dev/null || true
    mkdir -p /run/named
    chown bind:bind /run/named 2>/dev/null || true
    chown -R bind:bind /var/cache/bind 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf
    sleep 2

    echo "===== VERIFIKASI LOKAL PRAB ====="
    dig @127.0.0.1 vault.k05.com +short
    dig @127.0.0.1 core.k05.com +short
    dig @127.0.0.1 www.k05.com +short
    dig @127.0.0.1 static.k05.com +short
else
    echo "Script ini hanya dijalankan di master DNS (prab)"
fi

        )
        ;;

    *)
        echo "Soal 7 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

