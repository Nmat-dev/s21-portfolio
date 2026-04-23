#!/bin/bash
# Файл: main.sh
# Назначение: Part 3 - Цветной вывод системной информации

# Подключаем модули
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/system_info.sh"
source "$SCRIPT_DIR/colors.sh"
source "$SCRIPT_DIR/validators.sh"

# Проверяем параметры
if ! validate_all_params "$@"; then
    echo "Исправьте параметры и запустите скрипт снова"
    exit 1
fi

# Сохраняем параметры в переменные
BG_LEFT="$1"
FONT_LEFT="$2"
BG_RIGHT="$3"
FONT_RIGHT="$4"

# Функция для получения всех данных в цветном формате
get_colored_system_info() {
    # Вспомогательная функция для форматирования строки
    print_info_line() {
        local label="$1"
        local value="$2"
        print_colored_line "$BG_LEFT" "$FONT_LEFT" "$BG_RIGHT" "$FONT_RIGHT" \
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

# Главная функция
main() {
    echo "=== СИСТЕМНАЯ ИНФОРМАЦИЯ (цветной вывод) ==="
    echo ""
    
    # Выводим цветную информацию
    get_colored_system_info
    
    echo ""
    echo "============================================="
}

# Запускаем скрипт
main "$@"
