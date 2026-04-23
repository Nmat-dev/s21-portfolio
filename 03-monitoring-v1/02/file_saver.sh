#!/bin/bash
# Файл: file_saver.sh
# Назначение: Функции для работы с файлами

# Функция для создания имени файла
generate_filename() {
    # Формат: DD_MM_YY_HH_MM_SS.status
    date +"%d_%m_%y_%H_%M_%S.status"
}

# Функция для сохранения данных в файл
save_to_file() {
    local data="$1"
    local filename
    
    # Генерируем имя файла
    filename=$(generate_filename)
    
    # Сохраняем данные
    echo "$data" > "$filename"
    
    # Возвращаем имя файла (успех) или пустую строку (ошибка)
    if [ -f "$filename" ] && [ -s "$filename" ]; then
        echo "$filename"
    else
        echo ""
    fi
}

# Функция для запроса у пользователя
ask_to_save() {
    local data="$1"
    
    echo ""
    read -p "Сохранить данные в файл? (Y/N): " answer
    
    # Приводим к верхнему регистру
    answer=$(echo "$answer" | tr '[:lower:]' '[:upper:]')
    
    if [ "$answer" = "Y" ]; then
        # Пытаемся сохранить
        filename=$(save_to_file "$data")
        
        if [ -n "$filename" ]; then
            echo "Данные сохранены в файл: $filename"
        else
            echo "Ошибка: не удалось сохранить данные"
        fi
    else
        echo "Данные не сохранены."
    fi
}
