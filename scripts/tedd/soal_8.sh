#!/bin/bash

echo "===== NOMOR 8: KONFIGURASI REVERSE DNS ZONE SLAVE DI TEDD ====="

mkdir -p /var/lib/bind/k05
mkdir -p /run/named
mkdir -p /var/cache/bind

chown -R bind:bind /var/lib/bind
chown -R bind:bind /run/named
chown -R bind:bind /var/cache/bind

cat > /etc/bind/named.conf.local <<'CONF'
zone "k05.com" {
    type slave;
    masters { 10.66.5.2; };
    file "/var/lib/bind/k05/k05.com";
};

zone "3.66.10.in-addr.arpa" {
    type slave;
    masters { 10.66.5.2; };
    file "/var/lib/bind/k05/rev3";
};

zone "4.66.10.in-addr.arpa" {
    type slave;
    masters { 10.66.5.2; };
    file "/var/lib/bind/k05/rev4";
};

zone "5.66.10.in-addr.arpa" {
    type slave;
    masters { 10.66.5.2; };
    file "/var/lib/bind/k05/rev5";
};
CONF

echo "===== CHECK CONFIG ====="
named-checkconf || exit 1

echo "===== RESTART NAMED ====="
pkill named 2>/dev/null || true

named -u bind -c /etc/bind/named.conf

sleep 5

echo "===== FILE TRANSFER ====="
ls -lah /var/lib/bind/k05/

echo "===== TES PTR TEDD ====="
dig @127.0.0.1 -x 10.66.3.2 +short
dig @127.0.0.1 -x 10.66.4.2 +short
dig @127.0.0.1 -x 10.66.5.4 +short
dig @127.0.0.1 -x 10.66.5.5 +short
dig @127.0.0.1 -x 10.66.5.6 +short
dig @127.0.0.1 -x 10.66.5.7 +short
