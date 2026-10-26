# Aplikasi Web "DokuWiki"

Tugas Proyek Aplikasi Web Self-Hosted — Praktikum Komunikasi Data dan Jaringan Komputer (KDJK)  
Departemen Ilmu Komputer, Fakultas Matematika dan Ilmu Pengetahuan Alam, IPB University

### Kelompok 10
| Nama Mahasiswa | NIM | Peran & Kontribusi |
| :--- | :--- | :--- |
| **Naufal Indra Rizky** | M0403241171 | Deployment, Dokploy Hosting, Docker Compose & Reverse Proxy |
| **Nawra Ghaya Tsabita** | M0403241173 | Penyusunan Konten Wiki Lab Komdat & Riset Komparasi Aplikasi |
| **Muhammad Farhan Assafari** | M0403241176 | Otomasi Skrip Instalasi CLI (`setup.sh`) & Skrip Backup Terjadwal |
| **Muhammad Aulia Alfarisi** | M0403241193 | Konfigurasi VirtualHost, ACL Keamanan & Bahan Presentasi Demo |

---

## Ringkasan Pemenuhan Kriteria Penugasan

Sesuai dengan ketentuan pada [auriza/komdat-lab (projek.md)](https://github.com/auriza/komdat-lab/blob/master/projek.md):

- [x] **Pilihan Aplikasi:** Terdaftar resmi pada [Awesome-Selfhosted (Kategori Wikis)](https://github.com/Kickball/awesome-selfhosted#wikis).
- [x] **Legalitas Aplikasi:** 100% Legal & Open Source (Lisensi GNU General Public License v2 — bebas dari konten pembajakan/piracy).
- [x] **Aplikasi Pembanding Riil:** Memiliki bandingan aplikasi web asli terkemuka, yaitu **MediaWiki** (mesin di balik Wikipedia) dan **BookStack**.
- [x] **Keunikan Kelompok:** DokuWiki dipilih khusus oleh Kelompok 10 dan tidak menduplikasi pilihan kelompok lain.
- [x] **Tutorial Instalasi CLI:** Panduan instalasi langkah demi langkah berbasis CLI Ubuntu Server dan Docker Compose.
- [x] **Deployment Hosting / VPS:** Aplikasi berhasil di-deploy ke server/VPS dan dapat diakses publik dengan lancar melalui internet.
- [x] **Konten Aplikasi Terisi:** Basis pengetahuan laboratorium jaringan dengan 4 modul praktikum (Topologi, Routing, Layanan, Keamanan).
- [x] **Bahan Presentasi (PPT):** Tersedia berkas slide deck interaktif ([`presentasi.html`](presentasi.html)) dan format Marp ([`PRESENTASI.md`](PRESENTASI.md)).

---

## Tautan Akses & Bahan Presentasi

* **URL Akses Publik (VPS / Hosting):** `http://43.173.15.121:8080` *(atau via reverse proxy server)*
* **Slide Presentasi Interaktif (HTML):** Buka [`presentasi.html`](presentasi.html) pada peramban web (mendukung navigasi keyboard & cetak PDF).
* **Slide Presentasi Marp (Markdown):** [`PRESENTASI.md`](PRESENTASI.md)
* **Repositori GitHub:** [https://github.com/NaufalIndraR/dokuwiki_kelompok10](https://github.com/NaufalIndraR/dokuwiki_kelompok10)

---

## 1. Sekilas Tentang

**DokuWiki** adalah aplikasi wiki open source berbasis PHP yang ditujukan untuk keperluan dokumentasi teknis, catatan tim, dan pembuatan basis pengetahuan (*knowledge base*).

Ciri khas utama DokuWiki dibandingkan sistem manajemen konten (CMS) lainnya adalah **DokuWiki tidak membutuhkan database relasional SQL** (seperti MySQL atau PostgreSQL). Seluruh halaman dokumen, riwayat revisi, dan metadata disimpan dalam bentuk berkas teks biasa (*flat-file*) di dalam sistem direktori server.

### Karakteristik & Keunggulan Arsitektur:
1. **Konsumsi Memori Sangat Rendah:** Penggunaan RAM operasional di bawah **64 MB**, menjadikannya sangat ringan dan ideal dijalankan pada VM atau server VPS dengan sumber daya terbatas.
2. **Resiliensi Tinggi:** Meniadakan titik kegagalan (*single point of failure*) yang sering diakibatkan oleh crash server database SQL atau saturasi *connection pool*.
3. **Pencadangan Instan:** Pencadangan data semudah menyalin atau mengompres direktori berkas (`data/` dan `conf/`).
4. **Kontrol Versi Terintegrasi:** Setiap pembaruan dokumen mencatat riwayat perubahan (*changelog*), visual *diff*, dan tombol pemulihan (*rollback*) instan.
5. **Kontrol Akses Berjenjang (ACL):** Mendukung manajemen hak akses granular untuk membatasi izin baca, edit, unggah berkas, maupun manajemen sistem.

---

## 2. Instalasi

### Prasyarat Sistem
* **Sistem Operasi:** Linux (Ubuntu Server 22.04 / 24.04 LTS) atau container Docker di Dokploy
* **Web Server:** Apache 2.4 (dengan modul `mod_rewrite`) atau Nginx
* **Bahasa Pemrograman:** PHP versi 8.0 ke atas
* **Ekstensi PHP:** `php-xml`, `php-mbstring`, `php-gd`, `php-zip`, `php-curl`, `php-intl`
* **Basis Data:** Tidak memerlukan server basis data SQL (Flat-file engine)

---

### Cara 1: Instalasi Menggunakan Docker Compose (Dokploy / VPS)

Repositori ini menyediakan berkas [`docker-compose.yml`](docker-compose.yml) untuk deployment cepat dan terisolasi:

1. Clone repositori ke VPS atau hubungkan ke Dokploy:
   ```bash
   git clone https://github.com/NaufalIndraR/dokuwiki_kelompok10.git
   cd dokuwiki_kelompok10
   ```

2. Jalankan container:
   ```bash
   docker compose up -d
   ```

3. Akses antarmuka instalasi DokuWiki melalui peramban:
   ```text
   http://<IP-VPS-ANDA>:8080/install.php
   ```

4. Isi formulir instalasi awal (nama wiki, kredensial administrator, dan kebijakan ACL), lalu simpan.

---

### Cara 2: Instalasi Otomatis CLI Ubuntu Server (`setup.sh`)

Kami menyediakan skrip instalasi satu perintah [`setup.sh`](setup.sh) yang mengotomasi seluruh konfigurasi dari awal:

1. Clone repositori ke server Ubuntu:
   ```bash
   git clone https://github.com/NaufalIndraR/dokuwiki_kelompok10.git
   cd dokuwiki_kelompok10
   ```

2. Jalankan skrip dengan hak akses root:
   ```bash
   sudo bash setup.sh
   ```

3. Masukkan domain atau IP server saat diminta. Skrip akan otomatis mengonfigurasi Apache, mengunduh rilis resmi DokuWiki, mengatur *permission*, memuat modul praktikum, dan membuat VirtualHost.

---

### Cara 3: Langkah Instalasi Manual CLI (Native Apache2)

Jika ingin melakukan konfigurasi bertahap secara manual di Ubuntu Server:

1. Perbarui indeks repositori sistem:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. Pasang Apache2 dan alat pendukung:
   ```bash
   sudo apt install -y apache2 libapache2-mod-php curl wget tar
   ```

3. Pasang PHP dan ekstensi pendukung yang diwajibkan:
   ```bash
   sudo apt install -y php php-cli php-gd php-xml php-mbstring php-zip php-curl php-intl
   ```

4. Unduh rilis resmi stabil DokuWiki terbaru:
   ```bash
   cd /tmp
   wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
   ```

5. Ekstrak ke direktori web root `/var/www/dokuwiki`:
   ```bash
   sudo mkdir -p /var/www/dokuwiki
   sudo tar -xzf dokuwiki-stable.tgz -C /var/www/dokuwiki --strip-components=1
   ```

6. Salin konten modul praktikum ke direktori data:
   ```bash
   sudo cp -r /path/to/dokuwiki_kelompok10/sample-content/* /var/www/dokuwiki/data/pages/
   ```

7. Atur kepemilikan dan hak akses berkas:
   ```bash
   sudo chown -R www-data:www-data /var/www/dokuwiki
   sudo find /var/www/dokuwiki -type d -exec chmod 755 {} \;
   sudo find /var/www/dokuwiki -type f -exec chmod 644 {} \;
   sudo chmod -R 775 /var/www/dokuwiki/data
   sudo chmod -R 775 /var/www/dokuwiki/conf
   sudo chmod -R 775 /var/www/dokuwiki/lib/plugins
   sudo chmod -R 775 /var/www/dokuwiki/lib/tpl
   ```

8. Buat konfigurasi VirtualHost Apache (`/etc/apache2/sites-available/dokuwiki.conf`):
   ```apache
   <VirtualHost *:80>
       ServerAdmin admin@localhost
       DocumentRoot /var/www/dokuwiki

       <Directory /var/www/dokuwiki>
           Options -Indexes +FollowSymLinks
           AllowOverride All
           Require all granted
       </Directory>

       # Proteksi direktori privat
       <Directory /var/www/dokuwiki/data>
           Require all denied
       </Directory>
       <Directory /var/www/dokuwiki/conf>
           Require all denied
       </Directory>
       <Directory /var/www/dokuwiki/bin>
           Require all denied
       </Directory>
       <Directory /var/www/dokuwiki/inc>
           Require all denied
       </Directory>
   </VirtualHost>
   ```

9. Aktifkan modul `rewrite`, aktifkan virtualhost, dan reload web server:
   ```bash
   sudo a2enmod rewrite
   sudo a2ensite dokuwiki.conf
   sudo a2dissite 000-default.conf
   sudo systemctl reload apache2
   ```

10. Buka `http://<IP-SERVER>/install.php` untuk menyelesaikan inisialisasi awal, lalu amankan berkas installer:
    ```bash
    sudo rm -f /var/www/dokuwiki/install.php
    ```

---

## 3. Konfigurasi

### Penyesuaian Batas Upload dan Memori PHP
Untuk mendukung pengunggahan modul praktikum dan diagram topologi jaringan berukuran besar, sesuaikan `/etc/php/8.x/apache2/php.ini`:
```ini
upload_max_filesize = 32M
post_max_size = 32M
memory_limit = 256M
max_execution_time = 120
```
Terapkan perubahan dengan me-restart Apache:
```bash
sudo systemctl restart apache2
```

### Mengaktifkan Clean URLs (Nice URLs)
Agar tautan dokumen rapi tanpa parameter `doku.php?id=`:
1. Masuk ke menu **Admin** -> **Configuration Settings**.
2. Pada opsi **Advanced**, atur parameter `userewrite` ke `Apache .htaccess` (nilai `1`).
3. Pastikan berkas `.htaccess` telah aktif di server:
   ```bash
   cd /var/www/dokuwiki
   sudo cp .htaccess.dist .htaccess
   ```

### Pengaturan Hak Akses (Access Control List - ACL)
Pengaturan ACL dilakukan pada menu **Admin** -> **Access Control List Management**:
* **Pengunjung Publik (`@ALL`):** Izin hanya membaca (*Read-only*) pada namespace materi praktikum umum.
* **Akun Mahasiswa (`@user`):** Izin membaca dan menyunting (*Read & Edit*) catatan modul praktikum.
* **Administrator (`@admin`):** Hak kendali penuh terhadap manajemen user, plugin, dan konfigurasi sistem.

### Ekstensi & Plugin Tambahan
Beberapa plugin yang dapat diinstal melalui menu **Admin** -> **Extension Manager**:
* **Markdowku:** Memungkinkan penulisan dokumen menggunakan format Markdown standar.
* **Bootstrap3 Template:** Mengubah tampilan wiki menjadi responsif dan modern.
* **Tag Plugin:** Menambahkan taksonomi tagar untuk pengelompokan modul jaringan.

---

## 4. Maintenance

### Skrip Backup Otomatis (`backup.sh`)
Pencadangan sistem DokuWiki cukup dilakukan dengan mengompresi folder data, konfigurasi, plugin, dan template tanpa membebani server dengan proses dump database.

Eksekusi manual:
```bash
sudo bash backup.sh
```

Isi perintah inti skrip:
```bash
tar -czf "$BACKUP_FILE" \
    --exclude="${DOKUWIKI_DIR}/data/cache/*" \
    -C "$DOKUWIKI_DIR" data conf lib/plugins lib/tpl
```

### Penjadwalan Backup Terjadwal (Cron Job)
Untuk menjadwalkan pencadangan otomatis setiap malam pukul 02.00 WIB:
```bash
sudo crontab -e
```
Tambahkan baris berikut:
```cron
0 2 * * * /bin/bash /var/www/dokuwiki/backup.sh > /dev/null 2>&1
```

### Prosedur Pemulihan (Disaster Recovery)
Jika terjadi kerusakan sistem, pemulihan data dilakukan dengan mengekstrak kembali berkas arsip:
```bash
sudo tar -xzf /var/backups/dokuwiki/dokuwiki_backup_YYYYMMDD_HHMMSS.tar.gz -C /var/www/dokuwiki/
sudo chown -R www-data:www-data /var/www/dokuwiki
```

---

## 5. Pengisian Konten Aplikasi Web

Basis pengetahuan yang telah dimasukkan ke dalam DokuWiki bertema **Pusat Dokumentasi Laboratorium Komunikasi Data & Jaringan Komputer**:

* **Halaman Utama (`start`):** Sambutan pengantar, navigasi modul, profil Kelompok 10, serta penjelasan arsitektur wiki.
* **Modul 1 (`komdat:topologi`):** Desain topologi jaringan bintang hierarkis laboratorium, perhitungan subnetting VLSM `192.168.10.0/24`, dan konfigurasi sub-interface VLAN 802.1Q di Linux.
* **Modul 2 (`komdat:routing`):** Pengaktifan forwarding kernel Linux, static routing multi-hop, dan implementasi routing dinamis OSPF Area 0 menggunakan FRRouting.
* **Modul 3 (`komdat:layanan`):** Konfigurasi server DNS otoritatif BIND9 (`labkomdat.ipb.ac.id`), DHCP Server ISC-DHCP, dan Web Server internal.
* **Modul 4 (`komdat:keamanan`):** Konfigurasi firewall stateful UFW/iptables, SSH Key Authentication pada port kustom 2222, dan sistem mitigasi brute-force Fail2Ban.

---

## 6. Perbandingan dengan Aplikasi Sejenis

Sesuai aturan projek yang mewajibkan komparasi dengan aplikasi/situs web asli terkemuka:

| Parameter Evaluasi | DokuWiki (Pilihan Kelompok 10) | MediaWiki (Mesin Wikipedia) | BookStack |
| :--- | :--- | :--- | :--- |
| **Arsitektur Penyimpanan** | **Flat-File (`.txt`)** | Database Relasional SQL (MySQL/MariaDB) | Database Relasional SQL (MySQL/MariaDB) |
| **Kebutuhan Database** | **Tidak Membutuhkan SQL** | Wajib MySQL / MariaDB | Wajib MySQL / MariaDB |
| **Konsumsi Memori RAM** | **Sangat Rendah (< 64 MB)** | Tinggi (> 256 MB) | Sedang (~128 - 256 MB) |
| **Metode Pencadangan** | **Cukup arsip berkas folder (tar)** | Dump basis data SQL + backup berkas media | Dump basis data SQL + direktori upload |
| **Format Penulisan** | DokuWiki Markup & Markdown | Wikitext Markup | WYSIWYG Editor & Markdown |
| **Struktur Organisasi** | Namespace hierarkis tanpa batas | Kategori & namespace datar | Hierarki kaku: Rak > Buku > Bab > Halaman |
| **Toleransi Kegagalan** | **Tinggi (kebal crash DB)** | Bergantung pada ketersediaan daemon SQL | Bergantung pada ketersediaan daemon SQL |
| **Kompleksitas Setup** | Sangat cepat (langsung siap pakai) | Rumit (migrasi tabel SQL & dependensi) | Sedang (migrasi Laravel & dependensi Composer) |

### Pembahasan Analisis Komparasi:
1. **Dibandingkan dengan MediaWiki:**
   MediaWiki dirancang untuk kebutuhan ensiklopedia publik berskala masif (seperti Wikipedia) dengan jutaan halaman dan pengguna anonim. Namun, untuk sistem dokumentasi laboratorium atau tim teknis internal, kompleksitas instalasi dan beban pemeliharaan database MySQL pada MediaWiki menjadikannya kurang efisien dibandingkan DokuWiki yang ringan dan minim perawatan.
2. **Dibandingkan dengan BookStack:**
   BookStack menawarkan antarmuka modern menyerupai buku fisik, namun membatasi pengorganisasian konten pada hierarki tetap (*Shelf > Book > Chapter > Page*). Sebaliknya, sistem *namespace* DokuWiki memberikan fleksibilitas tanpa batas bagi modul-modul praktikum yang memiliki banyak sub-cabang materi.
3. **Kesimpulan Komparasi:**
   DokuWiki terbukti menjadi pilihan paling seimbang antara kemudahan pemeliharaan, keandalan tanpa database terpisah, dan efisiensi konsumsi sumber daya komputasi.

---

## 7. Slide Presentasi (PPT)

Materi presentasi untuk demonstrasi pekan ke-7 tersedia dalam dua format siap pakai:
1. **Slide Interaktif Web:** Buka berkas [`presentasi.html`](presentasi.html) di peramban web.
   * Dilengkapi navigasi keyboard (`◀` / `▶`), layar penuh (`F`), dan optimasi cetak PDF lanskap (`Ctrl + P`).
2. **Slide Markdown (Marp):** [`PRESENTASI.md`](PRESENTASI.md) dapat langsung dibuka atau diekspor menggunakan ekstensi VS Code Marp atau CLI.

---

## 8. Referensi

1. Repositori Praktikum KDJK IPB: [auriza/komdat-lab](https://github.com/auriza/komdat-lab)
2. Petunjuk Projek & Format Laporan: [auriza/komdat-lab/projek.md](https://github.com/auriza/komdat-lab/blob/master/projek.md) & [templat.md](https://github.com/auriza/komdat-lab/blob/master/templat.md)
3. Kurasi Aplikasi Self-Hosted: [Awesome-Selfhosted (Wikis)](https://github.com/Kickball/awesome-selfhosted#wikis)
4. Situs Resmi DokuWiki: [dokuwiki.org](https://www.dokuwiki.org/)
5. Repositori Source Code DokuWiki: [github.com/dokuwiki/dokuwiki](https://github.com/dokuwiki/dokuwiki)
