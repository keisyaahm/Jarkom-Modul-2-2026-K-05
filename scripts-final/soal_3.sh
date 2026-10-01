#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 3

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 3"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    alpha)
        (

# ======================================
# SOURCE NODE : alpha
# SOURCE FILE : soal_3.sh
# ======================================
# #!/bin/bash

cat > /etc/resolv.conf <<'DNS'
nameserver 192.168.122.1
DNS

echo "===== RESOLVER ====="
cat /etc/resolv.conf

echo
echo "===== ROUTE ====="
ip route

echo
echo "===== TEST ROUTING INTERNAL ====="
ping -c 3 10.66.2.2
ping -c 3 10.66.3.2
ping -c 3 10.66.4.2
ping -c 3 10.66.5.2

echo
echo "===== TEST INTERNET DNS ====="
ping -c 3 google.com

        )
        ;;

    *)
        echo "Soal 3 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

