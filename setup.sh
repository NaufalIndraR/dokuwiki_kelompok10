#!/bin/bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}   Script Instalasi Otomatis DokuWiki (LAMP Stack)  ${NC}"
echo -e "${BLUE}====================================================${NC}"

if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Harap jalankan script ini dengan hak akses sudo atau root:${NC}"
  echo "  sudo bash setup.sh"
  exit 1
fi

echo -e "${YELLOW}Masukkan Domain Name atau Alamat IP VM Anda (contoh: 192.168.56.101 atau dokuwiki.local):${NC}"
read -r -p "Domain / IP: " SERVER_NAME

if [ -z "$SERVER_NAME" ]; then
    SERVER_NAME="localhost"
    echo -e "${YELLOW}[INFO] Menggunakan default: localhost${NC}"
fi

WEB_ROOT="/var/www/dokuwiki"

echo -e "\n${BLUE}[1/7] Memperbarui repositori paket Ubuntu...${NC}"
apt-get update -y

echo -e "\n${BLUE}[2/7] Menginstal Apache2 Web Server...${NC}"
apt-get install -y apache2 libapache2-mod-php curl wget tar

echo -e "\n${BLUE}[3/7] Menginstal PHP dan ekstensi pendukung (XML, GD, Mbstring, Zip, Intl)...${NC}"
apt-get install -y php php-cli php-fpm php-gd php-xml php-mbstring php-zip php-curl php-intl

echo -e "\n${BLUE}[4/7] Mengunduh rilis stabil DokuWiki terbaru...${NC}"
DOKUWIKI_URL="https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"
TEMP_TAR="/tmp/dokuwiki-stable.tgz"

wget -q --show-progress "$DOKUWIKI_URL" -O "$TEMP_TAR"

echo -e "\n${BLUE}[5/7] Mengekstrak DokuWiki ke ${WEB_ROOT}...${NC}"
mkdir -p "$WEB_ROOT"
tar -xzf "$TEMP_TAR" -C "$WEB_ROOT" --strip-components=1
rm -f "$TEMP_TAR"

if [ -d "./sample-content" ]; then
    echo -e "${BLUE}[INFO] Memuat konten modul praktikum ke ${WEB_ROOT}/data/pages/...${NC}"
    [ -f "./sample-content/start.txt" ] && cp ./sample-content/start.txt "$WEB_ROOT/data/pages/"
    [ -d "./sample-content/komdat" ] && cp -r ./sample-content/komdat "$WEB_ROOT/data/pages/"
    if [ -d "./sample-content/conf" ]; then
        echo -e "${BLUE}[INFO] Memuat konfigurasi dan akun pengguna ke ${WEB_ROOT}/conf/...${NC}"
        cp -r ./sample-content/conf/* "$WEB_ROOT/conf/"
    fi
fi

echo -e "\n${BLUE}[6/7] Mengatur kepemilikan dan hak akses (chown & chmod)...${NC}"
chown -R www-data:www-data "$WEB_ROOT"
find "$WEB_ROOT" -type d -exec chmod 755 {} \;
find "$WEB_ROOT" -type f -exec chmod 644 {} \;

chmod -R 775 "$WEB_ROOT/data"
chmod -R 775 "$WEB_ROOT/conf"
chmod -R 775 "$WEB_ROOT/lib/plugins"
chmod -R 775 "$WEB_ROOT/lib/tpl"

echo -e "\n${BLUE}[7/7] Membuat konfigurasi Apache VirtualHost...${NC}"
a2enmod rewrite

APACHE_CONF="/etc/apache2/sites-available/dokuwiki.conf"

cat <<EOF > "$APACHE_CONF"
<VirtualHost *:80>
    ServerAdmin admin@${SERVER_NAME}
    ServerName ${SERVER_NAME}
    DocumentRoot ${WEB_ROOT}

    <Directory ${WEB_ROOT}>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <Directory ${WEB_ROOT}/data>
        Require all denied
    </Directory>
    <Directory ${WEB_ROOT}/conf>
        Require all denied
    </Directory>
    <Directory ${WEB_ROOT}/bin>
        Require all denied
    </Directory>
    <Directory ${WEB_ROOT}/inc>
        Require all denied
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/dokuwiki_error.log
    CustomLog \${APACHE_LOG_DIR}/dokuwiki_access.log combined
</VirtualHost>
EOF

a2ensite dokuwiki.conf
systemctl reload apache2

PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
PHP_INI="/etc/php/${PHP_VERSION}/apache2/php.ini"

if [ -f "$PHP_INI" ]; then
    echo -e "${BLUE}[INFO] Menyesuaikan batas upload dan memori pada $PHP_INI...${NC}"
    sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 32M/' "$PHP_INI"
    sed -i 's/^post_max_size = .*/post_max_size = 32M/' "$PHP_INI"
    sed -i 's/^memory_limit = .*/memory_limit = 256M/' "$PHP_INI"
    sed -i 's/^max_execution_time = .*/max_execution_time = 120/' "$PHP_INI"
    systemctl restart apache2
fi

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}   INSTALASI DOKUWIKI BERHASIL DISELESAIKAN!       ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo -e "Silakan buka browser Anda dan akses tautan instalasi berikut:"
echo -e "${YELLOW}  http://${SERVER_NAME}/install.php${NC}"
echo -e "\nLangkah selanjutnya setelah instalasi web selesai:"
echo -e "1. Isi nama Wiki, akun superuser/administrator, dan tipe kebijakan ACL."
echo -e "2. Setelah selesai, hapus file ${WEB_ROOT}/install.php untuk alasan keamanan:"
echo -e "   ${YELLOW}sudo rm -f ${WEB_ROOT}/install.php${NC}"
echo -e "3. Akses Wiki Anda di: ${YELLOW}http://${SERVER_NAME}/${NC}"
echo -e "====================================================\n"
