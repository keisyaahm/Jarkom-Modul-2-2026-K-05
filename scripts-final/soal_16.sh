#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 16

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 16"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    alpha)
        (

# ======================================
# SOURCE NODE : alpha
# SOURCE FILE : soal_16.sh
# ======================================
# #!/bin/bash

set -u

echo "======================================"
echo " NOMOR 16 - APACHEBENCH STRESS TEST"
echo " CLIENT: $(hostname)"
echo "======================================"

[ "$(hostname)" = "alpha" ] || {
    echo "ERROR: jalankan di Alpha."
    exit 1
}

echo
echo "===== 1. NETWORK ALPHA ====="

ip link set eth0 up 2>/dev/null || true
ip addr replace 10.66.1.2/24 dev eth0
ip route replace default via 10.66.1.1 dev eth0

cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES

echo
echo "===== 2. TOOL ====="

if ! command -v ab >/dev/null 2>&1 || \
   ! command -v curl >/dev/null 2>&1 || \
   ! command -v dig >/dev/null 2>&1; then

    echo "nameserver 192.168.122.1" > /etc/resolv.conf

    apt-get update
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y apache2-utils curl dnsutils

    cat > /etc/resolv.conf <<'RES'
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
RES
fi

ab -V | head -n 2

echo
echo "===== 3. DNS ====="

echo "WWW:"
dig www.k05.com A +short

echo
echo "STATIC:"
dig static.k05.com A +short

WWW_IP="$(dig www.k05.com A +short | tail -n1)"
STATIC_IP="$(dig static.k05.com A +short | tail -n1)"

[ "$WWW_IP" = "10.66.4.2" ] || {
    echo "ERROR DNS WWW: $WWW_IP"
    exit 1
}

[ "$STATIC_IP" = "10.66.3.2" ] || {
    echo "ERROR DNS STATIC: $STATIC_IP"
    exit 1
}

wait_http() {
    NAME="$1"
    URL="$2"

    echo
    echo "Menunggu $NAME ..."

    i=1

    while [ "$i" -le 10 ]; do

        CODE="$(curl -s \
            --connect-timeout 2 \
            --max-time 5 \
            -o /dev/null \
            -w '%{http_code}' \
            "$URL" 2>/dev/null)"

        RC=$?

        if [ "$RC" -ne 0 ] || [ -z "$CODE" ]; then
            CODE="000"
        fi

        echo "Percobaan $i/10 -> HTTP $CODE"

        if [ "$CODE" = "200" ]; then
            echo "$NAME READY"
            return 0
        fi

        sleep 2
        i=$((i+1))
    done

    return 1
}

echo
echo "===== 4. WEB PRECHECK ====="

WWW_OK=1
STATIC_OK=1

wait_http "WWW / PENNY" \
"http://www.k05.com/" || WWW_OK=0

wait_http "STATIC / ABBEY" \
"http://static.k05.com/" || STATIC_OK=0

if [ "$WWW_OK" -ne 1 ]; then
    echo
    echo "ERROR: PENNY / VAULT BELUM READY"
fi

if [ "$STATIC_OK" -ne 1 ]; then
    echo
    echo "ERROR: ABBEY / CORE BELUM READY"
fi

if [ "$WWW_OK" -ne 1 ] || [ "$STATIC_OK" -ne 1 ]; then
    echo
    echo "BENCHMARK DIBATALKAN."
    exit 1
fi

echo
echo "======================================"
echo " 5. APACHEBENCH WWW"
echo "======================================"

ab -l -n 250 -c 10 \
http://www.k05.com/ \
| tee /root/ab_www.txt

echo
echo "======================================"
echo " 6. APACHEBENCH STATIC"
echo "======================================"

ab -l -n 250 -c 10 \
http://static.k05.com/ \
| tee /root/ab_static.txt

FILTER='Server Software|Server Hostname|Server Port|Document Path|Concurrency Level|Time taken for tests|Complete requests|Failed requests|Non-2xx responses|Requests per second|Time per request|Transfer rate'

echo
echo "======================================"
echo " 7. RANGKUMAN NOMOR 16"
echo "======================================"

echo
echo "===== WWW.K05.COM ====="
grep -E "$FILTER" /root/ab_www.txt

echo
echo "===== STATIC.K05.COM ====="
grep -E "$FILTER" /root/ab_static.txt

echo
echo "======================================"
echo " NOMOR 16 SELESAI"
echo "======================================"

        )
        ;;

    *)
        echo "Soal 16 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

