#!/bin/bash
# ==============================================================================
# Script Otomasi Backup & Maintenance DokuWiki
# Proyek Praktikum Komunikasi Data - CS IPB
# Menyimpan arsip data, konfigurasi, dan plugin DokuWiki secara berkala
# ==============================================================================

set -e

# Lokasi instalasi DokuWiki dan direktori penyimpanan backup
DOKUWIKI_DIR="/var/www/dokuwiki"
BACKUP_DIR="/var/backups/dokuwiki"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/dokuwiki_backup_${TIMESTAMP}.tar.gz"
RETENTION_DAYS=14 # Simpan backup selama 14 hari terakhir

# Pastikan folder tujuan backup tersedia
mkdir -p "$BACKUP_DIR"

echo "================================================="
echo "   Memulai Proses Backup DokuWiki: $(date)       "
echo "================================================="

if [ ! -d "$DOKUWIKI_DIR" ]; then
    echo "[ERROR] Direktori DokuWiki di $DOKUWIKI_DIR tidak ditemukan!"
    exit 1
fi

# DokuWiki menggunakan flat-file (tanpa database SQL terpisah).
# Komponen terpenting yang wajib dibackup:
# - data/ (halaman wiki, attic/revisi, media, cache, meta)
# - conf/ (konfigurasi sistem, daftar pengguna, ACL)
# - lib/plugins/ (plugin tambahan yang terpasang)
# - lib/tpl/ (tema kustom yang terpasang)

echo "[INFO] Mengarsipkan folder data, conf, plugin, dan template..."
tar -czf "$BACKUP_FILE" \
    --exclude="${DOKUWIKI_DIR}/data/cache/*" \
    -C "$DOKUWIKI_DIR" \
    data conf lib/plugins lib/tpl

echo "[SUKSES] File backup berhasil dibuat:"
ls -lh "$BACKUP_FILE"

# Pembersihan backup lama melampaui masa retensi
echo "[INFO] Menghapus backup lama yang berusia lebih dari ${RETENTION_DAYS} hari..."
find "$BACKUP_DIR" -name "dokuwiki_backup_*.tar.gz" -mtime +${RETENTION_DAYS} -exec rm -f {} \;

echo "================================================="
echo "   Proses Backup Selesai dengan Sukses!          "
echo "================================================="
