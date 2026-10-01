#!/bin/bash

# Praktikum Modul 2 Jarkom 2026
# Kelompok K-05
# Soal 5

NODE="$(hostname | tr '[:upper:]' '[:lower:]')"

echo "======================================"
echo " SOAL 5"
echo " NODE: $NODE"
echo "======================================"

case "$NODE" in

    rootkit)
        (

# ======================================
# SOURCE NODE : rootkit
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    alpha)
        (

# ======================================
# SOURCE NODE : alpha
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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

        )
        ;;

    beta)
        (

# ======================================
# SOURCE NODE : beta
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    gamma)
        (

# ======================================
# SOURCE NODE : gamma
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    delta)
        (

# ======================================
# SOURCE NODE : delta
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    epsilon)
        (

# ======================================
# SOURCE NODE : epsilon
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    prab)
        (

# ======================================
# SOURCE NODE : prab
# SOURCE FILE : soal_5.sh
# ======================================
# #!/bin/bash

echo "===== NOMOR 5: TAMBAH A RECORD SEMUA NODE DI PRAB ====="

cat > /etc/bind/k05/k05.com <<'ZONE'
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092803
    3600
    900
    604800
    300
)

@    IN NS prab.k05.com.
@    IN NS tedd.k05.com.

; ROUTER
rootkit IN A 10.66.5.1

; DNS SERVER
prab    IN A 10.66.5.2
tedd    IN A 10.66.5.3

; DOMAIN UTAMA MENGARAH KE PENNY
@       IN A 10.66.4.2

; CLIENT
alpha   IN A 10.66.1.2
beta    IN A 10.66.1.3
gamma   IN A 10.66.1.4
delta   IN A 10.66.2.2
epsilon IN A 10.66.2.3

; PROXY
abbey   IN A 10.66.3.2
penny   IN A 10.66.4.2

; VAULT / STATIC WEB BACKEND
obladi  IN A 10.66.5.4
desmond IN A 10.66.5.5

; CORE / DYNAMIC WEB BACKEND
oblada  IN A 10.66.5.6
molly   IN A 10.66.5.7
ZONE

echo
echo "===== CEK ZONE FILE ====="
named-checkzone k05.com /etc/bind/k05/k05.com

echo
echo "===== RESTART NAMED MANUAL ====="
pkill named 2>/dev/null || true
mkdir -p /run/named
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind
named -u bind -c /etc/bind/named.conf
sleep 2

echo
echo "===== CEK NAMED ====="
pgrep -a named

echo
echo "===== CEK RECORD NOMOR 5 DI PRAB ====="
for host in rootkit alpha beta gamma delta epsilon abbey penny obladi desmond oblada molly
do
    echo -n "$host.k05.com -> "
    dig @127.0.0.1 "$host.k05.com" +short
done

echo
echo "===== CEK PRAB DAN TEDD MASIH ADA ====="
dig @127.0.0.1 prab.k05.com +short
dig @127.0.0.1 tedd.k05.com +short

echo
echo "===== CEK SOA SERIAL BARU ====="
dig @127.0.0.1 k05.com SOA +short


# ======================================
# SOURCE NODE : prab
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts


# ======================================
# SOURCE NODE : prab
# SOURCE FILE : soal_5_prab.sh
# ======================================
# #!/bin/bash

ZONE="/etc/bind/k05/k05.com"

echo "===== BACKUP ZONE ====="
cp "$ZONE" "$ZONE.bak.$(date +%H%M%S)"

echo "===== TULIS ULANG ZONE K05.COM UNTUK NOMOR 5 ====="

cat > "$ZONE" <<'ZONE'
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092802
    3600
    900
    604800
    300
)

@    IN NS prab.k05.com.
@    IN NS tedd.k05.com.

; DNS server
prab IN A 10.66.5.2
tedd IN A 10.66.5.3

; domain utama mengarah ke penny
@    IN A 10.66.4.2

; client subnet 10.66.1.0/24
alpha   IN A 10.66.1.2
beta    IN A 10.66.1.3
gamma   IN A 10.66.1.4

; client subnet 10.66.2.0/24
delta   IN A 10.66.2.2
epsilon IN A 10.66.2.3

; proxy nodes
abbey   IN A 10.66.3.2
penny   IN A 10.66.4.2

; vault/static web backends
obladi  IN A 10.66.5.4
desmond IN A 10.66.5.5

; core/dynamic web backends
oblada  IN A 10.66.5.6
molly   IN A 10.66.5.7
ZONE

echo
echo "===== CEK ZONE ====="
named-checkzone k05.com "$ZONE"

echo
echo "===== RESTART NAMED MANUAL DI PRAB ====="
pkill named 2>/dev/null || true
mkdir -p /run/named
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind
named -u bind -c /etc/bind/named.conf

sleep 2

echo
echo "===== CEK RECORD NOMOR 5 DI PRAB ====="
dig @127.0.0.1 alpha.k05.com +short
dig @127.0.0.1 beta.k05.com +short
dig @127.0.0.1 gamma.k05.com +short
dig @127.0.0.1 delta.k05.com +short
dig @127.0.0.1 epsilon.k05.com +short
dig @127.0.0.1 abbey.k05.com +short
dig @127.0.0.1 penny.k05.com +short
dig @127.0.0.1 obladi.k05.com +short
dig @127.0.0.1 desmond.k05.com +short
dig @127.0.0.1 oblada.k05.com +short
dig @127.0.0.1 molly.k05.com +short

echo
echo "===== CEK SERIAL PRAB ====="
dig @127.0.0.1 k05.com SOA +short

        )
        ;;

    tedd)
        (

# ======================================
# SOURCE NODE : tedd
# SOURCE FILE : soal_5.sh
# ======================================
# #!/bin/bash

echo "===== NOMOR 5: REFRESH SLAVE DNS TEDD ====="

pkill named 2>/dev/null || true
mkdir -p /run/named
chown bind:bind /run/named
chown -R bind:bind /var/cache/bind
chown -R bind:bind /var/lib/bind

named -u bind -c /etc/bind/named.conf
sleep 5

echo
echo "===== CEK NAMED TEDD ====="
pgrep -a named

echo
echo "===== CEK RECORD NOMOR 5 DI TEDD ====="
for host in rootkit alpha beta gamma delta epsilon abbey penny obladi desmond oblada molly
do
    echo -n "$host.k05.com -> "
    dig @127.0.0.1 "$host.k05.com" +short
done

echo
echo "===== CEK FILE TRANSFER ====="
ls -l /var/lib/bind/k05/

echo
echo "===== CEK SOA SERIAL TEDD ====="
dig @127.0.0.1 k05.com SOA +short


# ======================================
# SOURCE NODE : tedd
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    penny)
        (

# ======================================
# SOURCE NODE : penny
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    abbey)
        (

# ======================================
# SOURCE NODE : abbey
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    desmond)
        (

# ======================================
# SOURCE NODE : desmond
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    oblada)
        (

# ======================================
# SOURCE NODE : oblada
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    molly)
        (

# ======================================
# SOURCE NODE : molly
# SOURCE FILE : soal_5_hostname.sh
# ======================================
# #!/bin/bash

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
echo "hostname command:"
hostname

echo
echo "/etc/hostname:"
cat /etc/hostname

echo
echo "===== HOSTS FILE LENGKAP ====="
cat /etc/hosts

echo
echo "===== CEK BARIS NODE INI ====="
grep -w "$NODE" /etc/hosts

echo
echo "===== CEK HOST PENTING ====="
grep -w rootkit /etc/hosts
grep -w prab /etc/hosts
grep -w tedd /etc/hosts
grep -w penny /etc/hosts
grep -w molly /etc/hosts

        )
        ;;

    *)
        echo "Soal 5 tidak memiliki konfigurasi untuk node: $NODE"
        ;;

esac

