#!/bin/bash

LOG_FILE="cleanup.log"

log_deletion() {
    local path="$1"
    local status="$2"  # 'deleted' or 'failed'
    local date_deleted
    date_deleted=$(date +%d%m%y" "%H:%M:%S)
    
    echo "$path $status $date_deleted" >> "$LOG_FILE"
}