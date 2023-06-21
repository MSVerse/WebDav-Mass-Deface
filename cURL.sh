#!/bin/bash

# MIT License
# 
# Copyright (c) [2023] [MSVerse]
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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

# Mengunggah file ke setiap URL secara paralel
cat "$url_list" | parallel -j 4 --timeout 10 "upload_file {}"

# Fungsi untuk mengunggah file ke URL menggunakan curl
upload_file() {
  url="$1"
  
  # Mengunggah file ke URL menggunakan curl
  result=$(curl --max-time 10 --write-out "%{http_code}\n" --silent --output /dev/null -T "$file_to_upload" "$url")

  if [ $result -eq 201 ] || [ $result -eq 204 ] || [ $result -eq 200 ]; then
    echo -e "Upload berhasil ke $url"
    echo ""
  else
    echo -e "Upload gagal ke $url"
    echo ""
  fi
}
