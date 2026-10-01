# PRAKTIKUM JARKOM MODUL 2 KELOMPOK K05 - 2026

## Anggota Kelompok

| Nama | NRP |
| --- | --- |
| [Nama Anggota 1] | [NRP] |
| [Nama Anggota 2] | [NRP] |

## Laporan

---

# 1. Konfigurasi IP Address dan Default Gateway

Pada tahap awal, `rootkit` berfungsi sebagai router sentral yang menghubungkan seluruh entitas melalui lima jaringan internal yang berbeda. Setiap host dikonfigurasi menggunakan alamat IP statis dan default gateway yang mengarah ke interface `rootkit` pada subnet masing-masing. Hal ini sesuai dengan ketentuan soal yang meminta `rootkit` terhubung ke lima switch serta seluruh entitas memperoleh IP dan gateway sesuai pembagian topologi. :chatgpt-content-reference{index="0"}

![](assets/01_topologi_final.png)

### Skema Pengalamatan IP

| Node / Interface | IP Address | Default Gateway |
| --- | --- | --- |
| `rootkit eth0` | `192.168.122.66/24` | `192.168.122.1` |
| `rootkit eth1` | `10.66.1.1/24` | - |
| `alpha` | `10.66.1.2/24` | `10.66.1.1` |
| `beta` | `10.66.1.3/24` | `10.66.1.1` |
| `gamma` | `10.66.1.4/24` | `10.66.1.1` |
| `rootkit eth2` | `10.66.2.1/24` | - |
| `delta` | `10.66.2.2/24` | `10.66.2.1` |
| `epsilon` | `10.66.2.3/24` | `10.66.2.1` |
| `rootkit eth3` | `10.66.3.1/24` | - |
| `abbey` | `10.66.3.2/24` | `10.66.3.1` |
| `rootkit eth4` | `10.66.4.1/24` | - |
| `penny` | `10.66.4.2/24` | `10.66.4.1` |
| `rootkit eth5` | `10.66.5.1/24` | - |
| `prab` | `10.66.5.2/24` | `10.66.5.1` |
| `tedd` | `10.66.5.3/24` | `10.66.5.1` |
| `obladi` | `10.66.5.4/24` | `10.66.5.1` |
| `desmond` | `10.66.5.5/24` | `10.66.5.1` |
| `oblada` | `10.66.5.6/24` | `10.66.5.1` |
| `molly` | `10.66.5.7/24` | `10.66.5.1` |

### Konfigurasi pada Rootkit

Konfigurasi interface internal dibuat melalui script `/root/soal_1.sh`.

```sh
ip addr add 10.66.1.1/24 dev eth1
ip addr add 10.66.2.1/24 dev eth2
ip addr add 10.66.3.1/24 dev eth3
ip addr add 10.66.4.1/24 dev eth4
ip addr add 10.66.5.1/24 dev eth5
```

Konfigurasi tersebut juga disimpan pada `/etc/network/interfaces` agar alamat IP tidak hanya berlaku sementara.

Contoh:

```text
auto eth1
iface eth1 inet static
    address 10.66.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.66.2.1
    netmask 255.255.255.0
```

### Konfigurasi pada Host

Setiap host memiliki script `/root/soal_1.sh` yang menentukan alamat IP dan gateway sesuai hostname.

Sebagai contoh pada `alpha`:

```sh
ip addr add 10.66.1.2/24 dev eth0
ip route add default via 10.66.1.1
```

Konfigurasi permanennya:

```text
auto eth0
iface eth0 inet static
    address 10.66.1.2
    netmask 255.255.255.0
    gateway 10.66.1.1
```

### Validasi

Validasi dilakukan dengan melihat konfigurasi IP dan melakukan `ping` dari host menuju default gateway masing-masing.

Pada `rootkit`:

```sh
ip -br a
```

Hasil menunjukkan:

```text
eth1  10.66.1.1/24
eth2  10.66.2.1/24
eth3  10.66.3.1/24
eth4  10.66.4.1/24
eth5  10.66.5.1/24
```

Pada `alpha`:

```sh
ip -br a
ip route
ping -c 3 10.66.1.1
```

Hasil pengujian:

```text
eth0  10.66.1.2/24
default via 10.66.1.1 dev eth0

3 packets transmitted, 3 received, 0% packet loss
```

Keberhasilan tersebut membuktikan bahwa alamat IP, gateway, koneksi switch, dan interface router pada subnet terkait telah dikonfigurasi dengan benar.

![](assets/01_rootkit_ip_interfaces.png)

![](assets/01_alpha_ip_gateway_ping.png)

![](assets/01_molly_ip_gateway_ping.png)

---

# 2. Konfigurasi NAT dan Akses Internet

Setelah jaringan internal terbentuk, `rootkit` dikonfigurasi agar seluruh host internal dapat mengakses jaringan luar melalui NAT. Soal meminta interface WAN `rootkit` terhubung ke NAT dan melakukan penerusan lalu lintas keluar untuk seluruh alamat internal. :chatgpt-content-reference{index="1"}

### Konfigurasi WAN Rootkit

Interface `eth0` pada `rootkit` menggunakan:

```text
IP      : 192.168.122.66/24
Gateway : 192.168.122.1
```

Konfigurasi dilakukan melalui `/root/soal_2.sh`.

```sh
ip addr add 192.168.122.66/24 dev eth0

ip route del default 2>/dev/null || true
ip route add default via 192.168.122.1 dev eth0
```

### Mengaktifkan IP Forwarding

Agar `rootkit` dapat meneruskan paket dari jaringan internal menuju jaringan luar, IP forwarding diaktifkan.

```sh
sysctl -w net.ipv4.ip_forward=1
```

Konfigurasi juga disimpan pada:

```text
/etc/sysctl.conf
```

dengan isi:

```text
net.ipv4.ip_forward=1
```

### Konfigurasi NAT

Seluruh jaringan internal menggunakan blok `10.66.0.0/16`, sehingga dibuat rule MASQUERADE:

```sh
iptables -t nat -A POSTROUTING \
    -s 10.66.0.0/16 \
    -o eth0 \
    -j MASQUERADE
```

Rule tersebut menyebabkan paket dari jaringan internal menggunakan alamat WAN milik `rootkit` ketika keluar menuju internet.

### Validasi

Pada `rootkit` dilakukan:

```sh
ip route
sysctl net.ipv4.ip_forward
iptables -t nat -L -v -n
ping -c 3 8.8.8.8
```

Hasil yang diperoleh:

```text
default via 192.168.122.1 dev eth0
net.ipv4.ip_forward = 1
```

Pada NAT table terdapat:

```text
MASQUERADE  all  --  *  eth0  10.66.0.0/16  0.0.0.0/0
```

Pengujian internet dari `rootkit` menghasilkan:

```text
3 packets transmitted, 3 received, 0% packet loss
```

Kemudian dilakukan pengujian dari `alpha`:

```sh
ping -c 3 8.8.8.8
```

Keberhasilan pengujian dari host internal membuktikan bahwa NAT pada `rootkit` bekerja dengan benar.

![](assets/02_rootkit_nat_internet_ok.png)

![](assets/02_alpha_ping_internet.png)

---

# 3. Routing Internal dan Resolver Awal

Tahap berikutnya memastikan seluruh host pada subnet berbeda dapat saling berkomunikasi melalui `rootkit`. Selain itu, setiap host non-router menggunakan resolver awal `192.168.122.1` agar dapat melakukan resolusi DNS publik dan mengunduh paket yang dibutuhkan. :chatgpt-content-reference{index="2"}

### Konfigurasi Resolver Awal

Pada host non-router dibuat `/root/soal_3.sh` yang mengatur:

```sh
cat > /etc/resolv.conf <<'EOF'
nameserver 192.168.122.1
EOF
```

Isi resolver menjadi:

```text
nameserver 192.168.122.1
```

### Validasi Routing Internal

Pengujian dilakukan dari `alpha`, yang berada pada subnet `10.66.1.0/24`, menuju beberapa host pada subnet lain.

```sh
ping -c 3 10.66.2.2
ping -c 3 10.66.3.2
ping -c 3 10.66.4.2
ping -c 3 10.66.5.2
```

Alamat tersebut mewakili:

```text
10.66.2.2 = delta
10.66.3.2 = abbey
10.66.4.2 = penny
10.66.5.2 = prab
```

Seluruh pengujian menghasilkan:

```text
3 packets transmitted, 3 received, 0% packet loss
```

Hal ini membuktikan bahwa `rootkit` berhasil melakukan routing antar-subnet.

### Validasi Resolver dan Internet

Dari `alpha` dilakukan:

```sh
ping -c 3 google.com
```

Hasil:

```text
PING google.com (...)
3 packets transmitted, 3 received, 0% packet loss
```

Keberhasilan tersebut membuktikan bahwa resolver `192.168.122.1` dapat digunakan dan host tetap memiliki akses ke jaringan luar.

![](assets/03_alpha_cross_subnet_dns_ok.png)

---

# 4. DNS Master-Slave pada Prab dan Tedd

Pada tahap ini dibangun DNS internal untuk domain `k05.com`. `prab` berfungsi sebagai DNS master/primary dan `tedd` sebagai DNS secondary/slave. Domain apex `k05.com` diarahkan ke `penny`, sedangkan DNS eksternal diteruskan ke resolver `192.168.122.1`. Soal juga meminta `notify`, `allow-transfer`, authoritative answer, serta perubahan resolver host menjadi `prab → tedd → 192.168.122.1`. :chatgpt-content-reference{index="3"}

## Konfigurasi Prab sebagai DNS Master

BIND9 diinstal melalui script:

```text
/root/soal_4.sh
```

```sh
apt -o Acquire::ForceIPv4=true update
apt -o Acquire::ForceIPv4=true install -y bind9 bind9-utils dnsutils
```

### `named.conf.options`

```bind
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
```

### Zone Master

Pada `/etc/bind/named.conf.local`:

```bind
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
```

### Zone File Awal

Zone awal menggunakan serial:

```text
2026092801
```

Isi utama `/etc/bind/k05/k05.com`:

```bind
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092801
    3600
    900
    604800
    300
)

@     IN NS prab.k05.com.
@     IN NS tedd.k05.com.

prab  IN A 10.66.5.2
tedd  IN A 10.66.5.3

@     IN A 10.66.4.2
```

Dengan demikian:

```text
k05.com       -> 10.66.4.2
prab.k05.com  -> 10.66.5.2
tedd.k05.com  -> 10.66.5.3
```

### Menjalankan BIND9

Pada image DebiNet yang digunakan, `service bind9 restart` tidak tersedia sebagai init service. Oleh karena itu proses DNS dijalankan langsung melalui executable BIND9:

```sh
named -u bind -c /etc/bind/named.conf
```

### Validasi Prab

```sh
pgrep -a named

dig @127.0.0.1 k05.com +short
dig @127.0.0.1 prab.k05.com +short
dig @127.0.0.1 tedd.k05.com +short
```

Hasil:

```text
10.66.4.2
10.66.5.2
10.66.5.3
```

Query lengkap menunjukkan:

```text
status: NOERROR
flags: qr aa rd ra
```

Flag `aa` menunjukkan bahwa `prab` memberikan **authoritative answer** untuk zone `k05.com`.

![](assets/04_prab_master_dns_ok.png)

## Konfigurasi Tedd sebagai DNS Slave

Pada `tedd`, zone dideklarasikan sebagai slave:

```bind
zone "k05.com" {
    type slave;

    masters {
        10.66.5.2;
    };

    file "/var/lib/bind/k05/k05.com";
};
```

Direktori penyimpanan zone hasil transfer:

```sh
mkdir -p /var/lib/bind/k05
chown -R bind:bind /var/lib/bind
```

BIND9 kemudian dijalankan:

```sh
named -u bind -c /etc/bind/named.conf
```

### Validasi Tedd

```sh
dig @127.0.0.1 k05.com +short
dig @127.0.0.1 prab.k05.com +short
dig @127.0.0.1 tedd.k05.com +short

ls -l /var/lib/bind/k05/
```

Hasil:

```text
10.66.4.2
10.66.5.2
10.66.5.3
```

dan file zone hasil transfer tersedia:

```text
/var/lib/bind/k05/k05.com
```

Hal tersebut membuktikan bahwa `tedd` berhasil menerima salinan zone dari `prab`.

![](assets/04_tedd_slave_dns_transfer_ok.png)

## Konfigurasi Resolver Client

Setelah DNS internal aktif, resolver pada host non-router diubah menjadi:

```text
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
```

Dari `alpha` dilakukan:

```sh
dig k05.com +short
dig prab.k05.com +short
dig tedd.k05.com +short

dig @10.66.5.2 k05.com +short
dig @10.66.5.3 k05.com +short
```

Hasil:

```text
k05.com       -> 10.66.4.2
prab.k05.com  -> 10.66.5.2
tedd.k05.com  -> 10.66.5.3
```

Prab dan tedd sama-sama mengembalikan:

```text
10.66.4.2
```

Akses ke domain publik juga tetap berhasil melalui mekanisme forwarder:

```sh
ping -c 3 google.com
```

```text
3 packets transmitted, 3 received, 0% packet loss
```

![](assets/04_alpha_resolver_internal_dns_ok.png)

### Validasi SOA Master dan Slave

```sh
dig @10.66.5.2 k05.com SOA +short
dig @10.66.5.3 k05.com SOA +short
```

Pada tahap awal Nomor 4 kedua server menghasilkan serial yang sama:

```text
prab.k05.com. root.k05.com. 2026092801 3600 900 604800 300
prab.k05.com. root.k05.com. 2026092801 3600 900 604800 300
```

Hal tersebut menunjukkan master dan slave berada pada versi zone yang sama.

> **Catatan:** Serial ini kemudian dinaikkan pada Nomor 5 karena terdapat penambahan record DNS.

![](assets/04_soa_serial_prab_tedd_same.png)

---

# 5. Hostname System-Wide dan A Record Seluruh Entitas

Pada tahap ini seluruh entitas diberi hostname sesuai glosarium dan dibuatkan domain `<hostname>.k05.com`. `prab` dan `tedd` dikecualikan dari penambahan baru karena record keduanya sudah dibuat pada Nomor 4. :chatgpt-content-reference{index="4"}

Konfigurasi Nomor 5 terdiri dari dua bagian utama:

1. Menambahkan A record seluruh node pada DNS master `prab`.
2. Menetapkan hostname system-wide melalui `/etc/hostname` dan `/etc/hosts` pada seluruh node.

## Penambahan A Record pada Prab

Konfigurasi dilakukan melalui:

```text
/root/soal_5.sh
```

Dalam proses pengerjaan, `rootkit.k05.com` kemudian ditambahkan agar seluruh entitas memiliki record sesuai requirement. Serial SOA final dinaikkan menjadi:

```text
2026092803
```

Zone final berisi:

```bind
$TTL 300

@ IN SOA prab.k05.com. root.k05.com. (
    2026092803
    3600
    900
    604800
    300
)

@       IN NS prab.k05.com.
@       IN NS tedd.k05.com.

rootkit IN A 10.66.5.1

prab    IN A 10.66.5.2
tedd    IN A 10.66.5.3

@       IN A 10.66.4.2

alpha   IN A 10.66.1.2
beta    IN A 10.66.1.3
gamma   IN A 10.66.1.4
delta   IN A 10.66.2.2
epsilon IN A 10.66.2.3

abbey   IN A 10.66.3.2
penny   IN A 10.66.4.2

obladi  IN A 10.66.5.4
desmond IN A 10.66.5.5
oblada  IN A 10.66.5.6
molly   IN A 10.66.5.7
```

Pada implementasi ini, `rootkit.k05.com` diarahkan ke `10.66.5.1`, yaitu interface `rootkit` pada subnet server.

### Mapping Domain Final

| Domain | IP |
| --- | --- |
| `rootkit.k05.com` | `10.66.5.1` |
| `alpha.k05.com` | `10.66.1.2` |
| `beta.k05.com` | `10.66.1.3` |
| `gamma.k05.com` | `10.66.1.4` |
| `delta.k05.com` | `10.66.2.2` |
| `epsilon.k05.com` | `10.66.2.3` |
| `abbey.k05.com` | `10.66.3.2` |
| `penny.k05.com` | `10.66.4.2` |
| `prab.k05.com` | `10.66.5.2` |
| `tedd.k05.com` | `10.66.5.3` |
| `obladi.k05.com` | `10.66.5.4` |
| `desmond.k05.com` | `10.66.5.5` |
| `oblada.k05.com` | `10.66.5.6` |
| `molly.k05.com` | `10.66.5.7` |

Setelah perubahan:

```sh
named-checkzone k05.com /etc/bind/k05/k05.com
```

menghasilkan:

```text
zone k05.com/IN: loaded serial 2026092803
OK
```

![](assets/05_prab_all_node_records_final_ok.png)

## Sinkronisasi pada Tedd

`tedd` kemudian mengambil zone terbaru dari `prab`.

Validasi dilakukan dengan:

```sh
dig @127.0.0.1 rootkit.k05.com +short
dig @127.0.0.1 alpha.k05.com +short
dig @127.0.0.1 molly.k05.com +short

dig @127.0.0.1 k05.com SOA +short
```

Hasil:

```text
rootkit.k05.com -> 10.66.5.1
alpha.k05.com   -> 10.66.1.2
molly.k05.com   -> 10.66.5.7
```

Serial slave:

```text
2026092803
```

Hal ini menunjukkan bahwa perubahan pada DNS master telah diterima oleh DNS slave.

![](assets/05_tedd_rootkit_record_updated_ok.png)

## Konfigurasi Hostname System-Wide

Pada setiap node dibuat script:

```text
/root/soal_5_hostname.sh
```

Script mengambil hostname node:

```sh
NODE=$(hostname | tr '[:upper:]' '[:lower:]')
```

kemudian menulisnya ke:

```text
/etc/hostname
```

Selain itu `/etc/hosts` diisi dengan seluruh node:

```text
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
```

Sebagai contoh pada `alpha`:

```sh
hostname
cat /etc/hostname
```

menghasilkan:

```text
alpha
alpha
```

Sedangkan pada `molly`:

```text
molly
molly
```

Hal ini menunjukkan hostname telah dikenali secara system-wide.

![](assets/05_rootkit_hostname_systemwide_final_ok.png)

![](assets/05_alpha_hostname_systemwide_final_ok.png)

![](assets/05_molly_hostname_systemwide_final_ok.png)

## Validasi Resolusi Seluruh Host

Pengujian dilakukan dari `alpha`.

```sh
for host in rootkit alpha beta gamma delta epsilon abbey penny prab tedd obladi desmond oblada molly
do
    echo -n "$host.k05.com -> "
    dig "$host.k05.com" +short
done
```

Hasil yang diperoleh:

```text
rootkit.k05.com -> 10.66.5.1
alpha.k05.com   -> 10.66.1.2
beta.k05.com    -> 10.66.1.3
gamma.k05.com   -> 10.66.1.4
delta.k05.com   -> 10.66.2.2
epsilon.k05.com -> 10.66.2.3
abbey.k05.com   -> 10.66.3.2
penny.k05.com   -> 10.66.4.2
prab.k05.com    -> 10.66.5.2
tedd.k05.com    -> 10.66.5.3
obladi.k05.com  -> 10.66.5.4
desmond.k05.com -> 10.66.5.5
oblada.k05.com  -> 10.66.5.6
molly.k05.com   -> 10.66.5.7
```

Selanjutnya dilakukan pengujian konektivitas melalui hostname:

```sh
ping -c 3 rootkit.k05.com
ping -c 3 penny.k05.com
ping -c 3 molly.k05.com
```

Seluruh pengujian menghasilkan:

```text
0% packet loss
```

Hal ini membuktikan bahwa DNS mampu menerjemahkan hostname menjadi alamat IP yang benar dan routing antar-host tetap berjalan.

![](assets/05_alpha_resolve_all_hosts_final_ok.png)

### Validasi Serial Master-Slave Setelah Perubahan

Setelah seluruh record ditambahkan:

```sh
dig @10.66.5.2 k05.com SOA +short
dig @10.66.5.3 k05.com SOA +short
```

Hasil:

```text
prab.k05.com. root.k05.com. 2026092803 3600 900 604800 300
prab.k05.com. root.k05.com. 2026092803 3600 900 604800 300
```

Serial yang identik membuktikan `tedd` telah memperoleh salinan zone terbaru dari `prab`.

![](assets/05_soa_serial_after_rootkit_same.png)

# PRAKTIKUM MODUL 2 KOMUNIKASI DATA & JARINGAN KOMPUTER 2026

## Laporan Nomor 6–9 — Kelompok K05

Dokumen ini merupakan versi laporan Nomor 6–9 yang difokuskan pada **cara menjalankan script yang sudah tersedia di `/root`**, command verifikasi, hasil pengujian, dan screenshot. Isi source code lengkap setiap script tidak ditulis ulang di laporan karena file `.sh` dikumpulkan secara terpisah.

Screenshot yang digunakan:

```text
06_zone_transfer_serial_same.png

07_prab_dns_vault_core_records.png
07_alpha_dns_resolution.png
07_delta_dns_resolution.png

08_ptr_prab.png
08_ptr_tedd.png
08_ptr_alpha.png

09_alpha_vault_autoindex_test.png
```

---

# 6. Verifikasi Zone Transfer dan Serial SOA

## A. Deskripsi Soal

Nomor 6 melakukan verifikasi bahwa zone transfer antara DNS master `prab` dan DNS slave `tedd` sudah berjalan dengan benar.

Parameter jaringan yang digunakan:

```text
PRAB   = 10.66.5.2
TEDD   = 10.66.5.3
ALPHA  = 10.66.1.2
DOMAIN = k05.com
```

Pada tahap Nomor 6, serial SOA yang digunakan adalah:

```text
2026092803
```

Kesamaan serial SOA pada PRAB dan TEDD digunakan sebagai bukti bahwa slave telah menerima versi zone terbaru dari master.

## B. Script yang Digunakan

Script pengujian sudah tersedia pada node **Alpha**:

```text
/root/soal_6.sh
```

## C. Menjalankan Script

### RUN DI ALPHA

```bash
cd /root
chmod +x soal_6.sh
bash /root/soal_6.sh
```

Script melakukan query SOA ke PRAB dan TEDD, kemudian membandingkan nilai serial keduanya.

## D. Verifikasi Manual

Jika diperlukan saat demo, verifikasi dapat dilakukan langsung dari Alpha:

```bash
echo "===== SOA DARI PRAB ====="
dig @10.66.5.2 k05.com SOA +short

echo
echo "===== SOA DARI TEDD ====="
dig @10.66.5.3 k05.com SOA +short
```

Ekspektasi:

```text
prab.k05.com. root.k05.com. 2026092803 3600 900 604800 300
prab.k05.com. root.k05.com. 2026092803 3600 900 604800 300
```

## E. Hasil Pengujian

Hasil pengujian menunjukkan:

```text
Serial SOA Prab : 2026092803
Serial SOA Tedd : 2026092803
```

Status:

```text
STATUS: SUCCESS (Serial SOA identik & Zone Transfer Sempurna!)
```

Hal ini menunjukkan bahwa zone pada TEDD telah tersinkron dengan PRAB.

## F. Bukti Tangkapan Layar

![Verifikasi Zone Transfer dan Serial SOA](assets/06_zone_transfer_serial_same.png)

Pada screenshot terlihat query SOA ke PRAB dan TEDD, nilai serial yang sama, serta status keberhasilan zone transfer.

## G. Kesimpulan

Zone transfer antara DNS master `prab` dan DNS slave `tedd` berhasil dilakukan. Kedua DNS memiliki serial SOA yang sama sehingga zone pada slave sudah mengikuti versi terbaru dari master.

---

# 7. Forward DNS Vault, Core, WWW, dan Static

## A. Deskripsi Soal

Nomor 7 menambahkan record DNS untuk layanan berikut:

| Domain | Record | Tujuan |
|---|---|---|
| `vault.k05.com` | A | `10.66.5.4`, `10.66.5.5` |
| `core.k05.com` | A | `10.66.5.6`, `10.66.5.7` |
| `www.k05.com` | CNAME | `penny.k05.com.` |
| `static.k05.com` | CNAME | `abbey.k05.com.` |

Pada tahap ini serial SOA menjadi:

```text
2026092804
```

Konfigurasi dilakukan pada PRAB sebagai master dan diterima oleh TEDD sebagai slave.

## B. Script yang Digunakan

Script konfigurasi Nomor 7 tersedia pada:

```text
/root/soal_7.sh
```

Script dijalankan pada **PRAB** dan **TEDD** sesuai konfigurasi masing-masing node.

## C. Menjalankan pada PRAB

### RUN DI PRAB

```bash
cd /root
chmod +x soal_7.sh
bash /root/soal_7.sh
```

Setelah script selesai, lakukan verifikasi:

```bash
echo "===== SOA ====="
dig @127.0.0.1 k05.com SOA +short

echo "===== VAULT ====="
dig @127.0.0.1 vault.k05.com A +short

echo "===== CORE ====="
dig @127.0.0.1 core.k05.com A +short

echo "===== WWW ====="
dig @127.0.0.1 www.k05.com CNAME +short

echo "===== STATIC ====="
dig @127.0.0.1 static.k05.com CNAME +short
```

Ekspektasi:

```text
SOA    -> serial 2026092804

VAULT  ->
10.66.5.4
10.66.5.5

CORE   ->
10.66.5.6
10.66.5.7

WWW    -> penny.k05.com.
STATIC -> abbey.k05.com.
```

### Screenshot PRAB

![DNS Record Vault Core WWW Static di PRAB](assets/07_prab_dns_vault_core_records.png)

## D. Menjalankan pada TEDD

### RUN DI TEDD

```bash
cd /root
chmod +x soal_7.sh
bash /root/soal_7.sh
```

Setelah script selesai, verifikasi bahwa slave memiliki record yang sama:

```bash
dig @127.0.0.1 k05.com SOA +short
dig @127.0.0.1 vault.k05.com A +short
dig @127.0.0.1 core.k05.com A +short
dig @127.0.0.1 www.k05.com CNAME +short
dig @127.0.0.1 static.k05.com CNAME +short
```

## E. Verifikasi dari Alpha

### RUN DI ALPHA

```bash
echo "===== VAULT ====="
dig vault.k05.com A +short

echo
echo "===== CORE ====="
dig core.k05.com A +short

echo
echo "===== WWW ====="
dig www.k05.com CNAME +short

echo
echo "===== STATIC ====="
dig static.k05.com CNAME +short
```

Target:

```text
vault.k05.com  -> 10.66.5.4 dan 10.66.5.5
core.k05.com   -> 10.66.5.6 dan 10.66.5.7
www.k05.com    -> penny.k05.com.
static.k05.com -> abbey.k05.com.
```

![Resolusi DNS Nomor 7 dari Alpha](assets/07_alpha_dns_resolution.png)

## F. Verifikasi dari Delta

### RUN DI DELTA

```bash
echo "===== VAULT ====="
dig vault.k05.com A +short

echo
echo "===== CORE ====="
dig core.k05.com A +short

echo
echo "===== WWW ====="
dig www.k05.com CNAME +short

echo
echo "===== STATIC ====="
dig static.k05.com CNAME +short
```

Hasil pada Delta harus konsisten dengan Alpha.

![Resolusi DNS Nomor 7 dari Delta](assets/07_delta_dns_resolution.png)

## G. Kesimpulan

Record `vault`, `core`, `www`, dan `static` berhasil tersedia pada DNS internal. PRAB memberikan record sebagai master, TEDD menerima pembaruan sebagai slave, sedangkan Alpha dan Delta dapat melakukan resolusi dengan hasil yang konsisten.

---

# 8. Reverse DNS dan PTR Record

## A. Deskripsi Soal

Nomor 8 membuat reverse DNS untuk jaringan yang digunakan oleh Abbey, Penny, area Vault, dan area Core.

Reverse zone:

```text
3.66.10.in-addr.arpa
4.66.10.in-addr.arpa
5.66.10.in-addr.arpa
```

Mapping PTR:

```text
10.66.3.2 -> abbey.k05.com.
10.66.4.2 -> penny.k05.com.
10.66.5.4 -> obladi.k05.com.
10.66.5.5 -> desmond.k05.com.
10.66.5.6 -> oblada.k05.com.
10.66.5.7 -> molly.k05.com.
```

## B. Script yang Digunakan

Script Nomor 8 tersedia pada:

```text
/root/soal_8.sh
```

Script dijalankan pada **PRAB** sebagai master reverse zone dan pada **TEDD** sebagai slave.

## C. Menjalankan pada PRAB

### RUN DI PRAB

```bash
cd /root
chmod +x soal_8.sh
bash /root/soal_8.sh
```

Setelah script selesai, lakukan reverse lookup lokal:

```bash
echo "===== REVERSE LOOKUP PRAB ====="

dig @127.0.0.1 -x 10.66.3.2 +short
dig @127.0.0.1 -x 10.66.4.2 +short
dig @127.0.0.1 -x 10.66.5.4 +short
dig @127.0.0.1 -x 10.66.5.5 +short
dig @127.0.0.1 -x 10.66.5.6 +short
dig @127.0.0.1 -x 10.66.5.7 +short
```

Target:

```text
abbey.k05.com.
penny.k05.com.
obladi.k05.com.
desmond.k05.com.
oblada.k05.com.
molly.k05.com.
```

![PTR Reverse DNS di PRAB](assets/08_ptr_prab.png)

## D. Menjalankan pada TEDD

### RUN DI TEDD

```bash
cd /root
chmod +x soal_8.sh
bash /root/soal_8.sh
```

Verifikasi slave:

```bash
echo "===== REVERSE LOOKUP TEDD ====="

dig @127.0.0.1 -x 10.66.3.2 +short
dig @127.0.0.1 -x 10.66.4.2 +short
dig @127.0.0.1 -x 10.66.5.4 +short
dig @127.0.0.1 -x 10.66.5.5 +short
dig @127.0.0.1 -x 10.66.5.6 +short
dig @127.0.0.1 -x 10.66.5.7 +short
```

Target harus sama dengan hasil PRAB.

![PTR Reverse DNS di TEDD](assets/08_ptr_tedd.png)

## E. Verifikasi dari Alpha

### RUN DI ALPHA

```bash
echo "===== REVERSE LOOKUP DARI ALPHA ====="

dig -x 10.66.3.2 +short
dig -x 10.66.4.2 +short
dig -x 10.66.5.4 +short
dig -x 10.66.5.5 +short
dig -x 10.66.5.6 +short
dig -x 10.66.5.7 +short
```

Ekspektasi:

```text
abbey.k05.com.
penny.k05.com.
obladi.k05.com.
desmond.k05.com.
oblada.k05.com.
molly.k05.com.
```

![Reverse Lookup dari Alpha](assets/08_ptr_alpha.png)

## F. Verifikasi Authoritative

Untuk membuktikan jawaban berasal dari authoritative DNS, dapat dilakukan pada PRAB atau TEDD:

```bash
dig @127.0.0.1 -x 10.66.5.6 | \
grep -E 'status:|flags:|ANSWER SECTION|PTR'
```

Target utama:

```text
status: NOERROR
flags: qr aa ...
ANSWER: 1
```

Flag `aa` menunjukkan bahwa jawaban bersifat authoritative.

## G. Kesimpulan

Reverse DNS berhasil dikonfigurasi pada PRAB dan ditransfer ke TEDD. Reverse lookup dari client Alpha mengembalikan hostname yang sesuai untuk Abbey, Penny, Obladi, Desmond, Oblada, dan Molly.

---

# 9. Web Statis Vault dengan Apache dan Autoindex `/arsip/`

## A. Deskripsi Soal

Nomor 9 menjadikan `obladi` dan `desmond` sebagai web server statis menggunakan Apache.

Directory:

```text
/arsip/
```

harus dapat diakses melalui hostname dan menampilkan directory listing menggunakan fitur autoindex.

Node:

| Node | IP | Hostname |
|---|---|---|
| Obladi | `10.66.5.4` | `obladi.k05.com` |
| Desmond | `10.66.5.5` | `desmond.k05.com` |

## B. Script yang Digunakan

Script konfigurasi sudah tersedia pada masing-masing backend Vault:

```text
/root/soal_9.sh
```

Script yang sama digunakan pada Obladi dan Desmond. Isi script tidak ditulis ulang di laporan karena file `.sh` dikumpulkan secara terpisah.

## C. Menjalankan pada Obladi

### RUN DI OBLADI

```bash
cd /root
chmod +x soal_9.sh
bash /root/soal_9.sh
```

Setelah script selesai, lakukan pengecekan:

```bash
echo "===== OBLADI ====="
hostname
apache2ctl configtest
pgrep -a apache2
ss -lntp | grep ':80'

curl -s -o /dev/null \
-w "HTTP %{http_code}\n" \
-H 'Host: obladi.k05.com' \
http://127.0.0.1/arsip/
```

Target utama:

```text
obladi
Syntax OK
Apache aktif
port 80 LISTEN
HTTP 200
```

## D. Menjalankan pada Desmond

### RUN DI DESMOND

```bash
cd /root
chmod +x soal_9.sh
bash /root/soal_9.sh
```

Setelah script selesai:

```bash
echo "===== DESMOND ====="
hostname
apache2ctl configtest
pgrep -a apache2
ss -lntp | grep ':80'

curl -s -o /dev/null \
-w "HTTP %{http_code}\n" \
-H 'Host: desmond.k05.com' \
http://127.0.0.1/arsip/
```

Target utama:

```text
desmond
Syntax OK
Apache aktif
port 80 LISTEN
HTTP 200
```

## E. Pengujian Autoindex dari Alpha

### RUN DI ALPHA

```bash
echo "===== OBLADI ====="
curl -s http://obladi.k05.com/arsip/ | \
grep -E 'Index of /arsip|obladi_file|secret.txt'

echo
echo "===== DESMOND ====="
curl -s http://desmond.k05.com/arsip/ | \
grep -E 'Index of /arsip|desmond_file|secret.txt'
```

Hasil yang diharapkan:

```text
===== OBLADI =====
Index of /arsip
obladi_file.txt
secret.txt

===== DESMOND =====
Index of /arsip
desmond_file.txt
secret.txt
```

![Pengujian Autoindex Vault dari Alpha](assets/09_alpha_vault_autoindex_test.png)

## F. Verifikasi File Secret

Masih pada Alpha:

```bash
echo "===== SECRET OBLADI ====="
curl -s http://obladi.k05.com/arsip/secret.txt

echo
echo "===== SECRET DESMOND ====="
curl -s http://desmond.k05.com/arsip/secret.txt
```

Target:

```text
Dokumen Rahasia Vault obladi

Dokumen Rahasia Vault desmond
```

## G. Kesimpulan

Apache berhasil dijalankan pada Obladi dan Desmond. Directory `/arsip/` dapat diakses menggunakan hostname dan menampilkan directory listing. File di dalam directory juga dapat diakses langsung melalui client Alpha.

---

# Ringkasan Screenshot Nomor 6–9

## Nomor 6

```md
![Verifikasi Zone Transfer dan Serial SOA](assets/06_zone_transfer_serial_same.png)
```

## Nomor 7

```md
![DNS Record Vault Core WWW Static di PRAB](assets/07_prab_dns_vault_core_records.png)

![Resolusi DNS Nomor 7 dari Alpha](assets/07_alpha_dns_resolution.png)

![Resolusi DNS Nomor 7 dari Delta](assets/07_delta_dns_resolution.png)
```

## Nomor 8

```md
![PTR Reverse DNS di PRAB](assets/08_ptr_prab.png)

![PTR Reverse DNS di TEDD](assets/08_ptr_tedd.png)

![Reverse Lookup dari Alpha](assets/08_ptr_alpha.png)
```

## Nomor 9

```md
![Pengujian Autoindex Vault dari Alpha](assets/09_alpha_vault_autoindex_test.png)
```




# NOMOR 12 — BASIC AUTHENTICATION PADA PENNY

## A. Deskripsi Soal

Pada node **Penny** diterapkan Basic Authentication pada path `/admin`. Akses tanpa kredensial atau dengan kredensial yang salah harus ditolak, sedangkan pengguna dengan kredensial yang benar harus dapat membuka halaman admin.

Komponen pengujian:

| Komponen | Nilai |
|---|---|
| Reverse proxy | Penny |
| IP Penny | `10.66.4.2` |
| Hostname publik | `www.k05.com` |
| Path | `/admin/` |
| Username | `prabs` |
| Client uji | Alpha (`10.66.1.2`) |

Password tidak ditulis pada laporan dan dimasukkan secara interaktif saat pengujian.

## B. Konfigurasi

Script konfigurasi disimpan pada:

```text
/root/soal_12.sh
```

Konfigurasi menggunakan Apache Basic Authentication dengan file password:

```text
/etc/apache2/.htpasswd
```

Path `/admin` dikecualikan dari reverse proxy utama dan dilayani secara lokal oleh Penny.

Konsep konfigurasi:

```apache
Alias /admin /var/www/admin

<Directory /var/www/admin>
    AuthType Basic
    AuthName "Restricted Area"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
</Directory>

ProxyPass /admin !
```

## C. Pengujian

Pengujian dilakukan dari Alpha.

Tanpa kredensial:

```bash
curl -i http://www.k05.com/admin/
```

Dengan password salah:

```bash
curl -i -u 'prabs:salah' http://www.k05.com/admin/
```

Dengan username `prabs` dan password benar secara interaktif:

```bash
curl -i -u prabs http://www.k05.com/admin/
```

## D. Hasil

| Pengujian | Hasil |
|---|---|
| Tanpa kredensial | `401 Unauthorized` |
| Password salah | `401 Unauthorized` |
| Kredensial benar | `200 OK` |

Saat kredensial benar, halaman menampilkan:

```html
<h1>Ruang Rahasia Sindikat</h1>
<p>Dokumen rahasia hanya untuk yang berhak.</p>
```

## E. Bukti Screenshot

### Tanpa kredensial

![Tanpa kredensial](assets/12_01_admin_without_auth_401.png)

### Password salah

![Password salah](assets/12_02_admin_wrong_password_401.png)

### Kredensial benar

![Kredensial benar](assets/12_03_admin_valid_auth_200.png)

## F. Kesimpulan

Basic Authentication pada `/admin` berhasil diterapkan. Apache menolak request tanpa kredensial dan password salah dengan `401 Unauthorized`, sedangkan kredensial yang benar memperoleh `200 OK` dan dapat membuka halaman rahasia.

---

# NOMOR 13 — REDIRECT KE HOSTNAME KANONIK

## A. Deskripsi Soal

Akses langsung ke IP atau hostname internal gerbang harus diarahkan ke hostname kanonik layanan.

| Gerbang | Akses awal | Status | Tujuan |
|---|---|---:|---|
| Penny | `10.66.4.2` / `penny.k05.com` | `301` | `http://www.k05.com/` |
| Abbey | `10.66.3.2` / `abbey.k05.com` | `302` | `http://static.k05.com/` |

## B. Konfigurasi Penny

Penny menggunakan Apache dengan redirect permanen:

```apache
<VirtualHost *:80>
    ServerName penny.k05.com
    ServerAlias 10.66.4.2
    Redirect permanent "/" "http://www.k05.com/"
</VirtualHost>
```

Script disimpan pada:

```text
/root/soal_13.sh
```

## C. Konfigurasi Abbey

Abbey menggunakan Nginx dengan redirect sementara:

```nginx
server {
    listen 80 default_server;
    server_name abbey.k05.com 10.66.3.2;
    return 302 http://static.k05.com$request_uri;
}
```

## D. Pengujian

Pengujian dilakukan dari Alpha:

```bash
curl -I http://10.66.4.2/
curl -I http://penny.k05.com/
curl -I http://10.66.3.2/
curl -I http://abbey.k05.com/
```

## E. Hasil

Hasil pada Penny:

```text
HTTP/1.1 301 Moved Permanently
Location: http://www.k05.com/
```

Hasil pada Abbey:

```text
HTTP/1.1 302 Moved Temporarily
Location: http://static.k05.com/
```

## F. Bukti Screenshot

![Redirect kanonik Penny dan Abbey](assets/13_01_canonical_redirect_301_302.png)

## G. Kesimpulan

Redirect kanonik berhasil diterapkan. Penny menggunakan redirect permanen `301` menuju `www.k05.com`, sedangkan Abbey menggunakan redirect sementara `302` menuju `static.k05.com`.

---

# NOMOR 14 — PENCATATAN IP ASLI CLIENT PADA ACCESS LOG

## A. Deskripsi Soal

Backend pada area **vault** dan **core** harus mencatat alamat IP asli client yang diteruskan oleh reverse proxy, bukan hanya IP Penny atau Abbey.

Alur request:

```text
Alpha 10.66.1.2
├── Penny 10.66.4.2
│   ├── Obladi  10.66.5.4
│   └── Desmond 10.66.5.5
└── Abbey 10.66.3.2
    ├── Oblada 10.66.5.6
    └── Molly  10.66.5.7
```

## B. Konsep Konfigurasi

Reverse proxy meneruskan header identitas client:

```text
Host
X-Real-IP
```

Backend kemudian mencatat dua informasi:

```text
IP client asli
peer=IP reverse proxy
```

Target:

| Backend | IP asli client | Peer |
|---|---|---|
| Obladi | `10.66.1.2` | `10.66.4.2` |
| Desmond | `10.66.1.2` | `10.66.4.2` |
| Oblada | `10.66.1.2` | `10.66.3.2` |
| Molly | `10.66.1.2` | `10.66.3.2` |

Script Nomor 14 disimpan pada keempat backend sebagai:

```text
/root/soal_14.sh
```

## C. Pengujian pada Area Vault

Pada Obladi dan Desmond, log Apache diperiksa menggunakan request dengan penanda khusus.

Contoh:

```bash
grep 'cek14final=' /var/log/apache2/access.log | tail -n 3
```

Hasil menunjukkan pola:

```text
10.66.1.2 peer=10.66.4.2 ... 200 ...
```

Hal tersebut menunjukkan request berasal dari Alpha (`10.66.1.2`), sedangkan koneksi langsung ke backend datang melalui Penny (`10.66.4.2`).

## D. Pengujian pada Area Core

Pada Oblada dan Molly, access log Nginx menunjukkan pola:

```text
10.66.1.2 peer=10.66.3.2 ... 200 ...
```

Artinya IP asli Alpha tetap tercatat walaupun request melewati Abbey (`10.66.3.2`).

## E. Bukti Screenshot

### Obladi

![Real IP Obladi](assets/14_01_obladi_real_ip.png)

### Desmond

![Real IP Desmond](assets/14_02_desmond_real_ip.png)

### Oblada

![Real IP Oblada](assets/14_03_oblada_real_ip.png)

### Molly

![Real IP Molly](assets/14_04_molly_real_ip.png)

## F. Kesimpulan

Seluruh backend berhasil mencatat IP asli Alpha `10.66.1.2`. Area vault mencatat Penny sebagai peer `10.66.4.2`, sedangkan area core mencatat Abbey sebagai peer `10.66.3.2`. Dengan demikian identitas pengunjung tetap dapat ditelusuri setelah request melewati reverse proxy.

---

# NOMOR 15 — JALUR KHUSUS `/eternal` DAN `/orion`

## A. Deskripsi Soal

Dibuat dua jalur khusus yang berdiri sendiri dari reverse proxy utama:

1. Penny menyediakan `/eternal` dari `/var/www/eternal` dan file PHP harus dirender.
2. Abbey menyediakan `/orion` dari `/var/www/orion` sebagai konten statis tanpa rendering PHP.

## B. Penny — `/eternal`

Konfigurasi utama:

```apache
ProxyPass /eternal !
Alias /eternal /var/www/eternal

<Directory /var/www/eternal>
    Options -Indexes
    AllowOverride None
    Require all granted

    <FilesMatch "\.php$">
        SetHandler "proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost/"
    </FilesMatch>
</Directory>
```

Script:

```text
/root/soal_15_penny.sh
```

Pengujian lokal:

```bash
curl -s -i \
-H 'Host: www.k05.com' \
http://127.0.0.1/eternal/
```

Hasil:

```text
HTTP/1.1 200 OK
PHP Version: 8.4.26
Node: penny
```

### Bukti Penny

![Penny Eternal](assets/15_01_penny_eternal_php.png)

## C. Abbey — `/orion`

Konfigurasi:

```nginx
location = /orion {
    return 301 /orion/;
}

location /orion/ {
    alias /var/www/orion/;
    index index.html;
}
```

Script:

```text
/root/soal_15_abbey.sh
```

Pengujian:

```bash
curl -s -i \
-H 'Host: static.k05.com' \
http://127.0.0.1/orion/
```

Hasil:

```text
HTTP/1.1 200 OK
Server: nginx
```

Body menampilkan:

```html
<h1>Orion - Abbey</h1>
<p>Konten ini dilayani secara statis oleh Nginx.</p>
```

### Bukti Abbey

![Abbey Orion](assets/15_02_abbey_orion_static.png)

## D. Pengujian End-to-End dari Alpha

```bash
curl -s -i \
-H 'Host: www.k05.com' \
http://10.66.4.2/eternal/

curl -s -i \
-H 'Host: static.k05.com' \
http://10.66.3.2/orion/
```

Kedua jalur menghasilkan `HTTP 200`.

![End-to-end Eternal dan Orion](assets/15_03_alpha_eternal_orion.png)

## E. Kesimpulan

Penny berhasil me-render PHP melalui `/eternal`, sedangkan Abbey berhasil menyajikan `/orion` secara statis melalui Nginx. Kedua jalur dapat diakses dari Alpha tanpa mengganggu fungsi reverse proxy utama.

---

# NOMOR 17 — TXT RECORD UNTUK SELURUH CLIENT

## A. Deskripsi Soal

DNS internal harus memiliki TXT record untuk seluruh client sayap kiri dan kanan:

```text
alpha.k05.com   -> "alpha"
beta.k05.com    -> "beta"
gamma.k05.com   -> "gamma"
delta.k05.com   -> "delta"
epsilon.k05.com -> "epsilon"
```

## B. Konfigurasi pada Prab

Pada zone `k05.com` ditambahkan:

```dns
alpha   IN TXT "alpha"
beta    IN TXT "beta"
gamma   IN TXT "gamma"
delta   IN TXT "delta"
epsilon IN TXT "epsilon"
```

Serial SOA setelah perubahan menjadi:

```text
2026092805
```

Zone kemudian divalidasi dan BIND dimuat kembali.

## C. Verifikasi Prab

Command:

```bash
named-checkzone k05.com /etc/bind/k05/k05.com

dig @127.0.0.1 alpha.k05.com TXT +short
dig @127.0.0.1 beta.k05.com TXT +short
dig @127.0.0.1 gamma.k05.com TXT +short
dig @127.0.0.1 delta.k05.com TXT +short
dig @127.0.0.1 epsilon.k05.com TXT +short
```

Hasil:

```text
zone k05.com/IN: loaded serial 2026092805
OK

"alpha"
"beta"
"gamma"
"delta"
"epsilon"
```

![TXT Record Prab](assets/17_01_prab_txt_records.png)

## D. Verifikasi Sinkronisasi Tedd

Tedd sebagai slave menerima zone dengan serial yang sama:

```text
prab.k05.com. root.k05.com. 2026092805 3600 900 604800 300
```

Query TXT di Tedd mengembalikan nilai yang sama untuk seluruh client.

![TXT Record Tedd](assets/17_02_tedd_txt_sync.png)

## E. Kesimpulan

TXT record untuk Alpha, Beta, Gamma, Delta, dan Epsilon berhasil ditambahkan pada DNS master dan tersinkron ke DNS slave. Prab dan Tedd memberikan jawaban TXT yang konsisten.

---

# NOMOR 18 — TTL 15 DETIK DAN PERUBAHAN A RECORD ABBEY

## A. Deskripsi Soal

A record `abbey.k05.com` diuji menggunakan alamat IP fiktif dengan TTL `15` detik. Pengujian konsep cache dilakukan melalui tiga fase:

1. **Sebelum perubahan**: resolver cache masih memperoleh IP normal Abbey.
2. **Sesaat setelah authoritative record berubah**: Prab sudah memberikan IP baru, tetapi resolver yang sebelumnya menyimpan record lama masih mengembalikan IP lama sampai TTL habis.
3. **Setelah TTL habis**: authoritative server dan resolver cache sama-sama mengembalikan IP fiktif baru.

IP normal Abbey:

```text
10.66.3.2
```

IP fiktif yang digunakan saat pengujian:

```text
10.99.99.99
```

TTL:

```text
15 detik
```

## B. Perubahan DNS

Record uji:

```dns
abbey   15   IN A 10.99.99.99
```

Serial SOA saat perubahan uji:

```text
2026092807
```

Tedd kemudian menerima perubahan dari Prab sehingga kedua authoritative DNS berada pada serial yang sama.

## C. Tiga Fase yang Seharusnya Diverifikasi

### Fase 1 — sebelum perubahan

Kondisi yang menjadi acuan sebelum record diganti:

```text
Authoritative Prab : 10.66.3.2
Cache Alpha        : 10.66.3.2
```

### Fase 2 — baru berubah, masih dalam TTL 15 detik

Setelah authoritative record diganti:

```text
Authoritative Prab : 10.99.99.99
Cache Alpha        : 10.66.3.2
```

Perbedaan tersebut terjadi karena resolver caching masih menyimpan jawaban lama sampai TTL berakhir.

### Fase 3 — setelah TTL habis

Setelah menunggu lebih dari 15 detik:

```text
Authoritative Prab : 10.99.99.99
Cache Alpha        : 10.99.99.99
```

## D. Bukti Sinkronisasi dan Pengujian

### Tedd menerima record uji

![Tedd sync fake IP](assets/18_01_tedd_sync_fake_ip.png)

### Capture fase 1

![Capture fase 1](assets/18_02_phase1_capture.png)

### Capture fase 2

![Capture fase 2](assets/18_03_phase2_capture.png)

### Fase 3 setelah TTL berakhir

![Fase 3](assets/18_04_phase3_after_ttl.png)

### Sinkronisasi akhir Tedd saat eksperimen

![Tedd final sync](assets/18_05_tedd_final_sync.png)

> **Catatan validasi screenshot:** pada capture fase 1 dan fase 2 yang tersimpan, cache Alpha sudah menampilkan `10.99.99.99`. Artinya cache lama tidak berhasil dipertahankan pada saat screenshot tersebut diambil, sehingga dua capture itu tidak secara visual membuktikan kondisi “masih IP lama”. Urutan perilaku yang benar untuk eksperimen TTL adalah seperti bagian C di atas. Fase 3 dan sinkronisasi authoritative tetap menunjukkan IP fiktif `10.99.99.99` dengan TTL 15 detik.

## E. Pengembalian Kondisi Normal

Setelah eksperimen Nomor 18 selesai, record Abbey dikembalikan ke koordinat normal:

```dns
abbey   IN A 10.66.3.2
```

Hal ini diperlukan agar konfigurasi final tidak menggunakan alamat fiktif. Perubahan berikutnya pada Nomor 19 menggunakan serial yang lebih tinggi, yaitu `2026092808`.

## F. Kesimpulan

Pengujian Nomor 18 menggunakan TTL 15 detik dan IP fiktif `10.99.99.99`. Konsep yang diuji adalah perbedaan waktu propagasi antara authoritative DNS dan cache resolver. Setelah pengujian selesai, record Abbey dikembalikan ke IP normal `10.66.3.2` agar topologi kembali ke kondisi operasional.

---

# NOMOR 19 — CNAME OUTBOUND MENUJU DOMAIN EKSTERNAL

## A. Deskripsi Soal

Dibuat CNAME internal:

```text
outbound.k05.com
        ↓
http.badssl.com.
```

Setelah itu dilakukan `curl` dari Alpha untuk memastikan domain internal dapat diterjemahkan ke target eksternal dan kontennya dapat diakses.

## B. Konfigurasi pada Prab

Record yang ditambahkan:

```dns
outbound IN CNAME http.badssl.com.
```

Serial SOA dinaikkan menjadi:

```text
2026092808
```

Setelah konfigurasi dimuat, Prab memberikan:

```text
outbound.k05.com -> http.badssl.com.
```

Resolusi final pada saat pengujian menghasilkan IP publik:

```text
104.154.89.105
```

## C. Verifikasi Prab

Command:

```bash
dig @127.0.0.1 k05.com SOA +short
dig @127.0.0.1 outbound.k05.com CNAME +short
dig @127.0.0.1 outbound.k05.com A +short
```

Hasil utama:

```text
Serial SOA : 2026092808
CNAME      : http.badssl.com.
A final    : 104.154.89.105
```

![Prab outbound](assets/19_01_prab_outbound_cname.png)

## D. Verifikasi Tedd

Tedd memiliki serial SOA yang sama:

```text
2026092808
```

Query CNAME dan A final juga menghasilkan:

```text
http.badssl.com.
104.154.89.105
```

![Tedd outbound](assets/19_02_tedd_outbound_sync.png)

## E. Pengujian Akhir dari Alpha

Resolver Alpha tetap menggunakan urutan internal:

```text
nameserver 10.66.5.2
nameserver 10.66.5.3
nameserver 192.168.122.1
```

Command pengujian:

```bash
dig outbound.k05.com CNAME +short
dig outbound.k05.com A +short
curl -i http://outbound.k05.com
```

Hasil DNS:

```text
http.badssl.com.
104.154.89.105
```

Hasil HTTP:

```text
HTTP/1.1 200 OK
```

Body yang diterima menampilkan halaman default Nginx dari endpoint eksternal.

![Alpha outbound curl](assets/19_03_alpha_outbound_curl.png)

## F. Kesimpulan

CNAME `outbound.k05.com` berhasil diarahkan ke `http.badssl.com.`. Prab dan Tedd memiliki serial SOA `2026092808` dan memberikan hasil resolusi yang konsisten. Dari Alpha, nama internal dapat diterjemahkan sampai IP eksternal dan request HTTP berhasil memperoleh `200 OK`.

---

# RINGKASAN BUKTI SCREENSHOT

| Nomor | Nama File | Keterangan |
|---:|---|---|
| 12 | `12_01_admin_without_auth_401.png` | `/admin` tanpa kredensial menghasilkan 401 |
| 12 | `12_02_admin_wrong_password_401.png` | Password salah menghasilkan 401 |
| 12 | `12_03_admin_valid_auth_200.png` | Kredensial benar menghasilkan 200 |
| 13 | `13_01_canonical_redirect_301_302.png` | Penny 301 dan Abbey 302 |
| 14 | `14_01_obladi_real_ip.png` | IP asli Alpha tercatat pada Obladi |
| 14 | `14_02_desmond_real_ip.png` | IP asli Alpha tercatat pada Desmond |
| 14 | `14_03_oblada_real_ip.png` | IP asli Alpha tercatat pada Oblada |
| 14 | `14_04_molly_real_ip.png` | IP asli Alpha tercatat pada Molly |
| 15 | `15_01_penny_eternal_php.png` | `/eternal` dan PHP pada Penny |
| 15 | `15_02_abbey_orion_static.png` | `/orion` statis pada Abbey |
| 15 | `15_03_alpha_eternal_orion.png` | Uji end-to-end dari Alpha |
| 17 | `17_01_prab_txt_records.png` | TXT seluruh client pada Prab |
| 17 | `17_02_tedd_txt_sync.png` | TXT tersinkron pada Tedd |
| 18 | `18_01_tedd_sync_fake_ip.png` | Tedd menerima IP fiktif + TTL 15 |
| 18 | `18_02_phase1_capture.png` | Capture fase 1 yang tersedia |
| 18 | `18_03_phase2_capture.png` | Capture fase 2 yang tersedia |
| 18 | `18_04_phase3_after_ttl.png` | Fase setelah TTL habis |
| 18 | `18_05_tedd_final_sync.png` | Sinkronisasi Tedd saat eksperimen |
| 19 | `19_01_prab_outbound_cname.png` | CNAME dan resolve final di Prab |
| 19 | `19_02_tedd_outbound_sync.png` | Sinkronisasi CNAME di Tedd |
| 19 | `19_03_alpha_outbound_curl.png` | DNS dan curl end-to-end dari Alpha |

