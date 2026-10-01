#!/bin/bash
set -e

echo "======================================"
echo " RECOVER BIND PRAB"
echo "======================================"

echo
echo "===== SET RESOLVER SEMENTARA ====="
cat > /etc/resolv.conf <<'RESOLV'
nameserver 192.168.122.1
RESOLV

echo
echo "===== UPDATE PACKAGE ====="
apt -o Acquire::ForceIPv4=true update

echo
echo "===== INSTALL BIND ====="
apt -o Acquire::ForceIPv4=true install -y bind9 bind9-utils dnsutils

echo
echo "===== CEK COMMAND ====="
command -v named
command -v named-checkzone

echo
echo "===== SELESAI INSTALL ====="
