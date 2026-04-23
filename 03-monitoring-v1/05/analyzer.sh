#!/bin/bash
# Файл: analyzer.sh
# Назначение: Основные функции анализа директории

# Подключаем helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# Глобальные переменные для статистики
declare -i TOTAL_FOLDERS=0
declare -i TOTAL_FILES=0
declare -i CONF_FILES=0
declare -i TEXT_FILES=0
declare -i EXEC_FILES=0
declare -i LOG_FILES=0
declare -i ARCHIVE_FILES=0
declare -i SYMLINKS=0

# Функция для анализа директории
analyze_directory() {
    local path="$1"
    
    echo "Начинаем анализ директории: $path"
    echo "Это может занять некоторое время..."
    
    # Сбрасываем статистику
    TOTAL_FOLDERS=0
    TOTAL_FILES=0
    CONF_FILES=0
    TEXT_FILES=0
    EXEC_FILES=0
    LOG_FILES=0
    ARCHIVE_FILES=0
    SYMLINKS=0
    
    # Анализируем файлы и собираем статистику
    analyze_files "$path"
    
    # Собираем топы
    collect_top_folders "$path"
    collect_top_files "$path"
    collect_top_executables "$path"
}

# Анализ файлов и подсчет статистики
analyze_files() {
    local path="$1"
    
    # Считаем папки
    TOTAL_FOLDERS=$(find "$path" -type d 2>/dev/null | wc -l)
    
    # Считаем файлы и симлинки
    TOTAL_FILES=$(find "$path" \( -type f -o -type l \) 2>/dev/null | wc -l)
    
    # Считаем по типам
    CONF_FILES=$(find "$path" -name "*.conf" -type f 2>/dev/null | wc -l)
    LOG_FILES=$(find "$path" \( -name "*.log" -o -name "*.journal" -o -name "*journal~" \) -type f 2>/dev/null | wc -l)
    ARCHIVE_FILES=$(find "$path" \( -name "*.tar" -o -name "*.gz" -o -name "*.bz2" -o -name "*.zip" -o -name "*.rar" -o -name "*.7z" -o -name "*.tgz" -o -name "*.tbz2" \) -type f 2>/dev/null | wc -l)
    SYMLINKS=$(find "$path" -type l 2>/dev/null | wc -l)
    EXEC_FILES=$(find "$path" -type f -executable 2>/dev/null | wc -l)
    
    # Текстовые файлы считаем как остаток
    TEXT_FILES=$((TOTAL_FILES - CONF_FILES - LOG_FILES - ARCHIVE_FILES - SYMLINKS - EXEC_FILES))
    if [ "$TEXT_FILES" -lt 0 ]; then
        TEXT_FILES=0
    fi
}

# Сбор топ-5 папок по размеру
collect_top_folders() {
    local path="$1"
    
    echo ""
    echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
    
    # Просто выводим топ-5 папок
    du -h "$path" 2>/dev/null | sort -hr | head -5 | \
        awk '{print NR " - " $2 ", " $1}'
}

# Сбор топ-10 файлов по размеру
collect_top_files() {
    local path="$1"
    
    echo ""
    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
    
    # Временный файл для хранения результатов
    local temp_file
    temp_file=$(mktemp)
    
    # Находим все файлы (не директории) и получаем их размер
    find "$path" -type f 2>/dev/null -exec du -b {} \; | sort -nr | head -10 > "$temp_file"
    
    local counter=1
    while read -r size file; do
        if [ -n "$file" ]; then
            local file_type
            file_type=$(get_file_type "$file")
            local formatted_size
            formatted_size=$(format_size "$size")
            echo "$counter - $file, $formatted_size, $file_type"
            ((counter++))
        fi
    done < "$temp_file"
    
    rm -f "$temp_file"
}

# Сбор топ-10 исполняемых файлов по размеру с хешем
collect_top_executables() {
    local path="$1"
    
    echo ""
    echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
    
    # Временный файл для хранения результатов
    local temp_file
    temp_file=$(mktemp)
    
    # Находим все исполняемые файлы
    find "$path" -type f -executable 2>/dev/null -exec du -b {} \; | sort -nr | head -10 > "$temp_file"
    
    local counter=1
    while read -r size file; do
        if [ -n "$file" ]; then
            local md5_hash
            md5_hash=$(get_md5_hash "$file")
            local formatted_size
            formatted_size=$(format_size "$size")
            echo "$counter - $file, $formatted_size, $md5_hash"
            ((counter++))
        fi
    done < "$temp_file"
    
    rm -f "$temp_file"
}

# Функция для вывода общей статистики
print_statistics() {
    echo ""
    echo "Total number of folders (including all nested ones) = $TOTAL_FOLDERS"
    echo ""
    echo "Total number of files = $TOTAL_FILES"
    echo "Number of:"
    echo "Configuration files (with the .conf extension) = $CONF_FILES"
    echo "Text files = $TEXT_FILES"
    echo "Executable files = $EXEC_FILES"
    echo "Log files (with the extension .log) = $LOG_FILES"
    echo "Archive files = $ARCHIVE_FILES"
    echo "Symbolic links = $SYMLINKS"
}
