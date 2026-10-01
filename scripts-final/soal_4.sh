#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 4

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 4"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    prab)
        (

# ======================================
# SOURCE NODE : prab
# SOURCE FILE : soal_4.sh
# ======================================
# #!/bin/bash

apt -o Acquire::ForceIPv4=true update
apt -o Acquire::ForceIPv4=true install -y bind9 bind9-utils dnsutils

mkdir -p /etc/bind/k05

cat > /etc/bind/named.conf.options <<'CONF'
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    recursion yes;

    listen-on { any; };
    listen-on-v6 { any; };
};
CONF

cat > /etc/bind/k05/k05.com <<'ZONE'
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092801
    3600
    900
    604800
    300
)

@    IN NS prab.k05.com.
@    IN NS tedd.k05.com.

prab IN A 10.66.5.2
tedd IN A 10.66.5.3

@    IN A 10.66.4.2
ZONE

cat > /etc/bind/named.conf.local <<'LOCAL'
zone "k05.com" {
    type master;
    file "/etc/bind/k05/k05.com";

    allow-transfer {
        10.66.5.3;
    };

    also-notify {
        10.66.5.3;
    };

    notify yes;
};
LOCAL

named-checkconf
named-checkzone k05.com /etc/bind/k05/k05.com

service bind9 restart

echo
echo "===== CEK PRAB MASTER ====="
dig @localhost k05.com
dig @localhost prab.k05.com
dig @localhost tedd.k05.com

        )
        ;;

    tedd)
        (

# ======================================
# SOURCE NODE : tedd
# SOURCE FILE : soal_4.sh
# ======================================
# #!/bin/bash

echo "===== INSTALL BIND9 DI TEDD ====="
apt -o Acquire::ForceIPv4=true update
apt -o Acquire::ForceIPv4=true install -y bind9 bind9-utils dnsutils

echo "===== SETUP DIREKTORI SLAVE ====="
mkdir -p /var/lib/bind/k05
mkdir -p /run/named

chown -R bind:bind /var/lib/bind
chown -R bind:bind /var/cache/bind
chown bind:bind /run/named

echo "===== CONFIG OPTIONS ====="
cat > /etc/bind/named.conf.options <<'CONF'
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    recursion yes;

    listen-on { any; };
    listen-on-v6 { any; };
};
CONF

echo "===== CONFIG SLAVE ZONE ====="
cat > /etc/bind/named.conf.local <<'LOCAL'
zone "k05.com" {
    type slave;
    masters {
        10.66.5.2;
    };

    file "/var/lib/bind/k05/k05.com";
};
LOCAL

echo "===== CEK KONFIGURASI ====="
named-checkconf

echo "===== JALANKAN NAMED MANUAL ====="
pkill named 2>/dev/null || true
named -u bind -c /etc/bind/named.conf

sleep 5

echo
echo "===== CEK PROCESS NAMED ====="
pgrep -a named

echo
echo "===== CEK DNS TEDD SLAVE ====="
dig @127.0.0.1 k05.com +short
dig @127.0.0.1 prab.k05.com +short
dig @127.0.0.1 tedd.k05.com +short

echo
echo "===== CEK FILE HASIL TRANSFER ====="
ls -l /var/lib/bind/k05/

        )
        ;;

    *)
        echo "Soal 4 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

