#!/bin/bash

NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo "======================================"
echo " NOMOR 7 - CLIENT CHECK $NODE"
echo "======================================"

echo
echo "===== 1. HOSTNAME ====="
hostname

echo
echo "===== 2. RESOLVER ====="
cat /etc/resolv.conf

echo
echo "===== 3. VAULT ====="
dig vault.k05.com A +short

echo
echo "===== 4. CORE ====="
dig core.k05.com A +short

echo
echo "===== 5. WWW CNAME ====="
dig www.k05.com CNAME +short

echo
echo "===== 6. STATIC CNAME ====="
dig static.k05.com CNAME +short

echo
echo "===== 7. WWW TARGET IP ====="
dig penny.k05.com A +short

echo
echo "===== 8. STATIC TARGET IP ====="
dig abbey.k05.com A +short

echo
echo "===== 9. PRAB SOA ====="
dig @10.66.5.2 k05.com SOA +short

echo
echo "===== 10. TEDD SOA ====="
dig @10.66.5.3 k05.com SOA +short

echo
echo "===== 11. DNS SERVER USED ====="
dig core.k05.com A | grep 'SERVER:'
