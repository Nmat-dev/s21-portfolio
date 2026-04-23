#!/bin/bash

check_disk_space() {
    # Получаем доступное место из df -h (колонка Avail)
    local avail_str
    avail_str=$(df -h / | tail -1 | awk '{print $4}')
    
    # Парсим значение (например, "10G", "500M", "1.5G")
    local num="${avail_str%[GMK]}"
    local unit="${avail_str: -1}"
    
    # Конвертируем в MB для сравнения (1 GB = 1024 MB)
    local avail_mb=0
    case "$unit" in
        G) avail_mb=$(echo "$num * 1024" | bc) ;;
        M) avail_mb="$num" ;;
        K) avail_mb=$(echo "$num / 1024" | bc) ;;
        *) avail_mb="$num" ;;
    esac
    
    # Округляем до целого
    avail_mb=${avail_mb%.*}
    
    # 1 GB = 1024 MB
    if [ "$avail_mb" -lt 1024 ]; then
        echo "Error: Not enough free space on / (less than 1GB)." >&2
        exit 1
    fi
}