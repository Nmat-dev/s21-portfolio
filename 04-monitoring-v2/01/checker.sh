#!/bin/bash

check_disk_space() {
    # Получаем свободное место в KB на разделе /
    local free_kb
    free_kb=$(df -k / | tail -1 | awk '{print $4}')
    
    # 1 GB = 1048576 KB
    local min_required=1048576
    
    if [ "$free_kb" -lt "$min_required" ]; then
        echo "Error: Not enough free space on / (less than 1GB)." >&2
        exit 1
    fi
}
