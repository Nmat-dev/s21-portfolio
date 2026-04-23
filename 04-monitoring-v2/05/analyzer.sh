#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/report1.sh"
source "$SCRIPT_DIR/report2.sh"
source "$SCRIPT_DIR/report3.sh"
source "$SCRIPT_DIR/report4.sh"

run_analysis() {
    local method="$1"
    local log_file="$2"  # Теперь принимаем путь к файлу
    local result_count=0
    
    case "$method" in
        1)
            echo "=== Report 1: All Records Sorted by Status Code ===" >&2
            report_by_status "$log_file"
            result_count=$(wc -l < "$log_file")
            ;;
        2)
            echo "=== Report 2: All Unique IPs ===" >&2
            report_unique_ips "$log_file"
            result_count=$(report_unique_ips "$log_file" | wc -l)
            ;;
        3)
            echo "=== Report 3: All Error Requests (4xx/5xx) ===" >&2
            report_errors "$log_file"
            result_count=$(report_errors "$log_file" | wc -l)
            ;;
        4)
            echo "=== Report 4: Unique IPs from Error Requests ===" >&2
            report_error_ips "$log_file"
            result_count=$(report_error_ips "$log_file" | wc -l)
            ;;
    esac
    
    echo "" >&2
    echo "Total records processed: $result_count" >&2
    
    # Логирование
    log_analysis "$method" "$log_file" "$result_count"
}