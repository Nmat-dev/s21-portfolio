#!/bin/bash

report_errors() {
    local log_file="$1"
    
    # Фильтруем: статус (поле 9) начинается с 4 или 5
    awk '$9 ~ /^[45][0-9][0-9]$/' "$log_file"
}