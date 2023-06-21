#!/bin/bash

# Menyimpan argumen dalam variabel
file_to_upload="$1"
url_list="$2"

# Memeriksa apakah argumen telah diberikan
if [ -z "$file_to_upload" ] || [ -z "$url_list" ]; then
  echo "Usage: ./cURL.sh <file_to_upload> <url_list>"
  exit 1
fi

# Memeriksa keberadaan file yang akan diunggah
if [ ! -f "$file_to_upload" ]; then
  echo "File '$file_to_upload' tidak ditemukan."
  exit 1
fi

# Memeriksa keberadaan file daftar URL
if [ ! -f "$url_list" ]; then
  echo "File '$url_list' tidak ditemukan."
  exit 1
fi

# Mengunggah file ke setiap URL
while IFS= read -r url
do
  # Mengunggah file ke URL menggunakan curl
  result=$(curl --max-time 10 --write-out "%{http_code}\n" --silent --output /dev/null -T "$file_to_upload" "$url")

  if [ $result -eq 201 ] || [ $result -eq 204 ] || [ $result -eq 200 ]; then
    echo -e "Upload berhasil ke $url"
    echo ""
  else
    echo -e "Upload gagal ke $url"
    echo ""
  fi
done < "$url_list"
