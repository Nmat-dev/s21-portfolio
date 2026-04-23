#!/bin/bash

validate_path() {
    local path="$1"
    if [[ ! "$path" =~ ^/ ]]; then
        echo "Error: Path must be absolute (start with /)." >&2
        exit 1
    fi
}

validate_count() {
    local count="$1"
    if ! [[ "$count" =~ ^[0-9]+$ ]] || [ "$count" -le 0 ]; then
        echo "Error: Count must be a positive integer." >&2
        exit 1
    fi
}

validate_chars() {
    local chars="$1"
    local max_len="$2"
    if [[ ${#chars} -gt "$max_len" ]] || [[ ! "$chars" =~ ^[a-zA-Z]+$ ]]; then
        echo "Error: Chars must be English letters only (max $max_len)." >&2
        exit 1
    fi
}

validate_file_param() {
    local param="$1"
    # Ожидаем формат name.ext
    if [[ ! "$param" =~ ^[a-zA-Z]+\.[a-zA-Z]+$ ]]; then
        echo "Error: File param must be in format letters.letters (e.g., az.az)." >&2
        exit 1
    fi
    
    local name_part="${param%.*}"
    local ext_part="${param#*.}"
    
    if [[ ${#name_part} -gt 7 ]]; then
        echo "Error: File name part exceeds 7 characters." >&2
        exit 1
    fi
    
    if [[ ${#ext_part} -gt 3 ]]; then
        echo "Error: File extension part exceeds 3 characters." >&2
        exit 1
    fi
}

validate_size() {
    local size_str="$1"
    # Убираем 'kb' и проверяем число
    local size="${size_str%kb}"
    if ! [[ "$size" =~ ^[0-9]+$ ]] || [ "$size" -le 0 ] || [ "$size" -gt 100 ]; then
        echo "Error: Size must be a number (1-100) followed by 'kb'." >&2
        exit 1
    fi
}

check_args_count() {
    if [ "$#" -ne 6 ]; then
        echo "Error: Exactly 6 parameters required." >&2
        echo "Usage: main.sh <path> <dir_count> <dir_chars> <file_count> <file_chars> <size>" >&2
        exit 1
    fi
}
