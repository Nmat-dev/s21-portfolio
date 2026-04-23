#!/bin/bash

validate_days() {
    local days="$1"
    if ! [[ "$days" =~ ^[0-9]+$ ]] || [ "$days" -le 0 ] || [ "$days" -gt 365 ]; then
        echo "Error: Days must be a number between 1 and 365." >&2
        exit 1
    fi
}

validate_entries() {
    local min="$1"
    local max="$2"
    if ! [[ "$min" =~ ^[0-9]+$ ]] || ! [[ "$max" =~ ^[0-9]+$ ]]; then
        echo "Error: Entry counts must be numbers." >&2
        exit 1
    fi
    if [ "$min" -gt "$max" ]; then
        echo "Error: Min entries must be less than max." >&2
        exit 1
    fi
}

check_args_count() {
    # Параметры опциональны, есть значения по умолчанию
    if [ "$#" -gt 3 ]; then
        echo "Error: Too many parameters. Max 3 allowed." >&2
        exit 1
    fi
}