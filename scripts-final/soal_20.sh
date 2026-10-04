#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 20

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"
LOG="/root/soal20-last.log"

: > "$LOG"
exec >> "$LOG" 2>&1

echo "======================================"
echo " NOMOR 20 - AUTOSTART / AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

configure_node_network() {
    case "$NODE" in
        alpha)
            IP="10.66.1.2/24"; GW="10.66.1.1"
            ;;
        beta)
            IP="10.66.1.3/24"; GW="10.66.1.1"
            ;;
        gamma)
            IP="10.66.1.4/24"; GW="10.66.1.1"
            ;;
        delta)
            IP="10.66.2.2/24"; GW="10.66.2.1"
            ;;
        epsilon)
            IP="10.66.2.3/24"; GW="10.66.2.1"
            ;;
        abbey)
            IP="10.66.3.2/24"; GW="10.66.3.1"
            ;;
        penny)
            IP="10.66.4.2/24"; GW="10.66.4.1"
            ;;
        prab)
            IP="10.66.5.2/24"; GW="10.66.5.1"
            ;;
        tedd)
            IP="10.66.5.3/24"; GW="10.66.5.1"
            ;;
        obladi)
            IP="10.66.5.4/24"; GW="10.66.5.1"
            ;;
        desmond)
            IP="10.66.5.5/24"; GW="10.66.5.1"
            ;;
        oblada)
            IP="10.66.5.6/24"; GW="10.66.5.1"
            ;;
        molly)
            IP="10.66.5.7/24"; GW="10.66.5.1"
            ;;
        *)
            return
            ;;
    esac

    ip link set eth0 up
    ip addr replace "$IP" dev eth0
    ip route replace default via "$GW" dev eth0
}

set_final_resolver() {
    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
}

case "$NODE" in

rootkit)
    echo "===== ROOTKIT ====="

    # WAN
    ip link set eth0 up
    ip addr replace 192.168.122.66/24 dev eth0
    ip route replace default via 192.168.122.1 dev eth0

    # LAN
    for IFACE in eth1 eth2 eth3 eth4 eth5; do
        ip link set "$IFACE" up
    done

    ip addr replace 10.66.1.1/24 dev eth1
    ip addr replace 10.66.2.1/24 dev eth2
    ip addr replace 10.66.3.1/24 dev eth3
    ip addr replace 10.66.4.1/24 dev eth4
    ip addr replace 10.66.5.1/24 dev eth5

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v iptables >/dev/null 2>&1; then
        apt-get update
        apt-get install -y iptables
    fi

    sysctl -w net.ipv4.ip_forward=1

    # Jalankan NAT watcher agar rule yang dihapus saat startup
    # dipasang kembali secara otomatis.
    if [ -x /root/soal_20_nat_watch.sh ]; then
        if ! pgrep -f '/root/soal_20_nat_watch.sh' >/dev/null 2>&1; then
            nohup /root/soal_20_nat_watch.sh \
                </dev/null \
                >> /root/soal20-nat-launch.log 2>&1 &
        fi
    else
        # Fallback jika watcher belum tersedia
        iptables -t nat -C POSTROUTING \
            -s 10.66.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null || \
        iptables -t nat -A POSTROUTING \
            -s 10.66.0.0/16 -o eth0 -j MASQUERADE
    fi
    ;;

prab)
    echo "===== PRAB DNS MASTER ====="

    configure_node_network

    # DNS luar sementara untuk apt
    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    # Container dapat kehilangan package setelah restart
    if ! command -v named >/dev/null 2>&1; then
        apt-get -o Acquire::ForceIPv4=true update
        DEBIAN_FRONTEND=noninteractive \
        apt-get -o Acquire::ForceIPv4=true install -y \
            bind9 bind9-utils dnsutils
    fi

    if [ ! -d /root/persist_dns/bind ]; then
        echo "ERROR: /root/persist_dns/bind tidak ditemukan"
        exit 1
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    rm -f /run/named/named.pid

    /usr/sbin/named -4 -u bind -c /etc/bind/named.conf

    sleep 2

    set_final_resolver

    echo "===== DNS FINAL ====="
    dig @10.66.5.2 abbey.k05.com A +short || true
    ;;

tedd)
    echo "===== TEDD DNS SLAVE ====="

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get -o Acquire::ForceIPv4=true update
        DEBIAN_FRONTEND=noninteractive \
        apt-get -o Acquire::ForceIPv4=true install -y \
            bind9 bind9-utils dnsutils
    fi

    if [ ! -d /root/persist_dns/bind ]; then
        echo "ERROR: /root/persist_dns/bind tidak ditemukan"
        exit 1
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind /var/lib/bind/k05
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind /var/lib/bind

    named-checkconf

    pkill named 2>/dev/null || true
    rm -f /run/named/named.pid

    /usr/sbin/named -4 -u bind -c /etc/bind/named.conf

    sleep 3

    set_final_resolver
    ;;

penny|abbey|obladi|desmond|oblada|molly)
    echo "===== WEB RECOVERY ====="

    configure_node_network

    # Resolver luar sementara bila recovery membutuhkan apt
    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh

    set_final_resolver
    ;;

alpha|beta|gamma|delta|epsilon)
    echo "===== CLIENT ====="

    configure_node_network
    set_final_resolver

    echo "CLIENT NETWORK READY"
    ;;

*)
    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"
