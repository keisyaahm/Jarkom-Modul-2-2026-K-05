#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 19

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 19"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    *)
        echo "Belum ada script sumber untuk Soal 19 pada node $NODE."
        exit 1
        ;;

esac

