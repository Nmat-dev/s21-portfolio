#!/bin/bash
# Файл: system_info.sh
# Назначение: Функции для сбора системной информации

get_hostname() {
    hostname
}

get_timezone() {
    # На Ubuntu 20.04
    timedatectl show --property=Timezone --value 2>/dev/null || \
    cat /etc/timezone 2>/dev/null || \
    echo "Unknown"
}

get_user() {
    whoami
}

get_os() {
    # Ubuntu 20.04 точно имеет /etc/os-release
    source /etc/os-release
    echo "$PRETTY_NAME"
}

get_date() {
    date '+%d %b %Y %H:%M:%S'
}

get_uptime() {
    uptime -p | sed 's/up //'
}

get_uptime_sec() {
    awk '{print int($1)}' /proc/uptime
}

get_ip() {
    # Первый не-localhost IP
    hostname -I | awk '{print $1}' 2>/dev/null || \
    ip route get 1 | awk '{print $7; exit}' 2>/dev/null || \
    echo "127.0.0.1"
}

get_mask() {
    # Простой способ через ifconfig
    local ip=$(get_ip)
    
    # Ищем маску для IP
    if command -v ifconfig &> /dev/null; then
        ifconfig | grep -B1 "$ip" | grep netmask | awk '{print $4}'
    else
        # Через ip command
        ip -o -f inet addr show | grep "$ip" | awk '{print $4}' | cut -d'/' -f2 | \
        while read cidr; do
            case $cidr in
                24) echo "255.255.255.0" ;;
                16) echo "255.255.0.0" ;;
                8) echo "255.0.0.0" ;;
                *) echo "255.255.255.0" ;;
            esac
        done
    fi
}

get_gateway() {
    ip route | grep default | awk '{print $3}' | head -1 2>/dev/null || \
    echo "0.0.0.0"
}

get_ram_info() {
    # Получаем значения из /proc/meminfo
    local mem_total mem_free mem_available
    
    mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    mem_free=$(grep MemFree /proc/meminfo | awk '{print $2}')
    mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    
    if [ -z "$mem_available" ]; then
        mem_available=$mem_free
    fi
    
    # Конвертируем в Гб с 3 знаками после запятой
    local total_gb used_gb free_gb
    
    total_gb=$(echo "scale=3; $mem_total / 1024 / 1024" | bc | sed 's/^\./0./')
    used_gb=$(echo "scale=3; ($mem_total - $mem_available) / 1024 / 1024" | bc | sed 's/^\./0./')
    free_gb=$(echo "scale=3; $mem_free / 1024 / 1024" | bc | sed 's/^\./0./')
    
    echo "$total_gb $used_gb $free_gb"
}

get_root_space_info() {
    # Используем df для раздела /
    df -BM / | awk '
    NR==2 {
        total = $2
        used = $3
        free = $4
        
        # Убираем "M" и форматируем
        gsub("M", "", total)
        gsub("M", "", used)
        gsub("M", "", free)
        
        printf "%.2f %.2f %.2f", total, used, free
    }' 2>/dev/null || echo "0.00 0.00 0.00"
}
