#!/bin/bash

ZONE="/etc/bind/k05/k05.com"

echo "===== BACKUP ZONE ====="
cp "$ZONE" "$ZONE.bak.$(date +%H%M%S)"

echo "===== TULIS ULANG ZONE K05.COM UNTUK NOMOR 5 ====="

cat > "$ZONE" <<'ZONE'
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092802
    3600
    900
    604800
    300
)

@    IN NS prab.k05.com.
@    IN NS tedd.k05.com.

; DNS server
prab IN A 10.66.5.2
tedd IN A 10.66.5.3

; domain utama mengarah ke penny
@    IN A 10.66.4.2

; client subnet 10.66.1.0/24
alpha   IN A 10.66.1.2
beta    IN A 10.66.1.3
gamma   IN A 10.66.1.4

; client subnet 10.66.2.0/24
delta   IN A 10.66.2.2
epsilon IN A 10.66.2.3

; proxy nodes
abbey   IN A 10.66.3.2
penny   IN A 10.66.4.2

; vault/static web backends
obladi  IN A 10.66.5.4
desmond IN A 10.66.5.5

; core/dynamic web backends
oblada  IN A 10.66.5.6
molly   IN A 10.66.5.7
ZONE

echo
echo "===== CEK ZONE ====="
named-checkzone k05.com "$ZONE"

echo
echo "===== RESTART NAMED MANUAL DI PRAB ====="
pkill named 2>/dev/null || true
mkdir -p /run/named
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind
named -u bind -c /etc/bind/named.conf

sleep 2

echo
echo "===== CEK RECORD NOMOR 5 DI PRAB ====="
dig @127.0.0.1 alpha.k05.com +short
dig @127.0.0.1 beta.k05.com +short
dig @127.0.0.1 gamma.k05.com +short
dig @127.0.0.1 delta.k05.com +short
dig @127.0.0.1 epsilon.k05.com +short
dig @127.0.0.1 abbey.k05.com +short
dig @127.0.0.1 penny.k05.com +short
dig @127.0.0.1 obladi.k05.com +short
dig @127.0.0.1 desmond.k05.com +short
dig @127.0.0.1 oblada.k05.com +short
dig @127.0.0.1 molly.k05.com +short

echo
echo "===== CEK SERIAL PRAB ====="
dig @127.0.0.1 k05.com SOA +short
