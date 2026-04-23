#!/bin/bash

report_error_ips() {
    local log_file="$1"
    
    # Фильтруем ошибки и сразу берём IP (поле 1)
    awk '$9 ~ /^[45][0-9][0-9]$/ {print $1}' "$log_file" | sort -u
}