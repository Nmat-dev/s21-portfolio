#!/bin/bash
# Файл: colors.sh
# Назначение: Функции для цветного вывода

# Коды цветов для текста
declare -A font_colors
font_colors[1]='\033[37m'  # white
font_colors[2]='\033[31m'  # red
font_colors[3]='\033[32m'  # green
font_colors[4]='\033[34m'  # blue
font_colors[5]='\033[35m'  # purple
font_colors[6]='\033[30m'  # black

# Коды цветов для фона
declare -A background_colors
background_colors[1]='\033[47m'  # white
background_colors[2]='\033[41m'  # red
background_colors[3]='\033[42m'  # green
background_colors[4]='\033[44m'  # blue
background_colors[5]='\033[45m'  # purple
background_colors[6]='\033[40m'  # black

# Сброс цветов
RESET='\033[0m'

# Функция для получения кода цвета текста
get_font_color() {
    local color_num="$1"
    echo "${font_colors[$color_num]:-${font_colors[1]}}"
}

# Функция для получения кода цвета фона
get_bg_color() {
    local color_num="$1"
    echo "${background_colors[$color_num]:-${background_colors[1]}}"
}

# Функция для цветного вывода текста
print_colored() {
    local bg_color="$1"
    local font_color="$2"
    local text="$3"
    
    local bg_code=$(get_bg_color "$bg_color")
    local font_code=$(get_font_color "$font_color")
    
    echo -e "${bg_code}${font_code}${text}${RESET}"
}

# Функция для получения имени цвета (для отладки)
get_color_name() {
    case "$1" in
        1) echo "white" ;;
        2) echo "red" ;;
        3) echo "green" ;;
        4) echo "blue" ;;
        5) echo "purple" ;;
        6) echo "black" ;;
        *) echo "default" ;;
    esac
}

# Функция для вывода строки с разными цветами для левой и правой частей
print_colored_line() {
    local bg_left="$1"
    local font_left="$2"
    local bg_right="$3"
    local font_right="$4"
    local left_text="$5"
    local right_text="$6"
    
    local left_bg=$(get_bg_color "$bg_left")
    local left_font=$(get_font_color "$font_left")
    local right_bg=$(get_bg_color "$bg_right")
    local right_font=$(get_font_color "$font_right")
    
    echo -e "${left_bg}${left_font}${left_text}${RESET}\
${right_bg}${right_font}${right_text}${RESET}"
}
