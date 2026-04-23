# Part 7: Prometheus & Grafana — Системный мониторинг

## Задание
- Установить и настроить Prometheus и Grafana
- Получить доступ к веб-интерфейсам с локальной машины
- Добавить дашборд с метриками: ЦПУ, ОЗУ, место на диске, операции ввода/вывода
- Протестировать нагрузкой (скрипт из Part 2 + stress)

---

## 🔧 Установка

### 1. Grafana (версия 10.0.3, ARM64)

```bash
# Скачал .deb пакет вручную (репозитории не работали)
cd /tmp
wget https://dl.grafana.com/oss/release/grafana_10.0.3_arm64.deb
sudo dpkg -i grafana_10.0.3_arm64.deb
sudo apt install -f -y  # исправление зависимостей

# Настройка доступа извне
sudo nano /etc/grafana/grafana.ini
# В секции [server] изменили:
# http_addr = 0.0.0.0

# Запуск
sudo systemctl daemon-reload
sudo systemctl enable --now grafana-server
sudo ufw allow 3000/tcp


2. Prometheus (версия 2.45.0, ARM64)
# Создал пользователя
sudo useradd --no-create-home --shell /bin/false prometheus

# Скачал и установили
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-arm64.tar.gz
tar -xvf prometheus-2.45.0.linux-arm64.tar.gz
sudo mv prometheus-2.45.0.linux-arm64/prometheus /usr/local/bin/
sudo mv prometheus-2.45.0.linux-arm64/promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

# Директории и конфиг
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo mv prometheus-2.45.0.linux-arm64/prometheus.yml /etc/prometheus/
sudo chown -R prometheus:prometheus /etc/prometheus/ /var/lib/prometheus/

# Настройка prometheus.yml
sudo nano /etc/prometheus/prometheus.yml

# Сервис systemd
sudo nano /etc/systemd/system/prometheus.service

# Запуск
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus
sudo ufw allow 9090/tcp

3. Node Exporter (версия 1.6.1, ARM64)
# Скачали и установили
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-arm64.tar.gz
tar -xvf node_exporter-1.6.1.linux-arm64.tar.gz
sudo mv node_exporter-1.6.1.linux-arm64/node_exporter /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/node_exporter

# Сервис
sudo nano /etc/systemd/system/node_exporter.service

# Запуск
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
sudo ufw allow 9100/tcp

Через SSH-туннель (с локальной машины)
# В отдельных терминалах на локальном компьютере:
# Для Grafana
ssh -L 3000:127.0.0.1:3000 -p 2222 maciecre@127.0.0.1

# Для Prometheus
ssh -L 9090:127.0.0.1:9090 -p 2222 maciecre@127.0.0.1

Grafana: http://127.0.0.1:3000 (логин: admin / admin)
Prometheus: http://127.0.0.1:9090/targets

# Настройка дашборда в Grafana
Открыли Grafana → Dashboards → New → Import
Ввели ID дашборда: 1860 (Node Exporter Full)
Нажали Load → выбрали источник Prometheus → Import

Тестирование нагрузкой
1. Скрипт из Part 2 (засорение ФС)
cd ~/projects/DO4_LinuxMonitoring_v2.0.ID_356280-1/src/02
sudo ./main.sh 100 100M

2. Stress-тест (CPU + RAM + I/O)
# Установка
sudo apt install -y stress

# Запуск
stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s
-c 2 2 CPU workers (нагрузка на процессор)
-i 1 1 I/O worker (нагрузка на диск)
-m 1 1 memory worker (нагрузка на ОЗУ)
--vm-bytes 32M Выделить 32 MB памяти
-t 10s Длительность теста: 10 секунд

 Проверка работоспособности
 # Все сервисы запущены?
sudo systemctl status grafana-server prometheus node_exporter

# Порты слушаются?
sudo ss -tlnp | grep -E '3000|9090|9100'

# Node Exporter отдаёт метрики?
curl -s http://127.0.0.1:9100/metrics | grep "^node_" | head -5

# Prometheus собирает данные?
curl -s http://127.0.0.1:9090/api/v1/targets | grep -o '"health":"[^"]*"' | sort | uniq -c