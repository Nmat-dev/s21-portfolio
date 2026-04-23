#!/bin/bash
# Файл: validators.sh
# Назначение: Проверки параметров для Part 3

# Проверка количества параметров
validate_param_count() {
    if [ $# -ne 4 ]; then
        echo "Ошибка: скрипт запускается с 4 параметрами"
        echo "Пример: $0 1 3 4 5"
        echo "Где:"
        echo "  1 - фон названий значений"
        echo "  2 - цвет шрифта названий значений" 
        echo "  3 - фон значений"
        echo "  4 - цвет шрифта значений"
        echo "Доступные цвета: 1-white, 2-red, 3-green, 4-blue, 5-purple, 6-black"
        return 1
    fi
    return 0
}

# Проверка что параметры от 1 до 6
validate_param_range() {
    local i=1
    for param in "$@"; do
        if ! [[ "$param" =~ ^[1-6]$ ]]; then
            echo "Ошибка: параметр $i='$param' должен быть числом от 1 до 6"
            return 1
        fi
        ((i++))
    done
    return 0
}

# Проверка что цвета в одном столбце не совпадают
validate_color_matching() {
    local bg_left="$1"
    local font_left="$2"
    local bg_right="$3"
    local font_right="$4"
    
    # Левый столбец: фон и текст
    if [ "$bg_left" -eq "$font_left" ]; then
        echo "Ошибка: цвет фона ($bg_left) и шрифта ($font_left) в левом столбце совпадают"
        echo "Это делает текст нечитаемым"
        return 1
    fi
    
    # Правый столбец: фон и текст
    if [ "$bg_right" -eq "$font_right" ]; then
        echo "Ошибка: цвет фона ($bg_right) и шрифта ($font_right) в правом столбце совпадают"
        echo "Это делает текст нечитаемым"
        return 1
    fi
    
    return 0
}

# Функция для получения имени цвета (для сообщений об ошибке)
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

# Главная функция проверки всех параметров
validate_all_params() {
    # Проверка количества
    if ! validate_param_count "$@"; then
        return 1
    fi
    
    # Проверка диапазона
    if ! validate_param_range "$@"; then
        return 1
    fi
    
    # Проверка совпадения цветов
    if ! validate_color_matching "$@"; then
        return 1
    fi
    
    # Все проверки пройдены
    echo "Параметры корректны:"
    echo "  Левый столбец: фон=$(get_color_name "$1"), текст=$(get_color_name "$2")"
    echo "  Правый столбец: фон=$(get_color_name "$3"), текст=$(get_color_name "$4")"
    return 0
}
