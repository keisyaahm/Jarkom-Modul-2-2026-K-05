#!/bin/bash
set -e

echo "======================================"
echo " RECOVERY DNS PRAB - KONDISI NO.17"
echo "======================================"

mkdir -p /etc/bind/k05
mkdir -p /run/named
mkdir -p /var/cache/bind

# ==================================================
# FORWARD ZONE k05.com
# ==================================================

cat > /etc/bind/k05/k05.com <<'ZONE'
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092805
    3600
    900
    604800
    300
)

@ IN NS prab.k05.com.
@ IN NS tedd.k05.com.

@       IN A 10.66.4.2

rootkit IN A 10.66.5.1

alpha   IN A 10.66.1.2
beta    IN A 10.66.1.3
gamma   IN A 10.66.1.4

delta   IN A 10.66.2.2
epsilon IN A 10.66.2.3

abbey   IN A 10.66.3.2
penny   IN A 10.66.4.2

prab    IN A 10.66.5.2
tedd    IN A 10.66.5.3
obladi  IN A 10.66.5.4
desmond IN A 10.66.5.5
oblada  IN A 10.66.5.6
molly   IN A 10.66.5.7

vault   IN A 10.66.5.4
vault   IN A 10.66.5.5

core    IN A 10.66.5.6
core    IN A 10.66.5.7

www     IN CNAME penny.k05.com.
static  IN CNAME abbey.k05.com.

alpha   IN TXT "alpha"
beta    IN TXT "beta"
gamma   IN TXT "gamma"
delta   IN TXT "delta"
epsilon IN TXT "epsilon"
ZONE

# ==================================================
# REVERSE ZONE 10.66.3.0/24
# ==================================================

cat > /etc/bind/k05/rev3 <<'ZONE'
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092801
    3600
    900
    604800
    300
)

@ IN NS prab.k05.com.
@ IN NS tedd.k05.com.

2 IN PTR abbey.k05.com.
ZONE

# ==================================================
# REVERSE ZONE 10.66.4.0/24
# ==================================================

cat > /etc/bind/k05/rev4 <<'ZONE'
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092801
    3600
    900
    604800
    300
)

@ IN NS prab.k05.com.
@ IN NS tedd.k05.com.

2 IN PTR penny.k05.com.
ZONE

# ==================================================
# REVERSE ZONE 10.66.5.0/24
# ==================================================

cat > /etc/bind/k05/rev5 <<'ZONE'
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092801
    3600
    900
    604800
    300
)

@ IN NS prab.k05.com.
@ IN NS tedd.k05.com.

4 IN PTR obladi.k05.com.
5 IN PTR desmond.k05.com.
6 IN PTR oblada.k05.com.
7 IN PTR molly.k05.com.
ZONE

# ==================================================
# MASTER CONFIG
# ==================================================

cat > /etc/bind/named.conf.local <<'CONF'
zone "k05.com" {
    type master;
    file "/etc/bind/k05/k05.com";
    allow-transfer { 10.66.5.3; };
    also-notify { 10.66.5.3; };
    notify yes;
};

zone "3.66.10.in-addr.arpa" {
    type master;
    file "/etc/bind/k05/rev3";
    allow-transfer { 10.66.5.3; };
    also-notify { 10.66.5.3; };
    notify yes;
};

zone "4.66.10.in-addr.arpa" {
    type master;
    file "/etc/bind/k05/rev4";
    allow-transfer { 10.66.5.3; };
    also-notify { 10.66.5.3; };
    notify yes;
};

zone "5.66.10.in-addr.arpa" {
    type master;
    file "/etc/bind/k05/rev5";
    allow-transfer { 10.66.5.3; };
    also-notify { 10.66.5.3; };
    notify yes;
};
CONF

echo
echo "===== VALIDASI CONFIG ====="
named-checkconf

echo
echo "===== VALIDASI FORWARD ZONE ====="
named-checkzone k05.com /etc/bind/k05/k05.com

echo
echo "===== VALIDASI REVERSE ZONES ====="
named-checkzone 3.66.10.in-addr.arpa /etc/bind/k05/rev3
named-checkzone 4.66.10.in-addr.arpa /etc/bind/k05/rev4
named-checkzone 5.66.10.in-addr.arpa /etc/bind/k05/rev5

echo
echo "===== START NAMED ====="
pkill named 2>/dev/null || true

chown -R root:bind /etc/bind/k05
chmod 644 /etc/bind/k05/*

chown bind:bind /run/named
chown -R bind:bind /var/cache/bind

named -u bind -c /etc/bind/named.conf

sleep 2

echo
echo "===== SELESAI ====="
