#!/bin/bash

LOG_FILE="generator.log"

log_entry() {
    local path="$1"
    local type="$2" # 'dir' or 'file'
    local size="$3" # размер в КБ (число)
    local date_created
    date_created=$(date +%d%m%y)
    
    if [ "$type" == "file" ]; then
        echo "$path $date_created ${size}kb" >> "$LOG_FILE"
    else
        echo "$path $date_created" >> "$LOG_FILE"
    fi
}
