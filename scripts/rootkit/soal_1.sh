#!/bin/bash

ip link set eth1 up
ip link set eth2 up
ip link set eth3 up
ip link set eth4 up
ip link set eth5 up

ip addr flush dev eth1 2>/dev/null || true
ip addr flush dev eth2 2>/dev/null || true
ip addr flush dev eth3 2>/dev/null || true
ip addr flush dev eth4 2>/dev/null || true
ip addr flush dev eth5 2>/dev/null || true

ip addr add 10.66.1.1/24 dev eth1
ip addr add 10.66.2.1/24 dev eth2
ip addr add 10.66.3.1/24 dev eth3
ip addr add 10.66.4.1/24 dev eth4
ip addr add 10.66.5.1/24 dev eth5

cat > /etc/network/interfaces <<'NET'
auto lo
iface lo inet loopback

auto eth1
iface eth1 inet static
    address 10.66.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.66.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.66.3.1
    netmask 255.255.255.0

auto eth4
iface eth4 inet static
    address 10.66.4.1
    netmask 255.255.255.0

auto eth5
iface eth5 inet static
    address 10.66.5.1
    netmask 255.255.255.0
NET

echo "=== ROOTKIT ==="
ip -br a
