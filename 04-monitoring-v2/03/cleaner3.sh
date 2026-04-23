#!/bin/bash

clean_by_mask() {
    local dir_chars="${1:-az}"
    local file_chars="${2:-az.az}"
    local date_suffix="${3:-$(date +%d%m%y)}"
    
    # Если параметры не переданы, запрашиваем интерактивно
    if [ -z "$dir_chars" ] || [ -z "$file_chars" ]; then
        echo "=== Cleanup by Name Mask ==="
        read -p "Enter directory chars (e.g., az): " dir_chars
        read -p "Enter file chars (e.g., az.az): " file_chars
        read -p "Enter date suffix (e.g., 140326 or press Enter for today): " input_date
        [ -n "$input_date" ] && date_suffix="$input_date"
    fi
    
    # Формируем маску имени (минимум 5 символов как в Part 2)
    local base_name="$dir_chars"
    while [ ${#base_name} -lt 5 ]; do
        base_name="${base_name}${dir_chars: -1}"
    done
    
    local file_name="${file_name%.*}"
    file_name="${file_chars%.*}"
    while [ ${#file_name} -lt 5 ]; do
        file_name="${file_name}${file_chars: -1}"
    done
    
    local ext="${file_chars#*.}"
    
    local count=0
    local pattern="${base_name}*_${date_suffix}"
    
    echo "Searching for pattern: $pattern"
    
    # Ищем папки по маске
    for dir in /home /opt /var /tmp /usr/local; do
        if [ -d "$dir" ]; then
            while IFS= read -r -d '' folder; do
                local folder_name
                folder_name=$(basename "$folder")
                
                if [[ "$folder_name" =~ ^${base_name}.*_${date_suffix}$ ]]; then
                    if rm -rf "$folder" 2>/dev/null; then
                        log_deletion "$folder" "deleted"
                        count=$((count + 1))
                    else
                        log_deletion "$folder" "failed"
                    fi
                fi
            done < <(find "$dir" -type d -name "*_${date_suffix}" -print0 2>/dev/null)
        fi
    done
    
    echo "Deleted $count items by mask pattern."
}