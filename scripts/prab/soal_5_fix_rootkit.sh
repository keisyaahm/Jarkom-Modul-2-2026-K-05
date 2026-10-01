#!/bin/bash

echo "===== FIX NOMOR 5: TAMBAH ROOTKIT RECORD ====="

cat > /etc/bind/k05/k05.com <<'ZONE'
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092803
    3600
    900
    604800
    300
)

@    IN NS prab.k05.com.
@    IN NS tedd.k05.com.

; ROUTER
rootkit IN A 10.66.5.1

; DNS SERVER
prab    IN A 10.66.5.2
tedd    IN A 10.66.5.3

; DOMAIN UTAMA MENGARAH KE PENNY
@       IN A 10.66.4.2

; CLIENT
alpha   IN A 10.66.1.2
beta    IN A 10.66.1.3
gamma   IN A 10.66.1.4
delta   IN A 10.66.2.2
epsilon IN A 10.66.2.3

; PROXY
abbey   IN A 10.66.3.2
penny   IN A 10.66.4.2

; VAULT / STATIC WEB BACKEND
obladi  IN A 10.66.5.4
desmond IN A 10.66.5.5

; CORE / DYNAMIC WEB BACKEND
oblada  IN A 10.66.5.6
molly   IN A 10.66.5.7
ZONE

named-checkzone k05.com /etc/bind/k05/k05.com

pkill named 2>/dev/null || true
mkdir -p /run/named
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind

named -u bind -c /etc/bind/named.conf
sleep 2

echo
echo "===== CEK RECORD ROOTKIT DAN NODE LAIN DI PRAB ====="
dig @127.0.0.1 rootkit.k05.com +short
dig @127.0.0.1 alpha.k05.com +short
dig @127.0.0.1 penny.k05.com +short
dig @127.0.0.1 molly.k05.com +short

echo
echo "===== CEK SOA SERIAL BARU ====="
dig @127.0.0.1 k05.com SOA +short
