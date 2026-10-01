#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 6

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 6"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    alpha)
        (

# ======================================
# SOURCE NODE : alpha
# SOURCE FILE : soal_6.sh
# ======================================
# #!/bin/bash

DOMAIN="k05.com"
NS1_IP="10.66.5.2"
NS2_IP="10.66.5.3"

echo "=========================================="
echo "   NOMOR 6: VERIFIKASI ZONE TRANSFER & SOA"
echo "=========================================="
echo

echo "1. QUERY SOA KE MASTER (PRAB - $NS1_IP):"
dig @$NS1_IP $DOMAIN SOA +noall +answer

echo
echo "2. QUERY SOA KE SLAVE (TEDD - $NS2_IP):"
dig @$NS2_IP $DOMAIN SOA +noall +answer

echo
echo "------------------------------------------"
SERIAL_PRAB=$(dig @$NS1_IP $DOMAIN SOA +short | awk '{print $3}')
SERIAL_TEDD=$(dig @$NS2_IP $DOMAIN SOA +short | awk '{print $3}')

echo "Serial SOA Prab : $SERIAL_PRAB"
echo "Serial SOA Tedd : $SERIAL_TEDD"
echo "------------------------------------------"

if [ -n "$SERIAL_PRAB" ] && [ "$SERIAL_PRAB" == "$SERIAL_TEDD" ]; then
    echo "STATUS: SUCCESS (Serial SOA identik & Zone Transfer Sempurna!)"
else
    echo "STATUS: FAILED (Serial tidak sama atau query gagal)"
fi

        )
        ;;

    *)
        echo "Soal 6 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

