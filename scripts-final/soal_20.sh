#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 20

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 20"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    rootkit)
        (

# ======================================
# SOURCE NODE : rootkit
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    alpha)
        (

# ======================================
# SOURCE NODE : alpha
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    beta)
        (

# ======================================
# SOURCE NODE : beta
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    gamma)
        (

# ======================================
# SOURCE NODE : gamma
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    delta)
        (

# ======================================
# SOURCE NODE : delta
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    epsilon)
        (

# ======================================
# SOURCE NODE : epsilon
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    prab)
        (

# ======================================
# SOURCE NODE : prab
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    tedd)
        (

# ======================================
# SOURCE NODE : tedd
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    penny)
        (

# ======================================
# SOURCE NODE : penny
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    abbey)
        (

# ======================================
# SOURCE NODE : abbey
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    obladi)
        (

# ======================================
# SOURCE NODE : obladi
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    desmond)
        (

# ======================================
# SOURCE NODE : desmond
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    oblada)
        (

# ======================================
# SOURCE NODE : oblada
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    molly)
        (

# ======================================
# SOURCE NODE : molly
# SOURCE FILE : soal_20.sh
# ======================================
# #!/bin/bash

set -e

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " NOMOR 20 - AUTO RECOVERY"
echo " NODE: $NODE"
echo "======================================"

# Hindari berjalan dua kali dalam boot yang sama
if [ -f /run/soal20.done ]; then
    echo "SOAL20 SUDAH DIJALANKAN PADA BOOT INI"
    exit 0
fi


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


case "$NODE" in

rootkit)

    echo "===== ROOTKIT ====="

    ip link set eth1 up
    ip link set eth2 up
    ip link set eth3 up
    ip link set eth4 up
    ip link set eth5 up

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

    iptables -t nat -C POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/16 \
        -o eth0 \
        -j MASQUERADE
    ;;


prab)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf
    named-checkzone k05.com /etc/bind/k05/k05.com

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


tedd)

    configure_node_network

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    if ! command -v named >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y bind9 bind9-utils dnsutils
    fi

    rm -rf /etc/bind
    cp -a /root/persist_dns/bind /etc/bind

    mkdir -p /run/named /var/cache/bind
    chown bind:bind /run/named
    chown -R bind:bind /var/cache/bind

    named-checkconf

    pkill named 2>/dev/null || true
    named -u bind -c /etc/bind/named.conf

    update-rc.d bind9 defaults 2>/dev/null || true

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
    ;;


penny|abbey|obladi|desmond|oblada|molly)

    configure_node_network

    if [ ! -x /root/recover_web.sh ]; then
        echo "ERROR: /root/recover_web.sh tidak ditemukan"
        exit 1
    fi

    bash /root/recover_web.sh
    ;;


alpha|beta|gamma|delta|epsilon)

    configure_node_network

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

    echo "CLIENT NETWORK READY"
    ;;


*)

    echo "ERROR: hostname tidak dikenal: $NODE"
    exit 1
    ;;

esac


touch /run/soal20.done

echo
echo "======================================"
echo " SOAL20 READY: $NODE"
echo "======================================"

        )
        ;;

    *)
        echo "Soal 20 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

