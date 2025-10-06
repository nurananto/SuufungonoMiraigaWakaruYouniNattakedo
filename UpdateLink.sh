#!/bin/bash

# ==== KONFIGURASI ====
USERNAME="nurananto"              # ganti dengan username GitHub kamu
REPO="SuufungonoMiraigaWakaruYouniNattakedo"        # ganti dengan nama repo kamu
BRANCH="main"                    # biasanya "main" atau "master"

while true; do
    # 1. Tanya folder
    echo "Masukkan nama folder chapter (contoh: Ch001 - Judul Chapter 1):"
    read CHAPTER

    # cek folder ada atau tidak
    if [ ! -d "$CHAPTER" ]; then
        echo "❌ Folder '$CHAPTER' tidak ditemukan. Coba lagi."
        continue
    fi

    # 2. Buat output di dalam folder itu
    OUTPUT="$CHAPTER/links.txt"
    echo "" > "$OUTPUT"

    # 3. Loop semua gambar (jpg, png, webp, dll)
    for f in "$CHAPTER"/*.{jpg,jpeg,png,webp}; do
        # skip kalau file ga ada
        [ -e "$f" ] || continue

        fname=$(basename "$f")
        folder=$(echo "$CHAPTER" | sed 's/ /%20/g')
        echo "https://raw.githubusercontent.com/$USERNAME/$REPO/$BRANCH/$folder/$fname" >> "$OUTPUT"
    done

    echo "✅ Link sudah dibuat di $OUTPUT"

    # 4. Tanya mau lanjut?
    echo "Apakah ingin generate folder lain? (y/n)"
    read jawab
    if [ "$jawab" != "y" ]; then
        echo "Selesai 👍"
        break
    fi
done