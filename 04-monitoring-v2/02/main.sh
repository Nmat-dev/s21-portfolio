#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/validator.sh"
source "$SCRIPT_DIR/checker.sh"
source "$SCRIPT_DIR/logger.sh"
source "$SCRIPT_DIR/generator.sh"
source "$SCRIPT_DIR/timer.sh"

# Очистка лога
> "$LOG_FILE"

# Замер времени начала
start_timer

# Проверка количества аргументов
check_args_count "$@"

# Присваиваем переменные
DIR_CHARS="$1"
FILE_CHARS="$2"
FILE_SIZE="$3"

# Валидация
validate_chars "$DIR_CHARS" 7
validate_file_param "$FILE_CHARS"
validate_size "$FILE_SIZE"

# Начальная проверка места
check_disk_space

# Запуск генерации
create_structure "$DIR_CHARS" "$FILE_CHARS" "$FILE_SIZE"

# Замер времени окончания
end_timer

# Вывод времени на экран
print_timer

# Запись времени в лог
log_timer

echo "Done. Check $LOG_FILE for details."