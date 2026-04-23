#!/bin/bash
# Файл: helpers.sh
# Назначение: Вспомогательные функции для анализа

# Функция для форматирования размера
format_size() {
    local bytes="$1"
    
    if [ "$bytes" -ge 1073741824 ]; then  # 1GB = 1024^3
        echo "$(echo "scale=2; $bytes / 1073741824" | bc) GB"
    elif [ "$bytes" -ge 1048576 ]; then   # 1MB = 1024^2
        echo "$(echo "scale=2; $bytes / 1048576" | bc) MB"
    elif [ "$bytes" -ge 1024 ]; then      # 1KB = 1024
        echo "$(echo "scale=2; $bytes / 1024" | bc) KB"
    else
        echo "${bytes} B"
    fi
}

# Функция для определения типа файла
get_file_type() {
    local file="$1"
    
    # Проверяем расширения и атрибуты
    case "$file" in
        *.conf) echo "conf" ;;
        *.log) echo "log" ;;
        *.tar|*.gz|*.bz2|*.zip|*.rar|*.7z) echo "archive" ;;
        *)
            # Используем команду file для определения типа
            if [ -L "$file" ]; then
                echo "symlink"
            elif [ -x "$file" ]; then
                echo "executable"
            elif file "$file" | grep -q "text"; then
                echo "text"
            else
                echo "other"
            fi
            ;;
    esac
}

# Функция для подсчета общего количества
count_items() {
    local path="$1"
    local find_output
    
    # Используем find для подсчета
    find_output=$(find "$path" -type d 2>/dev/null | wc -l)
    echo "$find_output"
}

# Функция для получения хеша MD5
get_md5_hash() {
    local file="$1"
    if [ -f "$file" ] && [ -r "$file" ]; then
        md5sum "$file" 2>/dev/null | cut -d' ' -f1 || echo "N/A"
    else
        echo "N/A"
    fi
}

# Обновленная функция для определения типа файла
get_file_type() {
    local file="$1"
    
    # Проверяем расширения
    case "$file" in
        *.conf) echo "conf" ;;
        *.log|*.journal|*journal~) echo "log" ;;
        *.tar|*.gz|*.bz2|*.zip|*.rar|*.7z|*.tgz|*.tbz2) echo "archive" ;;
        *.txt|*.text|*.md|*.rst|*.ini|*.cfg|*.yml|*.yaml|*.json|*.xml|*.csv) echo "text" ;;
        *)
            # Используем команду file для определения типа
            if [ -L "$file" ]; then
                echo "symlink"
            elif [ -x "$file" ]; then
                echo "executable"
            elif file "$file" 2>/dev/null | grep -q "text"; then
                echo "text"
            else
                echo "other"
            fi
            ;;
    esac
}
