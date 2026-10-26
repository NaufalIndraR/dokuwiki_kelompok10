---
marp: true
theme: default
paginate: true
header: "Praktikum Komdat 2026 — Kelompok 10"
footer: "Proyek Akhir Aplikasi Web Self-Hosted: DokuWiki"
style: |
  section {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    padding: 40px;
    background: #f8fafc;
  }
  h1 {
    color: #1e3a8a;
  }
  h2 {
    color: #0284c7;
  }
  table {
    font-size: 16px;
  }
  th {
    background-color: #0284c7;
    color: white;
  }
---

# Proyek Aplikasi Web Self-Hosted: DokuWiki
### Knowledge Base & Dokumentasi Jaringan Laboratorium Komdat
**Praktikum Komunikasi Data dan Jaringan Komputer (KDJK)**  
Departemen Ilmu Komputer — IPB University

**Kelompok 10:**
* Naufal Indra Rizky (M0403241171)
* Nawra Ghaya Tsabita (M0403241173)
* Muhammad Farhan Assafari (M0403241176)
* Muhammad Aulia Alfarisi (M0403241193)

---

## 1. Latar Belakang & Pemilihan Aplikasi

* **Kategori Sumber:** Awesome-Selfhosted ([Wikis Category](https://github.com/Kickball/awesome-selfhosted#wikis)).
* **Kebutuhan:** Laboratorium Komdat membutuhkan sistem dokumentasi terpusat untuk topologi, panduan modul praktikum, dan konfigurasi server yang ringan, cepat, dan mudah dipelihara.
* **Legalitas:** 100% Legal & Open Source (Lisensi GNU General Public License v2 — Bebas dari isu piracy/copyright).
* **Bandingan Aplikasi Asli:** DokuWiki dipilih sebagai alternatif ringan terhadap **MediaWiki** (mesin di balik Wikipedia) dan **BookStack**.

---

## 2. Arsitektur Flat-File DokuWiki

Mengapa DokuWiki ideal untuk infrastruktur laboratorium dan server berspesifikasi terbatas?

* **No SQL Database:** Tidak memerlukan service MySQL/PostgreSQL terpisah. Seluruh artikel, metadata, dan riwayat revisi disimpan dalam bentuk berkas teks biasa (`.txt`).
* **Sangat Hemat Memori:** Konsumsi RAM operasional di bawah **64 MB**, cocok untuk VPS mikro / VM berspesifikasi rendah.
* **Resiliensi Tinggi:** Bebas risiko kegagalan sistem akibat crash database engine atau koneksi pool MySQL yang terputus.
* **Built-in Revision Control:** Setiap perubahan dokumen otomatis mencatat diff dan memungkinkan rollback instan.

---

## 3. Lingkungan & Topologi Deployment

Kami menyediakan 2 metode deployment yang fleksibel dan teruji:

1. **Production Docker Compose (Dokploy / VPS):**
   * Menggunakan container `lscr.io/linuxserver/dokuwiki:latest`.
   * Port mapping `8080:80` dengan volume persisten `dokuwiki_config`.
   * Terintegrasi dengan reverse proxy SSL/TLS.
2. **Native LAMPP Stack di Ubuntu Server 22.04 / 24.04 LTS:**
   * Apache 2.4 dengan modul `mod_rewrite`.
   * PHP 8.x dengan ekstensi XML, GD, Mbstring, Zip, Intl, dan Curl.
   * VirtualHost dengan proteksi direktori sensitif (`data`, `conf`, `bin`, `inc`).

---

## 4. Langkah Instalasi CLI & Docker

### A. Docker Compose (Dokploy)
```bash
git clone https://github.com/NaufalIndraR/dokuwiki_kelompok10.git
cd dokuwiki_kelompok10
docker compose up -d
```

### B. Otomasi CLI Ubuntu (setup.sh)
Kami membuat skrip `setup.sh` yang mengeksekusi instalasi end-to-end secara otomatis:
```bash
sudo bash setup.sh
```
Skrip otomatis memperbarui paket APT, menginstal Apache2 & PHP, mengunduh rilis resmi DokuWiki, mengatur permission `775/644`, membuat Apache VirtualHost, dan memuat konten modul lab.

---

## 5. Konfigurasi Kritis & Keamanan

* **Optimasi PHP (`php.ini`):**
  * `upload_max_filesize = 32M` & `post_max_size = 32M` (untuk file modul & media lab).
  * `memory_limit = 256M` & `max_execution_time = 120s`.
* **Clean URLs (Nice URLs):**
  * Mengaktifkan Apache `mod_rewrite` dan `.htaccess` agar URL bersih tanpa `doku.php?id=`.
* **Access Control List (ACL) Berjenjang:**
  * `@ALL` (Publik / Tamu): Read-only pada modul publik.
  * `@user` (Mahasiswa Praktikan): Read & Edit artikel praktikum.
  * `@admin` (Asisten Lab / Dosen): Hak akses penuh ke Extension Manager & Config.
* **Proteksi Direktori Direktori Sensitif:**
  * `Require all denied` pada folder `data/`, `conf/`, `bin/`, dan `inc/`.

---

## 6. Maintenance & Backup Otomatis

Karena arsitektur flat-file, pencadangan data semudah mengompres direktori berkas tanpa perlu `mysqldump`:

* **Skrip `backup.sh`:**
  ```bash
  tar -czf /var/backups/dokuwiki/dokuwiki_backup_$(date +%Y%m%d_%H%M%S).tar.gz \
      --exclude="/var/www/dokuwiki/data/cache/*" \
      -C /var/www/dokuwiki data conf lib/plugins lib/tpl
  ```
* **Otomasi Terjadwal (Cron Job):**
  Berjalan otomatis setiap malam pukul 02.00 WIB dengan retensi 14 hari pembersihan arsip lama:
  ```cron
  0 2 * * * /bin/bash /var/www/dokuwiki/backup.sh > /dev/null 2>&1
  ```
* **Disaster Recovery:** Restore semudah mengekstrak tarball kembali ke direktori web.

---

## 7. Pengisian Konten: Knowledge Base Lab Komdat

Wiki telah diisi dengan modul praktikum jaringan riil:

* **Halaman Utama (`start`):** Pengenalan laboratorium, navigasi modul, dan identitas Kelompok 10.
* **Modul 1 (`komdat:topologi`):** Desain topologi jaringan bintang hierarkis, skema subnetting VLSM `192.168.10.0/24`, dan konfigurasi VLAN 802.1Q.
* **Modul 2 (`komdat:routing`):** Inter-VLAN routing, forwarding kernel Linux, dan dynamic routing OSPF Area 0 dengan FRRouting.
* **Modul 3 (`komdat:layanan`):** Konfigurasi server DNS BIND9 otoritatif (`labkomdat.ipb.ac.id`), DHCP Server, dan Web Server internal.
* **Modul 4 (`komdat:keamanan`):** Pengerasan firewall stateful (UFW/iptables), SSH key authentication (port 2222), dan proteksi brute force Fail2Ban.

---

## 8. Komparasi: DokuWiki vs Aplikasi Sejenis

| Parameter | DokuWiki (Pilihan Kami) | MediaWiki (Wikipedia) | BookStack |
| :--- | :--- | :--- | :--- |
| **Arsitektur Data** | **Flat-file (`.txt`)** | Database SQL (MySQL/MariaDB) | Database SQL (MySQL/MariaDB) |
| **Konsumsi RAM** | **< 64 MB (Sangat Ringan)** | > 256 MB (Tinggi) | ~128 - 256 MB (Sedang) |
| **Metode Backup** | **Cukup arsip tar folder berkas** | Dump database SQL + backup media | Dump SQL + folder storage |
| **Format Editor** | DokuWiki Markup / Markdown | Wikitext Markup | WYSIWYG Editor & Markdown |
| **Struktur Konten**| Hierarki Namespace tak terbatas | Kategori dan namespace datar | Hierarki kaku: Shelf > Book > Chapter > Page |
| **Keandalan** | **Tidak ada risiko DB crash** | Bergantung ketersediaan MySQL | Bergantung ketersediaan MySQL |

---

## 9. Pembahasan & Keunggulan Komparatif

1. **Dibandingkan MediaWiki:**
   * MediaWiki sangat kuat untuk ensiklopedia terbuka berskala masif (jutaan artikel), tetapi overhead konfigurasinya terlalu rumit dan memakan resource berlebih untuk kebutuhan laboratorium.
2. **Dibandingkan BookStack:**
   * BookStack memiliki UI visual modern menyerupai buku fisik, namun membatasi struktur navigasi menjadi Rak -> Buku -> Bab -> Halaman, sementara DokuWiki memberikan kebebasan hierarki namespace yang jauh lebih fleksibel untuk berbagai subtopik jaringan.
3. **Kesimpulan Komparasi:**
   * DokuWiki adalah solusi paling optimal dari segi rasio performa-ke-sumber-daya (*performance-to-resource ratio*) untuk dokumentasi teknis laboratorium.

---

## 10. Pembagian Tugas Kelompok 10

| Nama Mahasiswa | NIM | Tanggung Jawab & Kontribusi |
| :--- | :--- | :--- |
| **Naufal Indra Rizky** | M0403241171 | Lead Deployment, Docker Compose, Dokploy Hosting & Reverse Proxy |
| **Nawra Ghaya Tsabita** | M0403241173 | Penyusunan Konten Modul Lab Komdat & Riset Komparasi Aplikasi |
| **Muhammad Farhan Assafari** | M0403241176 | Pengembangan Skrip Otomasi Instalasi (`setup.sh`) & Skrip Backup Cron |
| **Muhammad Aulia Alfarisi** | M0403241193 | Konfigurasi Web Server Apache2, ACL Permission, & Penyusunan Slide Demo |

---

## 11. Kesimpulan

* DokuWiki berhasil di-deploy pada VPS / Dokploy dan dapat diakses dengan performa responsif.
* Arsitektur flat-file membuktikan efisiensi memori yang luar biasa (< 64 MB RAM) dan kemudahan disaster recovery.
* Dokumentasi repositori GitHub telah memenuhi seluruh kriteria template `auriza/komdat-lab` (sekilas, instalasi CLI, konfigurasi server, maintenance otomatis, dan komparasi aplikasi sejenis).
* Konten aplikasi web telah terisi lengkap dengan materi praktikum jaringan laboratorium.

---

# Terima Kasih!
### Sesi Tanya Jawab (Q&A)

**Repositori Proyek:**  
[https://github.com/NaufalIndraR/dokuwiki_kelompok10](https://github.com/NaufalIndraR/dokuwiki_kelompok10)
