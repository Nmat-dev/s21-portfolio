#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/validator.sh"
source "$SCRIPT_DIR/logger.sh"
source "$SCRIPT_DIR/analyzer.sh"

# Очистка лога анализа
> "$LOG_FILE"

# Проверка количества аргументов
check_args_count "$@"

# Получаем метод анализа
METHOD="$1"

# Путь к лог-файлу
LOG_FILE_PATH="${2:-../04/nginx_log_day1.log}"

# Если файл не найден, ищем любой nginx_log
if [ ! -f "$LOG_FILE_PATH" ]; then
    LOG_FILE_PATH=$(find .. -name "nginx_log_day*.log" -type f 2>/dev/null | head -1)
fi

# Если всё ещё не найден, ошибка
if [ -z "$LOG_FILE_PATH" ] || [ ! -f "$LOG_FILE_PATH" ]; then
    echo "Error: No nginx log files found. Please run Part 4 first." >&2
    exit 1
fi

# Валидация метода
validate_method "$METHOD"

# Валидация файла
validate_log_file "$LOG_FILE_PATH"

# === Заголовки в stderr ===
echo "=== Nginx Log Analyzer ===" >&2
echo "Log file: $LOG_FILE_PATH" >&2
echo "Method: $METHOD" >&2
echo "" >&2

run_analysis "$METHOD" "$LOG_FILE_PATH"

echo "" >&2
echo "Analysis complete. Check $LOG_FILE for details." >&2