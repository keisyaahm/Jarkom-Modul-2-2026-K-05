#!/bin/bash
set -e

echo "======================================"
echo " RECOVERY DNS TEDD - SLAVE"
echo "======================================"

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

echo
echo "===== VALIDASI CONFIG ====="
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
ss -lntup | grep ':53' || true

echo
echo "===== FILE HASIL TRANSFER ====="
ls -lah /var/lib/bind/k05/

echo
echo "===== SOA TEDD ====="
dig @127.0.0.1 k05.com SOA +short

echo
echo "===== ABBEY TEDD ====="
dig @127.0.0.1 abbey.k05.com A +noall +answer

echo
echo "===== TXT NO.17 ====="
for h in alpha beta gamma delta epsilon
do
    echo -n "$h -> "
    dig @127.0.0.1 "$h.k05.com" TXT +short
done
