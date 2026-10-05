<h1 align="center">
  <img src="https://raw.githubusercontent.com/dokuwiki/dokuwiki/master/lib/tpl/dokuwiki/images/logo.png" alt="DokuWiki Logo" width="180"><br>
  Dokumentasi Instalasi & Evaluasi DokuWiki
</h1>

<p align="center">
  <b>Tugas Proyek Aplikasi Web Self-Hosted — Praktikum Komunikasi Data</b><br>
  <b>Kelompok 10</b> &bull; Departemen Ilmu Komputer | IPB University
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Aplikasi-DokuWiki-003366.svg?style=flat-square&logo=dokuwiki" alt="DokuWiki">
  <img src="https://img.shields.io/badge/Platform-Ubuntu%20Server%2022.04%2F24.04%20LTS-E95420.svg?style=flat-square&logo=ubuntu" alt="Ubuntu">
  <img src="https://img.shields.io/badge/Web%20Server-Apache2-D22128.svg?style=flat-square&logo=apache" alt="Apache2">
  <img src="https://img.shields.io/badge/Runtime-PHP%208.x-777BB4.svg?style=flat-square&logo=php" alt="PHP">
  <img src="https://img.shields.io/badge/Storage-Flat--File%20(No%20SQL)-green.svg?style=flat-square" alt="Flat File">
</p>

---

[Sekilas Tentang](#sekilas-tentang) | [Kebutuhan Sistem](#kebutuhan-sistem) | [Instalasi](#instalasi) | [Konfigurasi](#konfigurasi) | [Maintenance & Otomatisasi](#maintenance--otomatisasi) | [Pengisian Konten](#pengisian-konten) | [Perbandingan Aplikasi Sejenis](#perbandingan-aplikasi-sejenis) | [Panduan Demo Pekan ke-7](#panduan-demo-pekan-ke-7) | [Referensi](#referensi)
:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:

---

## Sekilas Tentang
[`^ kembali ke atas ^`](#)

**DokuWiki** adalah aplikasi *wiki engine* berbasis sumber terbuka (*open-source*) berlisensi GPLv2 yang dirancang khusus untuk kemudahan dokumentasi teknis, manajemen pengetahuan (*knowledge base*), catatan tim, serta manual proyek. 

Diciptakan pertama kali oleh **Andreas Gohr** pada Juni 2004, DokuWiki memiliki karakteristik arsitektur yang sangat unik dan membedakannya dari mayoritas CMS/wiki modern: **DokuWiki beroperasi murni dengan berkas teks biasa (*flat-file database*) tanpa memerlukan server basis data relasional (seperti MySQL atau PostgreSQL)**.

### Keunggulan Utama DokuWiki:
1. **Zero Database Overhead:** Seluruh artikel, hierarki *namespace*, dan metadata disimpan dalam struktur direktori dan berkas teks biasa (`.txt`).
2. **Sangat Ringan & Efisien:** Berjalan optimal bahkan pada Virtual Machine berspesifikasi minimal (RAM < 256 MB), berbeda dengan MediaWiki yang membutuhkan alokasi memori besar untuk *daemon* database.
3. **Pencatatan Versi (*Revision History*):** Memiliki sistem kontrol versi internal (*built-in*) yang otomatis menyimpan riwayat perubahan dokumen menggunakan format kompresi tanpa membebani disk.
4. **Portabilitas & Kemudahan Migrasi:** Pemindahan dan pencadangan (*backup*) sistem semudah menyalin direktori dokumen tanpa perlu melakukan *dump/import* SQL.
5. **Kontrol Akses Terperinci (ACL):** Dilengkapi fitur *Access Control List* bertingkat untuk mengatur izin baca (*read*), sunting (*edit*), buat (*create*), unggah (*upload*), dan hapus (*delete*) berdasarkan akun maupun kelompok pengguna (*groups*).
6. **Ekosistem Kaya:** Didukung ribuan *plugin* dan tema (*template*) komunitas yang dapat diinstal langsung melalui *Extension Manager*.

---

## Kebutuhan Sistem
[`^ kembali ke atas ^`](#)

Berikut adalah spesifikasi lingkungan sistem yang digunakan dalam implementasi ini:

| Komponen | Spesifikasi Minimum | Spesifikasi Lingkungan Proyek |
| :--- | :--- | :--- |
| **Sistem Operasi** | Linux (Ubuntu, Debian, CentOS) | **Ubuntu Server 22.04 / 24.04 LTS** (Virtual Machine) |
| **Arsitektur CPU** | 1 vCPU | 1 - 2 vCPU |
| **Memori RAM** | 128 MB | 1024 MB (1 GB) |
| **Penyimpanan Disk** | 200 MB bebas | 10 GB Virtual Disk |
| **Web Server** | Apache 2.4+ / Nginx / Lighttpd | **Apache 2.4.x** (dengan modul `mod_rewrite`) |
| **Bahasa Pemrograman** | PHP 7.4 - 8.3+ | **PHP 8.1 / 8.2 / 8.3** |
| **Ekstensi PHP** | `xml`, `mbstring` | `php-xml`, `php-mbstring`, `php-gd`, `php-zip`, `php-curl`, `php-intl` |
| **Basis Data** | *Tidak membutuhkan database SQL* | **Flat-file Storage** (Bawaan DokuWiki) |

---

## Instalasi
[`^ kembali ke atas ^`](#)

Instalasi dapat dilakukan dengan dua metode: **Metode Otomatis (Script Bash)** atau **Metode Manual (Langkah CLI per Tahap)**.

### Opsi A: Instalasi Cepat via Script Otomatis (`setup.sh`)

Untuk kemudahan dan kecepatan instalasi pada server baru, telah disediakan script otomatis `setup.sh`:

1. Masuk ke VM Anda via SSH:
   ```bash
   ssh user@<IP-VM-ANDA>
   ```
2. Unduh atau salin file `setup.sh` ke VM, berikan hak eksekusi, lalu jalankan dengan `sudo`:
   ```bash
   chmod +x setup.sh
   sudo ./setup.sh
   ```
3. Ikuti instruksi interaktif pada layar untuk memasukkan IP/Domain server Anda.

---

### Opsi B: Instalasi Manual Langkah Demi Langkah (CLI)

Berikut adalah tahapan CLI manual untuk membangun lingkungan DokuWiki secara menyeluruh:

#### 1. Pembaruan Repositori Sistem
```bash
sudo apt update && sudo apt upgrade -y
```

#### 2. Instalasi Web Server Apache2 & Utilitas
```bash
sudo apt install -y apache2 curl wget tar unzip
```

Pastikan Apache berjalan dengan baik:
```bash
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl status apache2
```

#### 3. Instalasi PHP dan Ekstensi Pendukung
```bash
sudo apt install -y php php-cli libapache2-mod-php php-gd php-xml php-mbstring php-zip php-curl php-intl
```

Periksa versi PHP yang terpasang:
```bash
php -v
```

#### 4. Mengunduh dan Mengekstrak Rilis Resmi DokuWiki
Unduh rilis stabil resmi dari situs DokuWiki:
```bash
cd /tmp
wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
```

Ekstrak berkas instalasi ke direktori dokumen web Apache (`/var/www/dokuwiki`):
```bash
sudo mkdir -p /var/www/dokuwiki
sudo tar -xzf dokuwiki-stable.tgz -C /var/www/dokuwiki --strip-components=1
```

#### 5. Pengaturan Kepemilikan & Izin Berkas (Permissions)
DokuWiki membutuhkan izin tulis pada folder data, konfigurasi, dan plugin agar dapat beroperasi normal:
```bash
sudo chown -R www-data:www-data /var/www/dokuwiki
sudo find /var/www/dokuwiki -type d -exec chmod 755 {} \;
sudo find /var/www/dokuwiki -type f -exec chmod 644 {} \;

# Berikan izin tulis untuk user web server
sudo chmod -R 775 /var/www/dokuwiki/data
sudo chmod -R 775 /var/www/dokuwiki/conf
sudo chmod -R 775 /var/www/dokuwiki/lib/plugins
sudo chmod -R 775 /var/www/dokuwiki/lib/tpl
```

#### 6. Konfigurasi VirtualHost Apache2
Aktifkan modul `rewrite` Apache untuk mendukung *Nice URL / Clean URL*:
```bash
sudo a2enmod rewrite
```

Buat berkas konfigurasi VirtualHost baru:
```bash
sudo nano /etc/apache2/sites-available/dokuwiki.conf
```

Tambahkan blok konfigurasi berikut (ganti `ServerName` dengan IP atau domain server Anda):
```apache
<VirtualHost *:80>
    ServerAdmin admin@dokuwiki.local
    ServerName 192.168.56.101
    DocumentRoot /var/www/dokuwiki

    <Directory /var/www/dokuwiki>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Proteksi Direktori Sensitif Flat-File
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

    ErrorLog ${APACHE_LOG_DIR}/dokuwiki_error.log
    CustomLog ${APACHE_LOG_DIR}/dokuwiki_access.log combined
</VirtualHost>
```

Aktifkan situs VirtualHost dan nonaktifkan konfigurasi default Apache:
```bash
sudo a2ensite dokuwiki.conf
sudo a2dissite 000-default.conf
sudo apache2ctl configtest
sudo systemctl reload apache2
```

#### 7. Finalisasi Instalasi via Antarmuka Web (Web Installer)
1. Buka peramban (*web browser*) pada komputer klien dan akses:
   ```text
   http://<ALAMAT-IP-VM>/install.php
   ```
2. Lengkapi formulir inisialisasi:
   - **Wiki Name:** Nama Wiki (contoh: `Knowledge Base Lab Komdat IPB`)
   - **Enable ACL (recommended):** Centang opsi ini untuk mengaktifkan kontrol hak akses.
   - **Superuser:** Nama akun admin (contoh: `admin`)
   - **Real name:** Nama lengkap administrator
   - **E-Mail:** Alamat email pengelola
   - **Password:** Kata sandi akun administrator
   - **Initial ACL Policy:** Pilih kebijakan awal:
     - *Open Wiki* (siapa pun dapat membaca dan menyunting)
     - *Public Wiki* (siapa pun dapat membaca, hanya pengguna terdaftar yang dapat menyunting — **Direkomendasikan**)
     - *Closed Wiki* (hanya pengguna terdaftar yang dapat membaca dan menyunting)
3. Klik tombol **Save**.
4. **PENTING (Langkah Keamanan):** Setelah proses inisialisasi berhasil, hapus berkas `install.php` agar tidak dapat diakses ulang oleh pihak luar:
   ```bash
   sudo rm -f /var/www/dokuwiki/install.php
   ```
5. Akses halaman utama wiki Anda di:
   ```text
   http://<ALAMAT-IP-VM>/
   ```

---

## Konfigurasi
[`^ kembali ke atas ^`](#)

### 1. Optimalisasi Parameter PHP (`php.ini`)
Secara *default*, batas unggah berkas PHP relatif kecil (2 MB). Untuk menunjang pengunggahan dokumen PDF, arsip modul, dan gambar dokumentasi yang lebih besar, sesuaikan pengaturan PHP:

Buka berkas konfigurasi PHP Apache:
```bash
sudo nano /etc/php/8.x/apache2/php.ini
```

Sesuaikan baris-baris berikut:
```ini
upload_max_filesize = 32M
post_max_size = 32M
memory_limit = 256M
max_execution_time = 120
max_input_time = 120
date.timezone = Asia/Jakarta
```

Simpan berkas (`Ctrl+O`, `Enter`, `Ctrl+X`), lalu mulai ulang Apache:
```bash
sudo systemctl restart apache2
```

### 2. Mengaktifkan *Nice URLs* (Clean URLs Tanpa `?id=`)
Secara bawaan, URL DokuWiki berbentuk: `http://ip-server/doku.php?id=wiki:syntax`. Untuk mengubahnya menjadi ramah pengguna seperti `http://ip-server/wiki/syntax`:

1. Masuk ke DokuWiki sebagai **Superuser / Admin**.
2. Masuk ke menu **Admin** $\rightarrow$ **Configuration Settings**.
3. Cari opsi **Advanced Settings**:
   - `userewrite`: Ubah dari *None* menjadi **Apache .htaccess** (opsi nilai `1`).
   - `canonical`: Centang untuk memastikan URL kanonikal konsisten.
   - `sepchar`: Karakter pemisah URL (default: `-` atau `_`).
4. Pastikan file `.htaccess` aktif pada direktori `/var/www/dokuwiki`:
   ```bash
   cd /var/www/dokuwiki
   sudo cp .htaccess.dist .htaccess
   sudo chown www-data:www-data .htaccess
   ```

### 3. Konfigurasi Kontrol Akses (ACL - Access Control List)
Pengaturan hak akses dilakukan melalui menu **Admin $\rightarrow$ Access Control List Management**:
- **Namespace Root (`*`):** Grup `@ALL` diberikan izin *Read* (baca saja).
- **Grup `@user` (Mahasiswa/Staff):** Diberikan izin *Read* dan *Edit* pada *namespace* kerja praktikum (`praktikum:*`).
- **Grup `@admin`:** Diberikan izin penuh *Admin* pada seluruh *namespace*.

### 4. Instalasi Plugin Rekomendasi
Plugin dapat dipasang langsung secara grafis melalui **Admin $\rightarrow$ Extension Manager**:

| Nama Plugin | Fungsi & Kegunaan |
| :--- | :--- |
| **Markdowku / Markdown Extra** | Memungkinkan penulisan halaman menggunakan sintaks **Markdown standard** selain sintaks bawaan DokuWiki. |
| **Bootstrap3 Template** | Mengganti tampilan antarmuka wiki menjadi modern, bersih, responsif ponsel cerdas, dan berbasis Bootstrap. |
| **Tag Plugin** | Menambahkan sistem taksonomi *tagging* dan kategori pada halaman wiki. |
| **IndexMenu Plugin** | Membuat navigasi pohon (*tree view sidebar*) interaktif untuk memudahkan penelusuran dokumen. |
| **Wrap Plugin** | Memberikan komponen visual seperti *alert boxes*, *callouts*, dan kolom tata letak (*layout columns*). |

---

## Maintenance & Otomatisasi
[`^ kembali ke atas ^`](#)

Salah satu keunggulan terbesar dari arsitektur *flat-file* DokuWiki adalah **prosedur pemeliharaan (*maintenance*) dan pencadangan (*backup*) yang sangat sederhana, cepat, dan tidak rentan korupsi database**.

### 1. Script Backup Otomatis (`backup.sh`)
Telah disiapkan script `backup.sh` yang melakukan kompresi folder penting:
- `/var/www/dokuwiki/data/` (konten, riwayat revisi, media berkas)
- `/var/www/dokuwiki/conf/` (konfigurasi, ACL, daftar akun)
- `/var/www/dokuwiki/lib/plugins/` (plugin terpasang)
- `/var/www/dokuwiki/lib/tpl/` (tema kustom)

Jalankan backup secara manual kapan saja:
```bash
sudo chmod +x backup.sh
sudo ./backup.sh
```

### 2. Penjadwalan Backup Berkala (Cron Job)
Untuk menjadwalkan pencadangan otomatis setiap tengah malam (pukul 02:00 WIB):
```bash
sudo crontab -e
```

Tambahkan baris berikut di baris paling bawah:
```cron
0 2 * * * /bin/bash /c/project/dokuwiki/backup.sh > /var/log/dokuwiki_backup.log 2>&1
```

### 3. Prosedur Pemulihan (*Restore*)
Jika terjadi kegagalan sistem atau data tidak sengaja terhapus, data dapat dipulihkan hanya dengan mengekstrak kembali arsip cadangan:
```bash
# Contoh pemulihan dari arsip backup
sudo tar -xzf /var/backups/dokuwiki/dokuwiki_backup_YYYYMMDD_HHMMSS.tar.gz -C /var/www/dokuwiki/
sudo chown -R www-data:www-data /var/www/dokuwiki
```

### 4. Pembersihan Cache Berkala
DokuWiki menyimpan *rendering cache* untuk mempercepat pemuatan halaman. Jika ada perubahan styling atau struktur yang belum muncul, cache dapat dibersihkan secara aman:
```bash
sudo rm -rf /var/www/dokuwiki/data/cache/*
```

---

## Pengisian Konten
[`^ kembali ke atas ^`](#)

Aplikasi web DokuWiki pada proyek ini diisi dengan konten terstruktur bertema **"Pusat Dokumentasi & Knowledge Base Laboratorium Komunikasi Data"**.

### Struktur Dokumen & Hierarki *Namespace*:
```text
[Root]
 ├── start (Halaman Utama / Beranda)
 ├── komdat:
 │    ├── topologi (Desain Topologi, Alamat IP & VLAN)
 │    ├── routing (Routing Statik, RIPv2, dan OSPF)
 │    ├── layanan (DNS Server BIND9, Web Server Apache, DHCP)
 │    └── keamanan (Firewall iptables/UFW, SSH Port Hardening)
 └── panduan:
      ├── instalasi (Panduan Deployment Self-Hosted)
      └── kontribusi (SOP Kontribusi & Aturan Penulisan Wiki)
```

### Fitur Konten yang Diimplementasikan:
1. **Hierarki Namespace:** Pengelompokan dokumen berdasarkan modul praktikum menggunakan namespace (`komdat:*`).
2. **Riwayat Revisi (Revision Diff):** Menunjukkan riwayat penyuntingan antar versi dan perbandingan perubahan baris per baris.
3. **Penyisipan Media:** Diagram topologi jaringan dan tangkapan layar konfigurasi server yang tersimpan di direktori `data/media/`.
4. **Tabel & Sintaks Kode Terformat:** Penataan tabel konfigurasi IP address dan *syntax highlighting* bash script di dalam halaman.

---

## Perbandingan Aplikasi Sejenis
[`^ kembali ke atas ^`](#)

Untuk memenuhi kriteria evaluasi tugas, dilakukan analisis perbandingan antara **DokuWiki** dengan tiga aplikasi manajemen pengetahuan / wiki *self-hosted* populer lainnya: **MediaWiki**, **BookStack**, dan **Wiki.js**.

### Tabel Matriks Komparasi

| Parameter Evaluasi | DokuWiki | MediaWiki | BookStack | Wiki.js |
| :--- | :--- | :--- | :--- | :--- |
| **Basis Arsitektur** | PHP (Flat-File Engine) | PHP (Relational DB) | PHP / Laravel | Node.js / Vue.js |
| **Kebutuhan Database** | **Tidak Ada** (Plain Text `.txt`) | **Wajib** (MySQL / MariaDB / PostgreSQL) | **Wajib** (MySQL / MariaDB) | **Wajib** (PostgreSQL / SQLite) |
| **Penggunaan Memori (RAM)** | **Sangat Rendah** (< 64 MB) | **Tinggi** (min. 512 MB - 1 GB + DB) | **Sedang** (min. 512 MB) | **Sedang** (min. 512 MB - 1 GB) |
| **Penyimpanan Konten** | Berkas teks UTF-8 terstruktur | Blob / Text dalam tabel database | Tabel database relasional | Database / Git Repository |
| **Kemudahan Backup & Migrasi** | **Sangat Mudah** (Cukup salin direktori berkas) | **Kompleks** (Perlu `mysqldump` + sinkronisasi file media) | **Sedang** (Backup database SQL + storage folder) | **Sedang** (Dump DB / Push Git sync) |
| **Dukungan Format Editor** | DokuWiki Syntax, Markdown (via plugin) | Wikitext syntax | WYSIWYG & Markdown bawaan | Markdown, Visual, HTML, AsciiDoc |
| **Kebutuhan Pemeliharaan Server** | **Minimal** (Tidak ada tuning query / indexing SQL) | **Tinggi** (Perlu maintenance index MySQL, tuning InnoDB) | **Sedang** (Maintenance dependensi Composer/Artisan) | **Sedang** (Maintenance Node modules & service daemon) |
| **Kecepatan Deployment** | Instan (< 5 menit, ekstrak dan langsung jalan) | Membutuhkan inisialisasi schema DB | Membutuhkan migrasi schema Laravel | Membutuhkan inisialisasi Node & DB |
| **Cocok Untuk** | Dokumentasi tim, manual teknis, knowledge base UKM/Lab, server berspesifikasi hemat | Ensiklopedia skala masif (seperti Wikipedia), komunitas terbuka raksasa | Dokumentasi terstruktur hirarkis buku-bab-halaman | Dokumentasi modern berbasis cloud/developer |

### Pembahasan & Analisis Kritis:

1. **Mengapa DokuWiki Unggul dalam Kasus Proyek Ini?**
   - **Ketahanan Sistem (*Reliability*):** Ketiadaan dependensi terhadap *database engine* mengeliminasi satu titik kegagalan utama (*single point of failure*). Gangguan seperti *database crash*, *lock timeout*, atau korupsi tabel tidak akan pernah terjadi pada DokuWiki.
   - **Kesesuaian Resource VM:** Pada skenario praktikum di mana mahasiswa menjalankan VM di laptop pribadi dengan RAM terbatas, DokuWiki hanya membutuhkan footprint memori puluhan megabyte, sehingga tidak memperberat kinerja laptop host.
   - **Transparansi Data:** Karena seluruh artikel disimpan dalam format teks biasa di folder `/data/pages/`, dokumen tetap dapat dibaca, diedit dengan editor terminal (`nano`/`vim`), ataupun di-grep secara langsung dari CLI meskipun web server sedang dalam keadaan mati (*offline access*).

2. **Kapan Sebaiknya Memilih Alternatif Lain?**
   - **MediaWiki:** Lebih tepat jika proyek membutuhkan fitur ensiklopedia kolaboratif publik dengan jutaan pengguna, halaman diskusi rumit, serta dukungan integrasi Wikidata.
   - **BookStack:** Lebih disukai oleh pengguna non-teknis yang menginginkan metafora pengorganisasian dokumen menyerupai buku fisik (*Shelf $\rightarrow$ Book $\rightarrow$ Chapter $\rightarrow$ Page*) dengan editor visual WYSIWYG yang sangat intuitif.
   - **Wiki.js:** Pilihan ideal bagi lingkungan pengembangan piranti lunak modern yang menginginkan sinkronisasi dua arah langsung ke repositori Git (GitHub/GitLab) dan antarmuka berbasis Single Page Application (SPA).

---

## Panduan Demo Pekan ke-7
[`^ kembali ke atas ^`](#)

Untuk menjamin perolehan nilai maksimal pada sesi **Presentasi dan Demo (bobot 50%)**, berikut adalah skenario alur demonstrasi yang disarankan:

### Skenario Demo (Durasi: 7 - 10 Menit)
```
[Menit 01-02] Pembukaan & Arsitektur Sistem:
              - Penjelasan latar belakang pemilihan DokuWiki (keunggulan Flat-File).
              - Menunjukkan topologi server di VM Ubuntu Server dan status service Apache2 & PHP.

[Menit 03-05] Fitur Inti & Demonstrasi Konten:
              - Menampilkan halaman beranda Knowledge Base Lab Komdat.
              - Mendemokan navigasi namespace (komdat:topologi, komdat:layanan).
              - Mendemokan pengeditan halaman secara langsung, penyisipan syntax highlighting kode, dan upload media topologi.
              - Memperlihatkan fitur Revision History & Diff perbandingan perubahan antar versi.

[Menit 06-07] Demonstrasi Kontrol Akses (ACL) & Keamanan:
              - Uji coba login sebagai user Mahasiswa (hanya bisa mengedit modul praktikum).
              - Uji coba akses anonymous (hanya bisa membaca halaman publik).
              - Pembuktian keamanan: Membuka URL direct ke http://ip-vm/data/pages/ dan memperlihatkan respon HTTP 403 Forbidden (proteksi direktori bekerja).

[Menit 08-09] Otomatisasi & Maintenance:
              - Menjalankan script backup.sh di terminal CLI.
              - Memperlihatkan file arsip .tar.gz yang terbentuk dan cron job yang terpasang.
              - Menunjukkan struktur direktori data/pages/ di terminal untuk membuktikan konsep flat-file.

[Menit 10]    Kesimpulan & Tanya Jawab:
              - Ringkasan komparasi DokuWiki vs CMS sejenis dan penutup.
```

---

## Referensi
[`^ kembali ke atas ^`](#)

1. **DokuWiki Official Documentation & Source Code:**
   - DokuWiki Project Website: [https://www.dokuwiki.org/](https://www.dokuwiki.org/)
   - GitHub Repository: [https://github.com/dokuwiki/dokuwiki](https://github.com/dokuwiki/dokuwiki)
   - DokuWiki System Requirements: [https://www.dokuwiki.org/requirements](https://www.dokuwiki.org/requirements)
   - Security & URL Rewriting Guide: [https://www.dokuwiki.org/security](https://www.dokuwiki.org/security)
2. **Kickball Awesome-Selfhosted Directory:**
   - Awesome-Selfhosted Wiki Engines: [https://github.com/Kickball/awesome-selfhosted#wikis](https://github.com/Kickball/awesome-selfhosted#wikis)
3. **Panduan Praktikum Komdat CS-IPB:**
   - Templat Laporan Proyek Komdat: [https://github.com/auriza/komdat-lab/blob/master/templat.md](https://github.com/auriza/komdat-lab/blob/master/templat.md)
   - Contoh Repositori Terbaik: [https://github.com/OneStyd/prestashop](https://github.com/OneStyd/prestashop)
