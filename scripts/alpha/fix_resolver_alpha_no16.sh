#!/bin/bash
set -euo pipefail

if [ "$(hostname)" != "alpha" ]; then
    echo "Script ini hanya untuk Alpha."
    exit 1
fi

cp -a /etc/resolv.conf \
  "/root/resolv.conf.before-no16-$(date +%Y%m%d-%H%M%S)"

cat > /etc/resolv.conf <<'DNS'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
DNS

echo "===== RESOLVER ====="
cat /etc/resolv.conf

echo "===== RESOLUSI DOMAIN ====="
getent hosts www.k05.com
getent hosts static.k05.com

echo "===== HTTP MELALUI DOMAIN ====="
curl -sS --max-time 5 -o /dev/null \
  -w 'www: HTTP %{http_code}\n' http://www.k05.com/
curl -sS --max-time 5 -o /dev/null \
  -w 'static: HTTP %{http_code}\n' http://static.k05.com/
