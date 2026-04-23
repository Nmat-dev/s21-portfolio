#!/bin/bash

report_unique_ips() {
    local log_file="$1"
    
    # Извлекаем IP (поле 1), сортируем и убираем дубликаты
    awk '{print $1}' "$log_file" | sort -u
}