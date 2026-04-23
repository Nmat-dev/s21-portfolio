#!/bin/bash

validate_method() {
    local method="$1"
    if [[ ! "$method" =~ ^[1234]$ ]]; then
        echo "Error: Method must be 1, 2, 3, or 4." >&2
        echo "1 - All records sorted by response code" >&2
        echo "2 - All unique IPs" >&2
        echo "3 - All error requests (4xx/5xx)" >&2
        echo "4 - Unique IPs from error requests" >&2
        exit 1
    fi
}

validate_log_file() {
    local log_file="$1"
    if [ ! -f "$log_file" ]; then
        echo "Error: Log file '$log_file' not found." >&2
        exit 1
    fi
}

check_args_count() {
    if [ "$#" -lt 1 ]; then
        echo "Error: At least 1 parameter required (analysis method)." >&2
        exit 1
    fi
}