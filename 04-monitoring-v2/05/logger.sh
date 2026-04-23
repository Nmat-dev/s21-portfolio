#!/bin/bash

LOG_FILE="analysis.log"

log_analysis() {
    local method="$1"
    local log_file="$2"
    local records_count="$3"
    local date_executed
    date_executed=$(date +%d%m%y" "%H:%M:%S)
    
    echo "Method: $method | Log: $log_file | Records: $records_count | Date: $date_executed" >> "$LOG_FILE"
}