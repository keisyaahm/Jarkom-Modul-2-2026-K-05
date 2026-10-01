#!/bin/bash
set -e

ZONE="/etc/bind/k05/k05.com"

echo "======================================"
echo " NOMOR 17 - TXT RECORD CLIENT"
echo " DNS MASTER: PRAB"
echo "======================================"

echo
echo "===== CEK ZONE FILE ====="
if [ ! -f "$ZONE" ]; then
    echo "ERROR: $ZONE tidak ditemukan"
    exit 1
fi

echo
echo "===== BACKUP ZONE ====="
cp "$ZONE" "${ZONE}.bak_no17"

echo
echo "===== HAPUS TXT RECORD LAMA JIKA ADA ====="
sed -i -E '/^(alpha|beta|gamma|delta|epsilon)[[:space:]]+IN[[:space:]]+TXT[[:space:]]+/d' "$ZONE"

echo
echo "===== TAMBAH TXT RECORD ====="
cat >> "$ZONE" <<'RECORDS'

alpha   IN TXT "alpha"
beta    IN TXT "beta"
gamma   IN TXT "gamma"
delta   IN TXT "delta"
epsilon IN TXT "epsilon"
RECORDS

echo
echo "===== UPDATE SERIAL SOA ====="
sed -i -E 's/2026092804/2026092805/' "$ZONE"

echo
echo "===== VALIDASI ZONE ====="
named-checkzone k05.com "$ZONE"

echo
echo "===== RESTART NAMED ====="
pkill named 2>/dev/null || true

mkdir -p /run/named /var/cache/bind
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind

named -u bind -c /etc/bind/named.conf
sleep 2

echo
echo "===== CEK SOA PRAB ====="
dig @127.0.0.1 k05.com SOA +short

echo
echo "===== CEK TXT PRAB ====="
for h in alpha beta gamma delta epsilon
do
    echo -n "$h.k05.com TXT -> "
    dig @127.0.0.1 "$h.k05.com" TXT +short
done
