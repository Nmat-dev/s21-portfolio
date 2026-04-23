#!/bin/bash
# Файл: validators.sh
# Назначение: Проверки для Part 5

# Проверка количества параметров
validate_param_count() {
    if [ $# -ne 1 ]; then
        echo "Ошибка: скрипт запускается с одним параметром - путем к директории"
        echo "Пример: $0 /var/log/"
        return 1
    fi
    return 0
}

# Проверка что параметр заканчивается на /
validate_path_format() {
    local path="$1"
    if [[ "$path" != */ ]]; then
        echo "Ошибка: параметр должен заканчиваться знаком '/'"
        echo "Пример: $0 /var/log/"
        return 1
    fi
    return 0
}

# Проверка что директория существует и доступна
validate_directory() {
    local path="$1"
    
    if [ ! -d "$path" ]; then
        echo "Ошибка: директория '$path' не существует"
        return 1
    fi
    
    if [ ! -r "$path" ]; then
        echo "Ошибка: нет прав на чтение директории '$path'"
        return 1
    fi
    
    return 0
}

# Главная функция проверки
validate_all() {
    if ! validate_param_count "$@"; then
        return 1
    fi
    
    if ! validate_path_format "$1"; then
        return 1
    fi
    
    if ! validate_directory "$1"; then
        return 1
    fi
    
    echo "Параметр корректный: $1"
    return 0
}
