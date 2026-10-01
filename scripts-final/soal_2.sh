#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 2

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 2"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    rootkit)
        (

# ======================================
# SOURCE NODE : rootkit
# SOURCE FILE : soal_2.sh
# ======================================
# #!/bin/bash

echo "===== AKTIFKAN ETH0 ROOTKIT KE NAT ====="

ip link set eth0 up

ip addr flush dev eth0 2>/dev/null || true
ip addr add 192.168.122.66/24 dev eth0

ip route del default 2>/dev/null || true
ip route add default via 192.168.122.1 dev eth0

cat > /etc/resolv.conf <<'DNS'
nameserver 192.168.122.1
nameserver 1.1.1.1
nameserver 8.8.8.8
DNS

echo "===== AKTIFKAN IP FORWARD ====="

sysctl -w net.ipv4.ip_forward=1

grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || \
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

echo "===== INSTALL IPTABLES JIKA BELUM ADA ====="

if ! command -v iptables >/dev/null 2>&1
then
    apt -o Acquire::ForceIPv4=true update
    apt -o Acquire::ForceIPv4=true install -y iptables
fi

echo "===== SET NAT MASQUERADE ====="

iptables -t nat -C POSTROUTING -s 10.66.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null || \
iptables -t nat -A POSTROUTING -s 10.66.0.0/16 -o eth0 -j MASQUERADE

echo
echo "===== IP ADDRESS ROOTKIT ====="
ip -br a

echo
echo "===== ROUTE ROOTKIT ====="
ip route

echo
echo "===== IP FORWARD ====="
sysctl net.ipv4.ip_forward

echo
echo "===== NAT TABLE ====="
iptables -t nat -L -v -n

echo
echo "===== TEST INTERNET DARI ROOTKIT ====="
ping -c 3 8.8.8.8

        )
        ;;

    *)
        echo "Soal 2 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

