#!/bin/bash

NODE=$(hostname | tr '[:upper:]' '[:lower:]')

case "$NODE" in
    alpha)
        IP="10.66.1.2"
        GW="10.66.1.1"
        ;;
    beta)
        IP="10.66.1.3"
        GW="10.66.1.1"
        ;;
    gamma)
        IP="10.66.1.4"
        GW="10.66.1.1"
        ;;
    delta)
        IP="10.66.2.2"
        GW="10.66.2.1"
        ;;
    epsilon)
        IP="10.66.2.3"
        GW="10.66.2.1"
        ;;
    abbey)
        IP="10.66.3.2"
        GW="10.66.3.1"
        ;;
    penny)
        IP="10.66.4.2"
        GW="10.66.4.1"
        ;;
    prab)
        IP="10.66.5.2"
        GW="10.66.5.1"
        ;;
    tedd)
        IP="10.66.5.3"
        GW="10.66.5.1"
        ;;
    obladi)
        IP="10.66.5.4"
        GW="10.66.5.1"
        ;;
    desmond)
        IP="10.66.5.5"
        GW="10.66.5.1"
        ;;
    oblada)
        IP="10.66.5.6"
        GW="10.66.5.1"
        ;;
    molly)
        IP="10.66.5.7"
        GW="10.66.5.1"
        ;;
    *)
        echo "[ERROR] hostname $NODE tidak dikenal"
        exit 1
        ;;
esac

ip link set eth0 up

ip addr flush dev eth0 2>/dev/null || true
ip addr add "$IP/24" dev eth0

ip route del default 2>/dev/null || true
ip route add default via "$GW" dev eth0

cat > /etc/network/interfaces <<NET
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address $IP
    netmask 255.255.255.0
    gateway $GW
NET

cat > /etc/resolv.conf <<'DNS'
nameserver 192.168.122.1
DNS

echo
echo "===== NODE: $NODE ====="
echo "IP      : $IP"
echo "GATEWAY : $GW"

echo
echo "===== IP ADDRESS ====="
ip -br a

echo
echo "===== ROUTE ====="
ip route

echo
echo "===== PING GATEWAY ====="
ping -c 3 "$GW"
