#!/bin/bash

# Функция для генерации базового имени (минимум 4 знака, порядок сохранён)
# Если передано "az", вернёт "azzz"
generate_base_name() {
    local chars="$1"
    local min_len=4
    local result="$chars"
    
    # Дополняем последним символом, пока длина < 4
    while [ ${#result} -lt "$min_len" ]; do
        result="${result}${chars: -1}"
    done
    
    echo "$result"
}

# Функция для получения уникального имени
# Добавляет символы из набора для уникальности, сохраняя порядок
get_unique_name() {
    local base="$1"
    local chars="$2"
    local index="$3"
    local chars_len=${#chars}
    
    # Если индекс 1, возвращаем базовое имя без изменений
    if [ "$index" -eq 1 ]; then
        echo "$base"
        return
    fi
    
    # Для 2, 3, 4... добавляем символы по кругу из параметра
    local suffix=""
    for (( i=0; i<index-1; i++ )); do
        local char_idx=$((i % chars_len))
        suffix="${suffix}${chars:$char_idx:1}"
    done
    
    echo "${base}${suffix}"
}

create_structure() {
    local root_path="$1"
    local dir_count="$2"
    local dir_chars="$3"
    local file_count="$4"
    local file_param="$5"
    local size_kb="$6"
    
    # Вычисляем чистое число для dd (убираем 'kb')
    local size_num="${size_kb%kb}"
    
    local date_suffix
    date_suffix=$(date +%d%m%y)
    
    local file_name_chars="${file_param%.*}"
    local file_ext_chars="${file_param#*.}"
    
    # Генерируем базовые имена (минимум 4 знака)
    local base_dir_name
    base_dir_name=$(generate_base_name "$dir_chars")
    
    local base_file_name
    base_file_name=$(generate_base_name "$file_name_chars")
    
    # Создаем корневую папку, если нет
    mkdir -p "$root_path"
    
    for (( i=1; i<=dir_count; i++ )); do
        # Формируем уникальное имя папки
        local unique_dir_name
        unique_dir_name=$(get_unique_name "$base_dir_name" "$dir_chars" "$i")
        
        local dir_name="${unique_dir_name}_${date_suffix}"
        local full_dir_path="${root_path}/${dir_name}"
        
        mkdir -p "$full_dir_path"
        
        # Логгируем папку
        log_entry "$full_dir_path" "dir"
        
        # Создаем файлы внутри папки
        for (( j=1; j<=file_count; j++ )); do
            # Формируем уникальное имя файла
            local unique_file_name
            unique_file_name=$(get_unique_name "$base_file_name" "$file_name_chars" "$j")
            
            local file_name="${unique_file_name}_${date_suffix}.${file_ext_chars}"
            local full_file_path="${full_dir_path}/${file_name}"
            
            # Создаем файл нужного размера (dd использует байты, 1kb = 1024 байта)
            dd if=/dev/zero of="$full_file_path" bs=1024 count="$size_num" 2>/dev/null
            
            # Логгируем файл
            log_entry "$full_file_path" "file" "$size_num"
        done
    done
}