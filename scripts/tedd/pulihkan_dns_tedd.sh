#!/bin/bash
set -euo pipefail

if [ "$(hostname)" != "tedd" ]; then
    echo "Script ini hanya untuk TEDD."
    exit 1
fi

echo "======================================"
echo " PEMULIHAN DNS TEDD"
echo "======================================"

echo
echo "===== CEK / INSTALL BIND ====="

if ! command -v named >/dev/null 2>&1; then
    apt -o Acquire::ForceIPv4=true update
    apt -o Acquire::ForceIPv4=true install -y bind9 bind9-utils dnsutils
fi

echo
echo "===== BUAT DIREKTORI ====="

mkdir -p /var/lib/bind/k05
mkdir -p /run/named
mkdir -p /var/cache/bind

chown -R bind:bind /var/lib/bind
chown -R bind:bind /run/named
chown -R bind:bind /var/cache/bind

echo
echo "===== NAMED OPTIONS ====="

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

echo
echo "===== SLAVE ZONES ====="

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

echo
echo "===== VALIDASI ====="

named-checkconf

echo
echo "===== START NAMED ====="

pkill named 2>/dev/null || true

named -u bind -c /etc/bind/named.conf

sleep 5

echo
echo "===== PROCESS ====="
pgrep -a named

echo
echo "===== PORT 53 ====="
ss -lunp | grep ':53' || true

echo
echo "===== FILE HASIL TRANSFER ====="
ls -lah /var/lib/bind/k05/

echo
echo "===== FORWARD DNS ====="

echo -n "SOA    -> "
dig @127.0.0.1 k05.com SOA +short

echo -n "WWW    -> "
dig @127.0.0.1 www.k05.com +short

echo -n "STATIC -> "
dig @127.0.0.1 static.k05.com +short

echo -n "VAULT  -> "
dig @127.0.0.1 vault.k05.com A +short

echo -n "CORE   -> "
dig @127.0.0.1 core.k05.com A +short

echo
echo "===== SELESAI ====="
