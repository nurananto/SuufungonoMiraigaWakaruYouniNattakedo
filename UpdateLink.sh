#!/bin/bash
# ==========================================================
#  UpdateLink.sh - Versi Final (Git Bash Safe + Clean Output)
#  by Ananto & ChatGPT
# ==========================================================

USERNAME="nurananto"
BRANCH="main"

# Aman untuk Git Bash & Linux: deteksi lokasi file ini
if [ -n "${BASH_SOURCE[0]}" ]; then
    SCRIPT_PATH="${BASH_SOURCE[0]}"
else
    SCRIPT_PATH="$0"
fi

SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
REPO="$(basename "$SCRIPT_DIR")"

# ==========================================================
# Tampilkan info repo
# ==========================================================
echo "============================================="
echo "👤 Username GitHub : $USERNAME"
echo "📂 Repository      : $REPO"
echo "🌿 Branch          : $BRANCH"
echo "============================================="

# ==========================================================
# Fungsi untuk generate link dari satu folder
# ==========================================================
generate_links() {
    local CHAPTER="$1"
    local output="$CHAPTER/$CHAPTER.txt"

    echo ""
    echo "📁 Memproses folder: $CHAPTER ..."
    > "$output"  # kosongkan dulu file output
    local count=0

    # Temukan hanya file gambar yang valid dan urutkan
    while IFS= read -r f; do
        fname=$(basename "$f")
        encoded_folder=$(echo "$CHAPTER" | sed 's/ /%20/g')
        echo "https://raw.githubusercontent.com/$USERNAME/$REPO/$BRANCH/$encoded_folder/$fname" >> "$output"
        ((count++))
    done < <(find "$CHAPTER" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort -V)

    # Hapus baris kosong dan newline terakhir
    awk 'NF {a[++n]=$0} END {for (i=1; i<=n; i++) print a[i]}' "$output" > "$output.tmp" && mv "$output.tmp" "$output"

    echo "✅ $count file gambar ditemukan dan disimpan ke $output"
}

# ==========================================================
# Menu utama
# ==========================================================
while true; do
    echo ""
    echo "Pilih mode:"
    echo "1. Generate semua folder"
    echo "2. Pilih folder tertentu"
    echo "============================================="
    read -rp "Masukkan pilihan (1/2): " mode

    # ------------------------------------------------------
    # Mode 1 : semua folder
    # ------------------------------------------------------
    if [ "$mode" == "1" ]; then
        echo "🔄 Membuat link untuk semua folder..."
        for folder in */; do
            [ -d "$folder" ] || continue
            folder=${folder%/}
            generate_links "$folder"
        done
        echo "🎉 Semua folder selesai diproses."
        break
    fi

    # ------------------------------------------------------
    # Mode 2 : folder tertentu
    # ------------------------------------------------------
    if [ "$mode" == "2" ]; then
        while true; do
            read -rp "Masukkan nama folder chapter (contoh: 1 atau Chapter 4.1): " CHAPTER
            if [ ! -d "$CHAPTER" ]; then
                echo "❌ Folder '$CHAPTER' tidak ditemukan. Coba lagi."
                continue
            fi

            generate_links "$CHAPTER"

            read -rp "Apakah ingin generate folder lain? (y/n): " jawab
            [[ "$jawab" == "y" || "$jawab" == "Y" ]] || break
        done
        break
    fi

    echo "❌ Pilihan tidak valid. Coba lagi."
done

echo ""
echo "Selesai 👍"
