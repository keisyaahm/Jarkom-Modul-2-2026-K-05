#!/bin/bash

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
