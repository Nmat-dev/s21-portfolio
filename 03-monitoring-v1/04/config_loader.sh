#!/bin/bash
# Файл: config_loader.sh
# Назначение: Загрузка цветов из конфигурационного файла

# Цвета по умолчанию (на ваше усмотрение)
DEFAULT_COLUMN1_BACKGROUND=6      # black
DEFAULT_COLUMN1_FONT_COLOR=1      # white  
DEFAULT_COLUMN2_BACKGROUND=2      # red
DEFAULT_COLUMN2_FONT_COLOR=4      # blue

CONFIG_FILE="config.conf"

# Функция для чтения значения из конфига
get_config_value() {
    local key="$1"
    local default_value="$2"
    local value
    
    if [ -f "$CONFIG_FILE" ]; then
        # Ищем ключ в конфиге
        value=$(grep "^$key=" "$CONFIG_FILE" | head -1 | cut -d'=' -f2-)
        
        # Удаляем комментарии и пробелы
        if [ -n "$value" ]; then
            value=$(echo "$value" | sed 's/#.*//' | sed 's/[[:space:]]//g')
        fi
        
        # Проверяем что значение корректное
        if [ -n "$value" ] && [[ "$value" =~ ^[1-6]$ ]]; then
            echo "$value"
            return
        fi
    fi
    
    # Если не нашли или значение некорректное, возвращаем умолчание
    echo "$default_value"
}

# Функция для загрузки всех цветов из конфига
load_colors_from_config() {
    local bg_left font_left bg_right font_right
    
    # Читаем значения, если пусто или некорректно - используем умолчания
    bg_left=$(get_config_value "column1_background" "$DEFAULT_COLUMN1_BACKGROUND")
    font_left=$(get_config_value "column1_font_color" "$DEFAULT_COLUMN1_FONT_COLOR")
    bg_right=$(get_config_value "column2_background" "$DEFAULT_COLUMN2_BACKGROUND")
    font_right=$(get_config_value "column2_font_color" "$DEFAULT_COLUMN2_FONT_COLOR")
    
    # Дополнительная проверка (на всякий случай)
    for value in "$bg_left" "$font_left" "$bg_right" "$font_right"; do
        if ! [[ "$value" =~ ^[1-6]$ ]]; then
            echo "Ошибка: значение цвета '$value' должно быть от 1 до 6" >&2
            return 1
        fi
    done
    
    # Проверяем что цвета в столбцах не совпадают
    if [ "$bg_left" -eq "$font_left" ]; then
        echo "Ошибка: цвета левого столбца совпадают" >&2
        return 1
    fi
    
    if [ "$bg_right" -eq "$font_right" ]; then
        echo "Ошибка: цвета правого столбца совпадают" >&2
        return 1
    fi
    
    echo "$bg_left $font_left $bg_right $font_right"
    return 0
}

# Функция для получения имени цвета
get_color_name() {
    case "$1" in
        1) echo "white" ;;
        2) echo "red" ;;
        3) echo "green" ;;
        4) echo "blue" ;;
        5) echo "purple" ;;
        6) echo "black" ;;
        *) echo "unknown" ;;
    esac
}

# Функция для вывода цветовой схемы
print_color_scheme() {
    local bg_left="$1"
    local font_left="$2"
    local bg_right="$3"
    local font_right="$4"
    local is_default="$5"
    
    echo ""
    echo "Цветовая схема:"
    echo "---------------"
    
    if [ "$is_default" = "true" ]; then
        echo "Column 1 background = default ($(get_color_name "$bg_left"))"
        echo "Column 1 font color = default ($(get_color_name "$font_left"))"
        echo "Column 2 background = default ($(get_color_name "$bg_right"))"
        echo "Column 2 font color = default ($(get_color_name "$font_right"))"
    else
        echo "Column 1 background = $bg_left ($(get_color_name "$bg_left"))"
        echo "Column 1 font color = $font_left ($(get_color_name "$font_left"))"
        echo "Column 2 background = $bg_right ($(get_color_name "$bg_right"))"
        echo "Column 2 font color = $font_right ($(get_color_name "$font_right"))"
    fi
}
