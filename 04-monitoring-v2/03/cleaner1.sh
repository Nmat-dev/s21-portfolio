#!/bin/bash

clean_by_log() {
    local log_path="${1:-generator.log}"
    
    if [ ! -f "$log_path" ]; then
        echo "Error: Log file '$log_path' not found." >&2
        exit 1
    fi
    
    local count=0
    
    # Читаем лог-файл построчно
    while IFS= read -r line; do
        # Извлекаем путь (первое поле до пробела после даты)
        local path
        path=$(echo "$line" | awk '{print $1}')
        
        if [ -n "$path" ] && [ -e "$path" ]; then
            if rm -rf "$path" 2>/dev/null; then
                log_deletion "$path" "deleted"
                count=$((count + 1))
            else
                log_deletion "$path" "failed"
            fi
        fi
    done < "$log_path"
    
    echo "Deleted $count items from log file."
}