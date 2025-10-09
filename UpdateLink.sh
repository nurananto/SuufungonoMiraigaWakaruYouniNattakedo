#!/bin/bash
# ============================================
#  UpdateLink.sh (Clean & Auto Repo Version)
#  by Ananto + ChatGPT
# ============================================

USERNAME="nurananto"
# Tentukan lokasi folder script secara aman untuk Git Bash di Windows
if [ -n "${BASH_SOURCE[0]}" ]; then
    SCRIPT_PATH="${BASH_SOURCE[0]}"
else
    SCRIPT_PATH="$0"
fi

SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
REPO="$(basename "$SCRIPT_DIR")"

BRANCH="main"

# Tampilkan info repo
echo "============================================="
echo "👤 Username GitHub : $USERNAME"
echo "📂 Repository      : $REPO"
echo "🌿 Branch          : $BRANCH"
echo "============================================="

while true; do
    echo "Pilih mode:"
    echo "1. Generate semua folder"
    echo "2. Pilih folder tertentu"
    echo "============================================="
    read -rp "Masukkan pilihan (1/2): " mode

    # --------------------------------------------------------
    # MODE 1 - Semua folder
    # --------------------------------------------------------
    if [ "$mode" == "1" ]; then
        echo "🔄 Membuat link untuk semua folder..."
        for folder in */; do
            [ -d "$folder" ] || continue
            folder=${folder%/}

            output="$folder/$folder.txt"
            echo "" > "$output"

            echo "📁 Folder: $folder"
            count=0

            # Urutkan file agar berurutan nama/angka
            for f in $(find "$folder" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort -V); do
                fname=$(basename "$f")
                encoded_folder=$(echo "$folder" | sed 's/ /%20/g')
                echo "https://raw.githubusercontent.com/$USERNAME/$REPO/$BRANCH/$encoded_folder/$fname" >> "$output"
                ((count++))
            done

            # Bersihkan baris kosong & hapus newline terakhir
            awk 'NF {a[++n]=$0} END {for (i=1; i<=n; i++) print a[i]}' "$output" > "$output.tmp" && mv "$output.tmp" "$output"

            echo "✅ $count file diproses → $output"
            echo
        done
        echo "🎉 Semua folder selesai diproses."
        break

    # --------------------------------------------------------
    # MODE 2 - Pilih folder tertentu
    # --------------------------------------------------------
    elif [ "$mode" == "2" ]; then
        while true; do
            read -rp "Masukkan nama folder chapter (contoh: 1 atau 2.1): " CHAPTER
            if [ ! -d "$CHAPTER" ]; then
                echo "❌ Folder '$CHAPTER' tidak ditemukan. Coba lagi."
                continue
            fi

            output="$CHAPTER/$CHAPTER.txt"
            echo "" > "$output"
            count=0

            # Urutkan file di dalam folder
            for f in $(find "$CHAPTER" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort -V); do
                fname=$(basename "$f")
                encoded_folder=$(echo "$CHAPTER" | sed 's/ /%20/g')
                echo "https://raw.githubusercontent.com/$USERNAME/$REPO/$BRANCH/$encoded_folder/$fname" >> "$output"
                ((count++))
            done

            # Hapus baris kosong & newline terakhir
            awk 'NF {a[++n]=$0} END {for (i=1; i<=n; i++) print a[i]}' "$output" > "$output.tmp" && mv "$output.tmp" "$output"

            echo "✅ $count file diproses → $output"
            echo

            read -rp "Apakah ingin generate folder lain? (y/n): " jawab
            [ "$jawab" == "y" ] || break
        done
        break

    else
        echo "❌ Pilihan tidak valid."
    fi
done

echo "Selesai 👍"
