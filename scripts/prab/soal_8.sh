echo "===== NOMOR 8: KONFIGURASI REVERSE DNS ZONE DI PRAB ====="

# 1. Buat folder dan file zone reverse
mkdir -p /etc/bind/k05

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

# 2. Deklarasi Reverse Zone di named.conf.local
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

# 3. Restart BIND9 Service
named-checkconf
pkill named 2>/dev/null || true
named -u bind -c /etc/bind/named.conf
sleep 2

# 4. Tes PTR Lokal
echo "===== TES PTR PRAB ====="
dig @127.0.0.1 -x 10.66.3.2 +short
dig @127.0.0.1 -x 10.66.4.2 +short
dig @127.0.0.1 -x 10.66.5.4 +short
dig @127.0.0.1 -x 10.66.5.5 +short
dig @127.0.0.1 -x 10.66.5.6 +short
dig @127.0.0.1 -x 10.66.5.7 +short
