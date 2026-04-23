#!/bin/bash

# Определяем путь к текущей папке скрипта для подключения модулей
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Подключаем модули
source "$SCRIPT_DIR/validator.sh"
source "$SCRIPT_DIR/checker.sh"
source "$SCRIPT_DIR/logger.sh"
source "$SCRIPT_DIR/generator.sh"

# === ОЧИСТКА ЛОГА ПЕРЕД ЗАПУСКОМ ===
# Очищаем файл лога, чтобы при повторном запуске не было дубликатов
> "$LOG_FILE"

# 1. Проверка количества аргументов
check_args_count "$@"

# 2. Присваиваем переменные
PATH_ROOT="$1"
DIR_COUNT="$2"
DIR_CHARS="$3"
FILE_COUNT="$4"
FILE_CHARS="$5"
FILE_SIZE="$6"

# 3. Валидация параметров
validate_path "$PATH_ROOT"
validate_count "$DIR_COUNT"
validate_chars "$DIR_CHARS" 7
validate_count "$FILE_COUNT"
validate_file_param "$FILE_CHARS"
validate_size "$FILE_SIZE"

# 4. Проверка места на диске
check_disk_space

# 5. Запуск генерации
create_structure "$PATH_ROOT" "$DIR_COUNT" "$DIR_CHARS" "$FILE_COUNT" "$FILE_CHARS" "$FILE_SIZE"

echo "Done. Check $LOG_FILE for details."