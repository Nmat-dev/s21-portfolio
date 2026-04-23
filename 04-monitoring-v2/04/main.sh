#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/validator.sh"
source "$SCRIPT_DIR/generator.sh"

# Параметры по умолчанию
NUM_FILES="${1:-5}"
MIN_ENTRIES="${2:-100}"
MAX_ENTRIES="${3:-1000}"

# Проверка количества аргументов
check_args_count "$@"

# Валидация
validate_days "$NUM_FILES"
validate_entries "$MIN_ENTRIES" "$MAX_ENTRIES"

echo "=== Nginx Log Generator ==="
echo "Files: $NUM_FILES"
echo "Entries per file: $MIN_ENTRIES - $MAX_ENTRIES"
echo ""

# Запуск генерации
create_all_logs "$NUM_FILES" "$MIN_ENTRIES" "$MAX_ENTRIES"

echo ""
echo "Log files created in: $(pwd)"
ls -lh nginx_log_day*.log