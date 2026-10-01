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

---

## Kesimpulan Nomor 1–5

Sampai tahap ini, jaringan telah memiliki konfigurasi IP dan gateway yang benar pada seluruh node, NAT melalui `rootkit`, routing internal antar-subnet, DNS master-slave melalui `prab` dan `tedd`, serta hostname dan A record untuk seluruh entitas. Resolver internal juga telah menggunakan urutan `prab`, `tedd`, kemudian `192.168.122.1`, sehingga resolusi domain internal maupun eksternal dapat berjalan sesuai kebutuhan praktikum. Ketentuan bahwa script instalasi dan konfigurasi berada pada `/root` juga diterapkan pada script yang digunakan. :chatgpt-content-reference{index="5"}#   - J a r k o m - M o d u l - 2 - 2 0 2 6 - K - 0 5  
 