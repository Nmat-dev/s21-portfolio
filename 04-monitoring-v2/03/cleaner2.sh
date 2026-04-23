#!/bin/bash

get_time_input() {
    local prompt="$1"
    read -p "$prompt" time_input
    
    # Проверяем формат (YYYY-MM-DD HH:MM)
    if [[ ! "$time_input" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}$ ]]; then
        echo "Error: Invalid time format. Use: YYYY-MM-DD HH:MM" >&2
        exit 1
    fi
    
    echo "$time_input"
}

clean_by_date() {
    local start_time="$1"
    local end_time="$2"
    
    # Если времена не переданы, запрашиваем интерактивно
    if [ -z "$start_time" ]; then
        echo "=== Cleanup by Date/Time ==="
        start_time=$(get_time_input "Enter start time (YYYY-MM-DD HH:MM): ")
    fi
    
    if [ -z "$end_time" ]; then
        end_time=$(get_time_input "Enter end time (YYYY-MM-DD HH:MM): ")
    fi
    
    # Конвертируем в timestamp для сравнения
    local start_ts
    local end_ts
    start_ts=$(date -d "$start_time" +%s 2>/dev/null)
    end_ts=$(date -d "$end_time" +%s 2>/dev/null)
    
    if [ -z "$start_ts" ] || [ -z "$end_ts" ]; then
        echo "Error: Invalid date/time format." >&2
        exit 1
    fi
    
    if [ "$start_ts" -gt "$end_ts" ]; then
        echo "Error: Start time must be before end time." >&2
        exit 1
    fi
    
    local count=0
    
    # Ищем файлы в стандартных директориях
    for dir in /home /opt /var /tmp /usr/local; do
        if [ -d "$dir" ]; then
            # Находим файлы и проверяем время создания
            while IFS= read -r -d '' file; do
                local file_ts
                file_ts=$(stat -c %Y "$file" 2>/dev/null)
                
                if [ -n "$file_ts" ] && [ "$file_ts" -ge "$start_ts" ] && [ "$file_ts" -le "$end_ts" ]; then
                    if rm -rf "$file" 2>/dev/null; then
                        log_deletion "$file" "deleted"
                        count=$((count + 1))
                    else
                        log_deletion "$file" "failed"
                    fi
                fi
            done < <(find "$dir" -type f -print0 2>/dev/null)
            
            # Также удаляем пустые папки
            while IFS= read -r -d '' folder; do
                local folder_ts
                folder_ts=$(stat -c %Y "$folder" 2>/dev/null)
                
                if [ -n "$folder_ts" ] && [ "$folder_ts" -ge "$start_ts" ] && [ "$folder_ts" -le "$end_ts" ]; then
                    if rmdir "$folder" 2>/dev/null; then
                        log_deletion "$folder" "deleted"
                        count=$((count + 1))
                    fi
                fi
            done < <(find "$dir" -type d -empty -print0 2>/dev/null)
        fi
    done
    
    echo "Deleted $count items in time range: $start_time to $end_time"
}