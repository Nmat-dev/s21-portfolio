#!/bin/bash

# Функция для генерации базового имени (минимум 5 знаков)
generate_base_name() {
    local chars="$1"
    local min_len=5
    local result="$chars"
    
    while [ ${#result} -lt "$min_len" ]; do
        result="${result}${chars: -1}"
    done
    
    echo "$result"
}

# Функция для получения уникального имени
get_unique_name() {
    local base="$1"
    local chars="$2"
    local index="$3"
    local chars_len=${#chars}
    
    if [ "$index" -eq 1 ]; then
        echo "$base"
        return
    fi
    
    local suffix=""
    for (( i=0; i<index-1; i++ )); do
        local char_idx=$((i % chars_len))
        suffix="${suffix}${chars:$char_idx:1}"
    done
    
    echo "${base}${suffix}"
}

# Функция для получения списка допустимых директорий (не bin/sbin)
get_valid_dirs() {
    local valid_dirs=()
    
    # Сканируем корневые директории
    for dir in /home /opt /var /tmp /usr/local; do
        if [ -d "$dir" ] && [[ ! "$dir" =~ (bin|sbin) ]]; then
            valid_dirs+=("$dir")
        fi
    done
    
    # Если ничего не нашли, используем /tmp
    if [ ${#valid_dirs[@]} -eq 0 ]; then
        valid_dirs=("/tmp")
    fi
    
    echo "${valid_dirs[@]}"
}

# Проверка места через df -h (возвращает 0 если места достаточно, 1 если нет)
check_space_mb() {
    local avail_str
    avail_str=$(df -h / | tail -1 | awk '{print $4}')
    
    local num="${avail_str%[GMK]}"
    local unit="${avail_str: -1}"
    
    local avail_mb=0
    case "$unit" in
        G) avail_mb=$(echo "$num * 1024" | bc) ;;
        M) avail_mb="$num" ;;
        K) avail_mb=$(echo "$num / 1024" | bc) ;;
        *) avail_mb="$num" ;;
    esac
    
    avail_mb=${avail_mb%.*}
    
    if [ "$avail_mb" -lt 1024 ]; then
        return 1
    fi
    return 0
}

create_structure() {
    local dir_chars="$1"
    local file_param="$2"
    local size_mb="$3"
    
    local size_num="${size_mb%Mb}"
    local date_suffix
    date_suffix=$(date +%d%m%y)
    
    local file_name_chars="${file_param%.*}"
    local file_ext_chars="${file_param#*.}"
    
    local base_dir_name
    base_dir_name=$(generate_base_name "$dir_chars")
    
    local base_file_name
    base_file_name=$(generate_base_name "$file_name_chars")
    
    # Получаем список допустимых директорий
    local valid_dirs
    valid_dirs=$(get_valid_dirs)
    local dirs_array=($valid_dirs)
    local dirs_count=${#dirs_array[@]}
    
    local dir_count=0
    local max_dirs=100
    
    # Создаём до 100 папок в разных местах
    while [ $dir_count -lt $max_dirs ]; do
        # Проверка места перед каждой итерацией
        if ! check_space_mb; then
            echo "Stopping: Less than 1GB free space remaining."
            break
        fi
        
        # Выбираем случайную директорию из списка
        local rand_dir_idx=$((RANDOM % dirs_count))
        local target_dir="${dirs_array[$rand_dir_idx]}"
        
        # Создаём уникальное имя папки
        local unique_dir_name
        unique_dir_name=$(get_unique_name "$base_dir_name" "$dir_chars" $((dir_count + 1)))
        local dir_name="${unique_dir_name}_${date_suffix}"
        local full_dir_path="${target_dir}/${dir_name}"
        
        # Проверка что путь не содержит bin/sbin
        if [[ "$full_dir_path" =~ (bin|sbin) ]]; then
            continue
        fi
        
        mkdir -p "$full_dir_path" 2>/dev/null
        if [ $? -ne 0 ]; then
            continue
        fi
        
        log_entry "$full_dir_path" "dir"
        dir_count=$((dir_count + 1))
        
        # Случайное количество файлов (1-10)
        local file_count=$((RANDOM % 10 + 1))
        
        for (( j=1; j<=file_count; j++ )); do
            # Проверка места перед созданием каждого файла
            if ! check_space_mb; then
                echo "Stopping: Less than 1GB free space remaining."
                break 2
            fi
            
            local unique_file_name
            unique_file_name=$(get_unique_name "$base_file_name" "$file_name_chars" "$j")
            local file_name="${unique_file_name}_${date_suffix}.${file_ext_chars}"
            local full_file_path="${full_dir_path}/${file_name}"
            
            # Создаем файл (1MB = 1024KB)
            dd if=/dev/zero of="$full_file_path" bs=1M count="$size_num" 2>/dev/null
            
            log_entry "$full_file_path" "file" "$size_num"
        done
    done
    
    echo "Created $dir_count directories."
}