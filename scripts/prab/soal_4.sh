#!/bin/bash

apt -o Acquire::ForceIPv4=true update
apt -o Acquire::ForceIPv4=true install -y bind9 bind9-utils dnsutils

mkdir -p /etc/bind/k05

cat > /etc/bind/named.conf.options <<'CONF'
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    recursion yes;

    listen-on { any; };
    listen-on-v6 { any; };
};
CONF

cat > /etc/bind/k05/k05.com <<'ZONE'
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092801
    3600
    900
    604800
    300
)

@    IN NS prab.k05.com.
@    IN NS tedd.k05.com.

prab IN A 10.66.5.2
tedd IN A 10.66.5.3

@    IN A 10.66.4.2
ZONE

cat > /etc/bind/named.conf.local <<'LOCAL'
zone "k05.com" {
    type master;
    file "/etc/bind/k05/k05.com";

    allow-transfer {
        10.66.5.3;
    };

    also-notify {
        10.66.5.3;
    };

    notify yes;
};
LOCAL

named-checkconf
named-checkzone k05.com /etc/bind/k05/k05.com

service bind9 restart

echo
echo "===== CEK PRAB MASTER ====="
dig @localhost k05.com
dig @localhost prab.k05.com
dig @localhost tedd.k05.com
