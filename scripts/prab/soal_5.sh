#!/bin/bash

echo "===== NOMOR 5: TAMBAH A RECORD SEMUA NODE DI PRAB ====="

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

echo
echo "===== CEK ZONE FILE ====="
named-checkzone k05.com /etc/bind/k05/k05.com

echo
echo "===== RESTART NAMED MANUAL ====="
pkill named 2>/dev/null || true
mkdir -p /run/named
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind
named -u bind -c /etc/bind/named.conf
sleep 2

echo
echo "===== CEK NAMED ====="
pgrep -a named

echo
echo "===== CEK RECORD NOMOR 5 DI PRAB ====="
for host in rootkit alpha beta gamma delta epsilon abbey penny obladi desmond oblada molly
do
    echo -n "$host.k05.com -> "
    dig @127.0.0.1 "$host.k05.com" +short
done

echo
echo "===== CEK PRAB DAN TEDD MASIH ADA ====="
dig @127.0.0.1 prab.k05.com +short
dig @127.0.0.1 tedd.k05.com +short

echo
echo "===== CEK SOA SERIAL BARU ====="
dig @127.0.0.1 k05.com SOA +short
