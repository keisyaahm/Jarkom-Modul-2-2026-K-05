#!/bin/bash

echo "===== NOMOR 5: REFRESH SLAVE DNS TEDD ====="

pkill named 2>/dev/null || true
mkdir -p /run/named
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind
chown -R bind:bind /var/lib/bind

named -u bind -c /etc/bind/named.conf
sleep 5

echo
echo "===== CEK NAMED TEDD ====="
pgrep -a named

echo
echo "===== CEK RECORD NOMOR 5 DI TEDD ====="
for host in rootkit alpha beta gamma delta epsilon abbey penny obladi desmond oblada molly
do
    echo -n "$host.k05.com -> "
    dig @127.0.0.1 "$host.k05.com" +short
done

echo
echo "===== CEK FILE TRANSFER ====="
ls -l /var/lib/bind/k05/

echo
echo "===== CEK SOA SERIAL TEDD ====="
dig @127.0.0.1 k05.com SOA +short
