#!/bin/bash
# Файл: main.sh
# Назначение: Главный скрипт, объединяющий всё

# Подключаем наши модули
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/system_info.sh"
source "$SCRIPT_DIR/file_saver.sh"

# Проверяем, что модули загрузились
if ! declare -f get_hostname > /dev/null; then
    echo "Ошибка: не загружен system_info.sh"
    exit 1
fi

# Функция для форматированного вывода всех данных
get_formatted_system_info() {
    echo "HOSTNAME = $(get_hostname)"
    echo "TIMEZONE = $(get_timezone)"
    echo "USER = $(get_user)"
    echo "OS = $(get_os)"
    echo "DATE = $(get_date)"
    echo "UPTIME = $(get_uptime)"
    echo "UPTIME_SEC = $(get_uptime_sec)"
    echo "IP = $(get_ip)"
    echo "MASK = $(get_mask)"
    echo "GATEWAY = $(get_gateway)"
    
    # RAM информация (3 значения)
    local ram_info
    ram_info=$(get_ram_info)
    echo "RAM_TOTAL = $(echo "$ram_info" | awk '{print $1}') GB"
    echo "RAM_USED = $(echo "$ram_info" | awk '{print $2}') GB"
    echo "RAM_FREE = $(echo "$ram_info" | awk '{print $3}') GB"
    
    # Root space информация (3 значения)
    local space_info
    space_info=$(get_root_space_info)
    echo "SPACE_ROOT = $(echo "$space_info" | awk '{print $1}') MB"
    echo "SPACE_ROOT_USED = $(echo "$space_info" | awk '{print $2}') MB"
    echo "SPACE_ROOT_FREE = $(echo "$space_info" | awk '{print $3}') MB"
}

# Главная функция
main() {
    echo "=== СИСТЕМНАЯ ИНФОРМАЦИЯ ==="
    echo ""
    
    # Получаем все данные
    local system_info
    system_info=$(get_formatted_system_info)
    
    # Выводим на экран
    echo "$system_info"
    
    # Спрашиваем о сохранении
    ask_to_save "$system_info"
}

# Запускаем скрипт
main "$@"
