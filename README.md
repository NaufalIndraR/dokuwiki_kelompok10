# Aplikasi Web DokuWiki

Tugas Proyek Aplikasi Web Self-Hosted — Praktikum Komunikasi Data dan Jaringan Komputer (KDJK)  
Departemen Ilmu Komputer, IPB University

### Kelompok 10
- Naufal Indra Rizky (M0403241171)
- Nawra Ghaya Tsabita (M0403241173)
- Muhammad Farhan Assafari (M0403241176)
- Muhammad Aulia Alfarisi (M0403241193)

---

## 1. Sekilas Tentang

DokuWiki adalah aplikasi wiki open source berbasis PHP yang ditujukan untuk keperluan dokumentasi teknis, catatan tim, dan pembuatan basis pengetahuan (knowledge base).

Ciri khas utama DokuWiki dibandingkan kebanyakan sistem manajemen konten (CMS) lainnya adalah DokuWiki tidak membutuhkan database relasional SQL (seperti MySQL atau PostgreSQL). Seluruh halaman, riwayat revisi, dan metadata disimpan dalam bentuk berkas teks biasa (flat-file) di dalam sistem direktori server.

Karakteristik dan kelebihan DokuWiki:
- Hemat sumber daya: Penggunaan memori RAM sangat rendah (kurang dari 64 MB), sehingga sangat cocok dijalankan pada VM atau server berspesifikasi terbatas.
- Kemudahan pemeliharaan dan backup: Karena tidak memakai database terpisah, pencadangan data semudah menyalin direktori berkas.
- Kontrol versi bawaan: Setiap kali dokumen diperbarui, versi sebelumnya tetap tersimpan dan dapat dibandingkan perubahannya (diff) serta dikembalikan (rollback).
- Kontrol akses (ACL): Memiliki pengaturan izin berjenjang untuk membatasi siapa yang boleh membaca, mengedit, mengunggah file, atau mengelola sistem.

---

## 2. Instalasi

### Prasyarat Sistem
- Sistem Operasi: Linux (Ubuntu Server 22.04 / 24.04 LTS) atau container Docker di Dokploy
- Web Server: Apache 2.4 atau Nginx
- Bahasa Pemrograman: PHP versi 8.0 ke atas
- Ekstensi PHP: `php-xml`, `php-mbstring`, `php-gd`, `php-zip`, `php-curl`, `php-intl`
- Basis Data: Tidak memerlukan database SQL

### Cara 1: Instalasi Menggunakan Docker Compose (Dokploy)
Repositori ini menyediakan berkas `docker-compose.yml` untuk mempermudah proses deployment:

1. Clone repositori ke server atau hubungkan ke Dokploy:
   ```bash
   git clone https://github.com/NaufalIndraR/dokuwiki_kelompok10.git
   cd dokuwiki_kelompok10
   ```

2. Jalankan service menggunakan Docker Compose:
   ```bash
   docker compose up -d
   ```

3. Buka peramban dan akses alamat server:
   ```text
   http://<IP-SERVER>/install.php
   ```

4. Lengkapi formulir setup awal (nama wiki, akun admin, serta kebijakan ACL), lalu simpan.

---

### Cara 2: Instalasi Manual CLI di Ubuntu Server (Native Apache2)

Langkah-langkah instalasi manual pada sistem operasi Ubuntu Server:

1. Perbarui repositori sistem:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. Install web server Apache2 dan peralatan pendukung:
   ```bash
   sudo apt install -y apache2 libapache2-mod-php curl wget tar
   ```

3. Install PHP beserta pustaka ekstensi yang dibutuhkan DokuWiki:
   ```bash
   sudo apt install -y php php-cli php-gd php-xml php-mbstring php-zip php-curl php-intl
   ```

4. Unduh rilis stabil resmi DokuWiki:
   ```bash
   cd /tmp
   wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
   ```

5. Ekstrak berkas ke direktori web `/var/www/dokuwiki`:
   ```bash
   sudo mkdir -p /var/www/dokuwiki
   sudo tar -xzf dokuwiki-stable.tgz -C /var/www/dokuwiki --strip-components=1
   ```

6. Atur izin kepemilikan berkas untuk pengguna web server (`www-data`):
   ```bash
   sudo chown -R www-data:www-data /var/www/dokuwiki
   sudo chmod -R 775 /var/www/dokuwiki/data
   sudo chmod -R 775 /var/www/dokuwiki/conf
   sudo chmod -R 775 /var/www/dokuwiki/lib/plugins
   sudo chmod -R 775 /var/www/dokuwiki/lib/tpl
   ```

7. Aktifkan modul `rewrite` Apache:
   ```bash
   sudo a2enmod rewrite
   ```

8. Buat berkas konfigurasi VirtualHost Apache:
   ```bash
   sudo nano /etc/apache2/sites-available/dokuwiki.conf
   ```

   Tambahkan konfigurasi berikut:
   ```apache
   <VirtualHost *:80>
       ServerAdmin admin@localhost
       DocumentRoot /var/www/dokuwiki

       <Directory /var/www/dokuwiki>
           Options -Indexes +FollowSymLinks
           AllowOverride All
           Require all granted
       </Directory>

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

9. Aktifkan situs VirtualHost dan reload Apache:
   ```bash
   sudo a2ensite dokuwiki.conf
   sudo a2dissite 000-default.conf
   sudo systemctl reload apache2
   ```

10. Buka browser ke `http://<IP-SERVER>/install.php` untuk menyelesaikan inisialisasi awal. Setelah selesai, hapus file installer demi alasan keamanan:
    ```bash
    sudo rm -f /var/www/dokuwiki/install.php
    ```

---

## 3. Konfigurasi

### Penyesuaian Batas Upload dan Memori PHP
Untuk menunjang pengunggahan berkas modul praktikum berukuran lebih besar, sesuaikan pengaturan pada `php.ini`:

```bash
sudo nano /etc/php/8.x/apache2/php.ini
```

Sesuaikan nilai-nilai berikut:
```ini
upload_max_filesize = 32M
post_max_size = 32M
memory_limit = 256M
max_execution_time = 120
```

Terapkan perubahan dengan me-restart web server:
```bash
sudo systemctl restart apache2
```

### Mengaktifkan Nice URLs (Clean URLs)
Agar URL halaman wiki menjadi lebih bersih (tanpa parameter `doku.php?id=`):
1. Masuk ke DokuWiki sebagai Admin -> pilih menu **Admin** -> **Configuration Settings**.
2. Pada bagian **Advanced**, ubah opsi `userewrite` menjadi `Apache .htaccess` (nilai `1`).
3. Pastikan berkas `.htaccess` sudah aktif di server:
   ```bash
   cd /var/www/dokuwiki
   sudo cp .htaccess.dist .htaccess
   ```

### Pengaturan Hak Akses (ACL)
Pengelolaan hak akses dilakukan melalui menu **Admin** -> **Access Control List Management**:
- Pengunjung tanpa login (@ALL): Diberikan izin hanya membaca (Read).
- Akun mahasiswa (@user): Diberikan izin membaca dan mengedit halaman (Read & Edit).
- Administrator (@admin): Diberikan hak akses penuh pengelolaan wiki.

### Plugin Tambahan
Beberapa plugin yang dapat ditambahkan melalui menu **Admin** -> **Extension Manager**:
- **Markdowku**: Memungkinkan penulisan dokumen menggunakan format Markdown standar selain sintaks bawaan DokuWiki.
- **Bootstrap3 Template**: Mengubah tampilan antarmuka wiki menjadi lebih modern dan responsif untuk layar ponsel.
- **Tag Plugin**: Memberikan fitur kategori/tagar pada setiap artikel untuk mempermudah pencarian topik.

---

## 4. Maintenance

### Script Backup Otomatis
Karena DokuWiki berbasis berkas teks biasa, proses pencadangan data cukup dilakukan dengan mengarsipkan folder `data`, `conf`, `lib/plugins`, dan `lib/tpl`. Repositori ini telah menyediakan script `backup.sh` untuk keperluan tersebut.

Perintah inti yang dijalankan oleh script:
```bash
tar -czf /var/backups/dokuwiki_backup_$(date +%Y%m%d_%H%M%S).tar.gz \
    -C /var/www/dokuwiki data conf lib/plugins lib/tpl
```

### Penjadwalan Backup Berkala (Cron Job)
Untuk menjalankan proses backup secara terjadwal setiap malam pukul 02.00:

1. Buka konfigurasi crontab:
   ```bash
   sudo crontab -e
   ```

2. Tambahkan baris jadwal berikut:
   ```cron
   0 2 * * * /bin/bash /c/project/dokuwiki/backup.sh > /dev/null 2>&1
   ```

### Prosedur Pemulihan (Restore)
Jika terjadi kehilangan atau kerusakan data, pemulihan dilakukan dengan mengekstrak kembali file arsip backup:
```bash
sudo tar -xzf /var/backups/dokuwiki_backup_YYYYMMDD_HHMMSS.tar.gz -C /var/www/dokuwiki/
sudo chown -R www-data:www-data /var/www/dokuwiki
```

---

## 5. Pengisian Konten Aplikasi Web

Dokumentasi yang dimasukkan ke dalam DokuWiki bertema pusat informasi laboratorium jaringan:
- **Halaman Utama (start)**: Pengenalan basis pengetahuan, navigasi modul, dan informasi Kelompok 10.
- **Modul 1 (komdat:topologi)**: Desain topologi jaringan laboratorium, subnetting IPv4, dan pemisahan VLAN.
- **Modul 2 (komdat:routing)**: Konfigurasi rute jaringan statik serta protokol dinamis (OSPF dan RIP).
- **Modul 3 (komdat:layanan)**: Panduan konfigurasi layanan server Linux (DNS BIND9, DHCP Server, dan Web Server).
- **Modul 4 (komdat:keamanan)**: Penerapan aturan firewall (iptables/UFW) dan pengamanan port SSH.

---

## 6. Perbandingan dengan Aplikasi Sejenis

Berikut perbandingan DokuWiki dengan aplikasi wiki dan dokumentasi self-hosted lainnya:

| Parameter | DokuWiki | MediaWiki | BookStack |
| --- | --- | --- | --- |
| Bahasa / Framework | PHP Native | PHP Native | PHP (Laravel) |
| Kebutuhan Database | Tidak ada (Flat-file `.txt`) | Wajib (MySQL / MariaDB) | Wajib (MySQL / MariaDB) |
| Konsumsi RAM | Sangat rendah (< 64 MB) | Tinggi (karena dependensi MySQL) | Sedang (~256 - 512 MB) |
| Metode Backup | Cukup copy/tar folder data | Dump database SQL + backup media | Dump database SQL + folder file |
| Format Penulisan | DokuWiki markup, Markdown | Wikitext markup | WYSIWYG editor & Markdown |
| Pengorganisasian | Namespace (hierarki direktori) | Kategori dan link internal | Hierarki Buku, Bab, Halaman |
| Kemudahan Setup | Sangat cepat (langsung jalan) | Memerlukan migrasi database | Memerlukan migrasi Laravel & database |

### Pembahasan
DokuWiki sangat tepat untuk proyek praktikum dan dokumentasi internal tim kecil karena kesederhanaan arsitekturnya. Tidak adanya ketergantungan pada database SQL meminimalisir risiko kegagalan sistem akibat crash database. 

Sebagai perbandingan, MediaWiki memiliki fitur yang sangat lengkap untuk komunitas raksasa terbuka seperti Wikipedia, namun relatif berat dan rumit untuk dokumentasi skala laboratorium. Sedangkan BookStack menawarkan antarmuka yang sangat rapi menyerupai buku fisik, namun membutuhkan pengaturan server dan database yang lebih kompleks.

---

## 7. Referensi

1. Situs Resmi DokuWiki: https://www.dokuwiki.org/
2. Dokumentasi Instalasi DokuWiki: https://www.dokuwiki.org/install
3. Repositori Source Code DokuWiki: https://github.com/dokuwiki/dokuwiki
4. Daftar Aplikasi Self-Hosted: https://github.com/Kickball/awesome-selfhosted#wikis
5. Templat Laporan Praktikum Komdat: https://github.com/auriza/komdat-lab/blob/master/templat.md
