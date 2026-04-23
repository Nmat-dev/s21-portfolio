#!/bin/bash

# ============================================================
# КОДЫ ОТВЕТА HTTP (nginx):
# ============================================================
# 200 - OK: Запрос успешно выполнен
# 201 - Created: Ресурс успешно создан (после POST/PUT)
# 400 - Bad Request: Неверный синтаксис запроса
# 401 - Unauthorized: Требуется аутентификация
# 403 - Forbidden: Доступ запрещён (нет прав)
# 404 - Not Found: Ресурс не найден
# 500 - Internal Server Error: Ошибка на стороне сервера
# 501 - Not Implemented: Метод не поддерживается
# 502 - Bad Gateway: Неверный ответ от вышестоящего сервера
# 503 - Service Unavailable: Сервер временно недоступен
# ============================================================

# Массивы данных
HTTP_CODES=(200 201 400 401 403 404 500 501 502 503)
HTTP_METHODS=("GET" "POST" "PUT" "PATCH" "DELETE")
USER_AGENTS=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Google Chrome/120.0.0.0 Safari/537.36"
    "Opera/9.80 (Windows NT 10.0; Win64; x64)"
    "Safari/605.1.15 (Macintosh; Intel Mac OS X 10_15_7)"
    "Internet Explorer/11.0 (Windows NT 10.0)"
    "Microsoft Edge/120.0.0.0 (Windows NT 10.0; Win64; x64)"
    "Crawler and bot (Googlebot/2.1; +http://www.google.com/bot.html)"
    "Library and net tool (curl/7.68.0)"
)
URLS=(
    "/" "/index.html" "/api/users" "/api/products" "/login"
    "/logout" "/dashboard" "/static/css/style.css" "/static/js/app.js"
    "/images/logo.png" "/api/orders" "/api/search" "/contact" "/about"
)

get_random_element() {
    local arr=("$@")
    local len=${#arr[@]}
    echo "${arr[$((RANDOM % len))]}"
}

format_log_line() {
    local ip="$1"
    local date="$2"
    local time="$3"
    local method="$4"
    local url="$5"
    local status="$6"
    local size="$7"
    local agent="$8"
    
    # Формат: IP - - [DD/Mon/YYYY:HH:MM:SS +0000] "METHOD URL HTTP/1.1" STATUS SIZE "REFERER" "AGENT"
    printf '%s - - [%s:%s +0000] "%s %s HTTP/1.1" %s %s "-" "%s"\n' \
        "$ip" "$date" "$time" "$method" "$url" "$status" "$size" "$agent"
}