#!/bin/bash
# Файл: main.sh
# Назначение: Part 4 - Цвета из конфигурационного файла

# Подключаем модули
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/system_info.sh"
source "$SCRIPT_DIR/colors.sh"
source "$SCRIPT_DIR/config_loader.sh"

# Определяем конфиг-файл (по умолчанию config.conf в текущей папке)
CONFIG_FILE="config.conf"

# Проверяем параметры: разрешаем 0 или 1 параметр
if [ $# -gt 1 ]; then
    echo "Ошибка: слишком много параметров"
    echo "Использование:"
    echo "  ./main.sh                    - использовать config.conf в текущей папке"
    echo "  ./main.sh <config_file>      - использовать указанный конфиг-файл"
    exit 1
elif [ $# -eq 1 ]; then
    # Если передан один параметр - используем его как конфиг-файл
    CONFIG_FILE="$1"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Ошибка: файл конфигурации '$CONFIG_FILE' не найден"
        exit 1
    fi
fi

# Загружаем цвета из конфига
color_params=$(load_colors_from_config "$CONFIG_FILE")
if [ $? -ne 0 ]; then
    echo "$color_params"
    exit 1
fi

# Разбираем параметры
read bg_left font_left bg_right font_right <<< "$color_params"

# Проверяем что цвета корректны (дополнительная проверка)
if ! [[ "$bg_left" =~ ^[1-6]$ ]] || ! [[ "$font_left" =~ ^[1-6]$ ]] || \
   ! [[ "$bg_right" =~ ^[1-6]$ ]] || ! [[ "$font_right" =~ ^[1-6]$ ]]; then
    echo "Ошибка: некорректные значения цветов из конфига"
    exit 1
fi

# Проверяем что цвета в столбцах не совпадают
if [ "$bg_left" -eq "$font_left" ] || [ "$bg_right" -eq "$font_right" ]; then
    echo "Ошибка: цвета фона и текста в одном столбце не должны совпадать"
    exit 1
fi

# Функция для получения всех данных в цветном формате
get_colored_system_info() {
    # Вспомогательная функция для форматирования строки
    print_info_line() {
        local label="$1"
        local value="$2"
        print_colored_line "$bg_left" "$font_left" "$bg_right" "$font_right" \
            "$label" "$value"
    }
    
    # Выводим все 16 параметров
    print_info_line "HOSTNAME = " "$(get_hostname)"
    print_info_line "TIMEZONE = " "$(get_timezone)"
    print_info_line "USER = " "$(get_user)"
    print_info_line "OS = " "$(get_os)"
    print_info_line "DATE = " "$(get_date)"
    print_info_line "UPTIME = " "$(get_uptime)"
    print_info_line "UPTIME_SEC = " "$(get_uptime_sec)"
    print_info_line "IP = " "$(get_ip)"
    print_info_line "MASK = " "$(get_mask)"
    print_info_line "GATEWAY = " "$(get_gateway)"
    
    # RAM информация
    local ram_info=$(get_ram_info)
    print_info_line "RAM_TOTAL = " "$(echo "$ram_info" | awk '{print $1}') GB"
    print_info_line "RAM_USED = " "$(echo "$ram_info" | awk '{print $2}') GB"
    print_info_line "RAM_FREE = " "$(echo "$ram_info" | awk '{print $3}') GB"
    
    # Root space информация
    local space_info=$(get_root_space_info)
    print_info_line "SPACE_ROOT = " "$(echo "$space_info" | awk '{print $1}') MB"
    print_info_line "SPACE_ROOT_USED = " "$(echo "$space_info" | awk '{print $2}') MB"
    print_info_line "SPACE_ROOT_FREE = " "$(echo "$space_info" | awk '{print $3}') MB"
}

# Определяем, используются ли цвета по умолчанию
is_default_colors() {
    local config_file="$1"
    
    # Проверяем, существует ли конфиг-файл
    if [ ! -f "$config_file" ]; then
        echo "true"
        return
    fi
    
    # Проверяем, все ли параметры есть в конфиге
    local has_all_params=true
    for param in column1_background column1_font_color column2_background column2_font_color; do
        if ! grep -q "^$param=" "$config_file"; then
            has_all_params=false
            break
        fi
    done
    
    if [ "$has_all_params" = "false" ]; then
        echo "true"
    else
        echo "false"
    fi
}

# Главная функция
main() {
    echo "=== СИСТЕМНАЯ ИНФОРМАЦИЯ ==="
    echo ""
    
    # Выводим цветную информацию
    get_colored_system_info
    
    # Выводим цветовую схему
    is_default=$(is_default_colors "$CONFIG_FILE")
    print_color_scheme "$bg_left" "$font_left" "$bg_right" "$font_right" "$is_default"
}

# Запускаем скрипт
main "$@"
