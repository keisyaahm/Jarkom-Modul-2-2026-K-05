#!/bin/bash
set -e

ZONE="/etc/bind/k05/k05.com"

echo "======================================"
echo " NOMOR 18 - UBAH ABBEY KE IP FIKTIF"
echo "======================================"

sed -i -E \
's/^abbey[[:space:]]+15[[:space:]]+IN[[:space:]]+A[[:space:]]+10\.66\.3\.2$/abbey   15   IN A 10.99.99.99/' \
"$ZONE"

sed -i 's/2026092806/2026092807/' "$ZONE"

echo
echo "===== VALIDASI ====="
named-checkzone k05.com "$ZONE"

echo
echo "===== RESTART NAMED ====="
pkill named 2>/dev/null || true

mkdir -p /run/named /var/cache/bind
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind

named -u bind -c /etc/bind/named.conf
sleep 1

echo
echo "===== SOA BARU ====="
dig @127.0.0.1 k05.com SOA +short

echo
echo "===== ABBEY BARU DI PRAB ====="
dig @127.0.0.1 abbey.k05.com A +noall +answer
