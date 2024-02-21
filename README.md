# Демо - генерация дашборда Grafana с помощью JSonnet

## Необходимые инструменты

### Установка jsonnet и jsonnet-bundler:
```brew install jsonnet jsonnet-bundler```

### Установка библиотеки Grafonnet:
```jb install github.com/grafana/grafonnet/gen/grafonnet-latest@main```

## Необходимые данные

Для создания реально работающего дашборда с данными, необходимо, чтобы в вашем Prometheus-датасорсе присутствовали метрики:

- `up {service}` (gauge) - метрика, отражающая рабочее состояние сервиса (булево значение, 0 или 1), название сервиса должно быть указано в лейбле `service`. Знач
- `errors` (gauge) - метрика, отображающая процент ошибок (значение с плавающей точкой от 0 до 1) с произвольными лейблами
- `latency_z` (gauge) - метрика, отображающая z-оценку (стандартное отклонение) времени обработки запросов, с произвольными лейблами.

Подробнее о Z-оценке тут: [Standard Score (Wikipedia)](https://en.wikipedia.org/wiki/Standard_score)

Как считать Z-оценку в Prometheus: [How to use Prometheus for anomaly detection in GitLab](How to use Prometheus for anomaly detection in GitLab)

## Настройки дашборда, значения в yaml-файле

- `name:` - название дашборда
- `datasource:` - датасорс в Grafana
- `steps[]` - список шагов или этапа, выполняемых в ходе бизнес-процесса
    - `name:` - название шага или этапа (не используется)
    - `error_threshold:` - допустимый процент ошибок на этом шаге
    - `filters:` - список labels для фильтрации метрик по этому шагу

### Собственно, генерация
```jsonnet -J vendor main.jsonnet --ext-code values="std.parseYaml(importstr './client_flow.yml')" > client_flow_dashboard.json```

Полученный файл `client_flow_dashboard.json` импортировать в Grafana >>> профит!