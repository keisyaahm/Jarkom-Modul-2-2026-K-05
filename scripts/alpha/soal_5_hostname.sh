#!/bin/bash

NODE=$(hostname | tr '[:upper:]' '[:lower:]')

echo "$NODE" > /etc/hostname
hostname "$NODE"

cat > /etc/hosts <<'HOSTS'
127.0.0.1 localhost

10.66.5.1 rootkit.k05.com rootkit

10.66.1.2 alpha.k05.com alpha
10.66.1.3 beta.k05.com beta
10.66.1.4 gamma.k05.com gamma

10.66.2.2 delta.k05.com delta
10.66.2.3 epsilon.k05.com epsilon

10.66.3.2 abbey.k05.com abbey
10.66.4.2 penny.k05.com penny

10.66.5.2 prab.k05.com prab
10.66.5.3 tedd.k05.com tedd
10.66.5.4 obladi.k05.com obladi
10.66.5.5 desmond.k05.com desmond
10.66.5.6 oblada.k05.com oblada
10.66.5.7 molly.k05.com molly
HOSTS

echo "===== HOSTNAME SYSTEM-WIDE ====="
hostname
cat /etc/hostname

echo
echo "===== HOSTS FILE NODE INI ====="
grep "$NODE" /etc/hosts

echo
echo "===== CEK ROOTKIT ADA DI HOSTS ====="
grep rootkit /etc/hosts
