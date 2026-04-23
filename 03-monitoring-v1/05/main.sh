#!/bin/bash
# Файл: main.sh
# Назначение: Part 5 - Анализ файловой системы

# Подключаем модули
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/validators.sh"
source "$SCRIPT_DIR/analyzer.sh"

# Проверяем параметры
if ! validate_all "$@"; then
    exit 1
fi

# Сохраняем путь
TARGET_PATH="$1"

# Замер времени начала выполнения
START_TIME=$(date +%s.%N)

# Главная функция
main() {
    echo "=============================================="
    echo "  АНАЛИЗ ФАЙЛОВОЙ СИСТЕМЫ"
    echo "=============================================="
    echo "Целевая директория: $TARGET_PATH"
    echo ""
    
    # Запускаем анализ
    analyze_directory "$TARGET_PATH"
    
    # Выводим статистику
    print_statistics
    
    # Замер времени конца выполнения
    END_TIME=$(date +%s.%N)
    
    # Вычисляем время выполнения
    EXECUTION_TIME=$(echo "$END_TIME - $START_TIME" | bc)
    
    echo ""
    echo "=============================================="
    echo "Script execution time (in seconds) = $EXECUTION_TIME"
    echo "=============================================="
}

# Обработка ошибок
handle_error() {
    echo "Ошибка при выполнении скрипта"
    exit 1
}

# Устанавливаем обработчики ошибок
trap handle_error ERR

# Запускаем основную функцию
main "$@"
