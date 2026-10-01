#!/bin/bash

IP="10.66.1.3"
GW="10.66.1.1"

for DEV in eth0 eth1 eth2 eth3
do
    ip link show "$DEV" >/dev/null 2>&1 || continue

    echo
    echo "=== COBA $DEV ==="

    ip addr flush dev eth0 2>/dev/null || true
    ip addr flush dev eth1 2>/dev/null || true
    ip addr flush dev eth2 2>/dev/null || true
    ip addr flush dev eth3 2>/dev/null || true

    ip link set "$DEV" up
    ip addr add "$IP/24" dev "$DEV"

    ip route del default 2>/dev/null || true
    ip route add default via "$GW" dev "$DEV"

    ping -c 2 -W 1 "$GW"

    if [ "$?" -eq 0 ]; then
        echo
        echo "[OK] beta interface benar = $DEV"

        cat > /etc/network/interfaces <<NET
auto lo
iface lo inet loopback

auto $DEV
iface $DEV inet static
    address $IP
    netmask 255.255.255.0
    gateway $GW
NET

        ip -br a
        ip route
        exit 0
    fi
done

echo "[GAGAL] Beta belum bisa ping gateway. Cek kabel beta ke Switch6."
