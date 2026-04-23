#!/bin/bash

LOG_FILE="generator.log"

log_entry() {
    local path="$1"
    local type="$2"
    local size="$3"
    local date_created
    date_created=$(date +%d%m%y)
    
    if [ "$type" == "file" ]; then
        echo "$path $date_created ${size}Mb" >> "$LOG_FILE"
    else
        echo "$path $date_created" >> "$LOG_FILE"
    fi
}