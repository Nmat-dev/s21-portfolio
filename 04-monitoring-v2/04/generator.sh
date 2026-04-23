#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/ip_generator.sh"
source "$(dirname "${BASH_SOURCE[0]}")/log_formatter.sh"

MONTHS=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")

generate_date() {
    local day_offset="$1"
    local base_date="${2:-$(date +%Y%m%d)}"
    
    # Вычисляем дату со смещением
    local target_date
    target_date=$(date -d "$base_date - $day_offset days" +%Y%m%d 2>/dev/null)
    
    if [ -z "$target_date" ]; then
        target_date=$(date +%Y%m%d)
    fi
    
    local year="${target_date:0:4}"
    local month_num="${target_date:4:2}"
    local day="${target_date:6:2}"
    
    # Конвертируем номер месяца в название
    local month_idx=$((10#$month_num - 1))
    local month_name="${MONTHS[$month_idx]}"
    
    echo "${day}/${month_name}/${year}"
}

generate_time() {
    local hour="$1"
    local minute="$2"
    local second="$3"
    printf "%02d:%02d:%02d" "$hour" "$minute" "$second"
}

generate_log_file() {
    local file_num="$1"
    local entries="$2"
    local day_offset="$3"
    
    local date_str
    date_str=$(generate_date "$day_offset")
    
    local log_file="nginx_log_day${file_num}.log"
    
    # Очищаем файл
    > "$log_file"
    
    local prev_seconds=-1
    
    for (( i=1; i<=entries; i++ )); do
        # Генерируем IP
        local ip
        ip=$(generate_ip)
        
        # Генерируем время (в рамках дня, по возрастанию)
        local hour=$((RANDOM % 24))
        local minute=$((RANDOM % 60))
        local second=$((RANDOM % 60))
        
        #确保 время возрастает
        if [ "$second" -le "$prev_seconds" ] && [ "$minute" -eq $((RANDOM % 60)) ]; then
            second=$((prev_seconds + 1))
            if [ "$second" -ge 60 ]; then
                second=0
                minute=$((minute + 1))
            fi
        fi
        prev_seconds=$second
        
        local time_str
        time_str=$(generate_time "$hour" "$minute" "$second")
        
        # Генерируем остальные параметры
        local method
        method=$(get_random_element "${HTTP_METHODS[@]}")
        
        local url
        url=$(get_random_element "${URLS[@]}")
        
        local status
        status=$(get_random_element "${HTTP_CODES[@]}")
        
        local size
        size=$((RANDOM % 50000 + 100))
        
        local agent
        agent=$(get_random_element "${USER_AGENTS[@]}")
        
        # Форматируем и записываем строку
        local log_line
        log_line=$(format_log_line "$ip" "$date_str" "$time_str" "$method" "$url" "$status" "$size" "$agent")
        
        echo "$log_line" >> "$log_file"
    done
    
    echo "Generated $log_file with $entries entries for date: $date_str"
}

create_all_logs() {
    local num_files="${1:-5}"
    local min_entries="${2:-100}"
    local max_entries="${3:-1000}"
    
    for (( i=1; i<=num_files; i++ )); do
        # Случайное число записей (100-1000)
        local entries=$((RANDOM % (max_entries - min_entries + 1) + min_entries))
        
        # День со смещением (день 1 = сегодня, день 2 = вчера, и т.д.)
        local day_offset=$((i - 1))
        
        generate_log_file "$i" "$entries" "$day_offset"
    done
    
    echo ""
    echo "=== Generation Complete ==="
    echo "Created $num_files log files."
}