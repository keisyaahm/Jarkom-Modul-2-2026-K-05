#!/bin/bash
set -euo pipefail

cp -L /etc/resolv.conf \
    "/root/resolv.conf.bak-$(date +%Y%m%d-%H%M%S)"

cat > /etc/resolv.conf <<'DNS'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
DNS

echo "=== Resolver Alpha ==="
cat /etc/resolv.conf

echo "=== IP tujuan www.k05.com ==="
getent hosts www.k05.com
