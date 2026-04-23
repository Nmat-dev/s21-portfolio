#!/bin/bash

validate_method() {
    local method="$1"
    if [[ ! "$method" =~ ^[123]$ ]]; then
        echo "Error: Method must be 1, 2, or 3." >&2
        echo "1 - By log file" >&2
        echo "2 - By date/time" >&2
        echo "3 - By name mask" >&2
        exit 1
    fi
}

check_args_count() {
    if [ "$#" -lt 1 ]; then
        echo "Error: At least 1 parameter required (cleanup method)." >&2
        exit 1
    fi
}