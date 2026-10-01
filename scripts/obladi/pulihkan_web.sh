#!/bin/bash
set -euo pipefail

NODE=$(hostname)

case "$NODE" in
    obladi|desmond)
        DASAR="/root/soal_9.sh"
        ;;
    oblada|molly)
        DASAR="/root/soal_10.sh"
        ;;
    *)
        echo "Script hanya untuk empat backend web."
        exit 1
        ;;
esac

# Pastikan kedua script tersedia sebelum melakukan perubahan.
for FILE in "$DASAR" /root/soal_14.sh; do
    test -f "$FILE" || {
        echo "Script tidak ditemukan: $FILE"
        exit 1
    }
    bash -n "$FILE"
done

bash "$DASAR"
bash /root/soal_14.sh

echo "Web dan konfigurasi nomor 14 sudah dipulihkan di $NODE."
