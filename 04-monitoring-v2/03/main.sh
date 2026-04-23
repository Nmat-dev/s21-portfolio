#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/validator.sh"
source "$SCRIPT_DIR/logger.sh"
source "$SCRIPT_DIR/cleaner1.sh"
source "$SCRIPT_DIR/cleaner2.sh"
source "$SCRIPT_DIR/cleaner3.sh"

# Очистка лога удаления
> "$LOG_FILE"

# Проверка количества аргументов
check_args_count "$@"

# Получаем метод очистки
METHOD="$1"

# Валидация метода
validate_method "$METHOD"

echo "=== Filesystem Cleanup ==="
echo "Method: $METHOD"
echo ""

case "$METHOD" in
    1)
        # Очистка по лог-файлу
        LOG_PATH="${2:-generator.log}"
        clean_by_log "$LOG_PATH"
        ;;
    2)
        # Очистка по дате/времени
        START_TIME="$2"
        END_TIME="$3"
        clean_by_date "$START_TIME" "$END_TIME"
        ;;
    3)
        # Очистка по маске имени
        DIR_CHARS="$2"
        FILE_CHARS="$3"
        DATE_SUFFIX="$4"
        clean_by_mask "$DIR_CHARS" "$FILE_CHARS" "$DATE_SUFFIX"
        ;;
esac

echo ""
echo "Cleanup complete. Check $LOG_FILE for details."