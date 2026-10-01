#!/bin/bash
set -euo pipefail

BACKUP="/root/backup-dns-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"
cp -a /etc/bind "$BACKUP/"

mkdir -p /etc/bind/k05 /run/named
chown bind:bind /run/named

# Ambil zona lengkap dari script nomor 7.
awk '
/^[[:space:]]*cat .*<<.*ZONE/ {ambil=1; next}
ambil && /^ZONE$/ {exit}
ambil {print}
' /root/soal_7.sh > /etc/bind/k05/k05.com

test -s /etc/bind/k05/k05.com

# Ambil ketiga zona reverse dari script nomor 8.
for SEG in 3 4 5; do
    awk -v target="/etc/bind/k05/rev$SEG" '
    index($0, "cat > " target " ") {ambil=1; next}
    ambil && /^ZONE$/ {exit}
    ambil {print}
    ' /root/soal_8.sh > "/etc/bind/k05/rev$SEG"

    test -s "/etc/bind/k05/rev$SEG"
done

cat > /etc/bind/named.conf.options <<'CONF'
options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; };
    allow-query { any; };
    recursion yes;
    allow-recursion { localhost; 10.66.0.0/16; };
    allow-query-cache { localhost; 10.66.0.0/16; };
    listen-on { any; };
    listen-on-v6 { none; };
};
CONF

cat > /etc/bind/named.conf.local <<'CONF'
zone "k05.com" {
    type master;
    file "/etc/bind/k05/k05.com";
    allow-transfer { 10.66.5.3; };
    also-notify { 10.66.5.3; };
    notify yes;
};
CONF

for SEG in 3 4 5; do
    cat >> /etc/bind/named.conf.local <<CONF
zone "$SEG.66.10.in-addr.arpa" {
    type master;
    file "/etc/bind/k05/rev$SEG";
    allow-transfer { 10.66.5.3; };
    also-notify { 10.66.5.3; };
    notify yes;
};
CONF
done

chmod 755 /etc/bind/k05
chmod 644 /etc/bind/k05/*

named-checkconf -z

# Restart manual sesuai pola script lama.
pkill -x named || true
named -u bind -c /etc/bind/named.conf

echo "Backup konfigurasi: $BACKUP"
echo "DNS Prab sudah dijalankan."
