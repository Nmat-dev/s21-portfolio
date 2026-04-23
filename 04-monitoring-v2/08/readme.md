# Part 8: Готовый дашборд + Тестирование сети

- Импортирован: node-exporter-quickstart-and-dashboard (ID: 13978)
- Источник: https://grafana.com/grafana/dashboards/13978-node-exporter-quickstart-and-dashboard/

## Тесты
### 1. Стресс-тест (CPU + RAM)
```bash
stress -c 4 -i 2 -m 2 --vm-bytes 128M -t 30s

### 2. Тест сети (iperf3, две ВМ)
# r1 (сервер)
iperf3 -s

# r2 (клиент)
iperf3 -c 10.10.0.1