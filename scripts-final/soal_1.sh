#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 1

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 1"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    rootkit)
        (

# ======================================
# SOURCE NODE : rootkit
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    alpha)
        (

# ======================================
# SOURCE NODE : alpha
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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
echo "===== $NODE ====="
ip -br a
ip route

echo
echo "===== PING GATEWAY $GW ====="
ping -c 3 "$GW"

        )
        ;;

    beta)
        (

# ======================================
# SOURCE NODE : beta
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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
echo "===== $NODE ====="
ip -br a
ip route

echo
echo "===== PING GATEWAY $GW ====="
ping -c 3 "$GW"

        )
        ;;

    gamma)
        (

# ======================================
# SOURCE NODE : gamma
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    delta)
        (

# ======================================
# SOURCE NODE : delta
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    epsilon)
        (

# ======================================
# SOURCE NODE : epsilon
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    prab)
        (

# ======================================
# SOURCE NODE : prab
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    tedd)
        (

# ======================================
# SOURCE NODE : tedd
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    penny)
        (

# ======================================
# SOURCE NODE : penny
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    abbey)
        (

# ======================================
# SOURCE NODE : abbey
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    obladi)
        (

# ======================================
# SOURCE NODE : obladi
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    desmond)
        (

# ======================================
# SOURCE NODE : desmond
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    oblada)
        (

# ======================================
# SOURCE NODE : oblada
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    molly)
        (

# ======================================
# SOURCE NODE : molly
# SOURCE FILE : soal_1.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    *)
        echo "Soal 1 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

