# Docker Counter — ДЗ №3 по ИПР

Python HTTP-приложение со счётчиком запросов, упакованное в Docker. Для хранения данных используется Redis с включённым AOF.

Условие задания: https://github.com/Nikfilk2030/missing_semester_hse_cs/blob/main/2026/amcs/year_1/hw_3/README.md

## Структура

- app/ — исходный код приложения.
- Dockerfile — сборка образа.
- .dockerignore — исключения при сборке.
- compose.yaml — конфигурация приложения и Redis.
- .env.example — пример настроек.
- .gitignore — исключение локальных файлов.

## Запуск

Требуются Docker и Docker Compose.

Скопировать настройки:

    cp .env.example .env

Запустить сервисы:

    docker compose up -d --build

Проверить контейнеры:

    docker compose ps

Открыть приложение:

    curl http://localhost:8000

## Настройки

Переменные в файле .env:

- APP_PORT — порт приложения на компьютере, по умолчанию 8000.
- GREETING — текст приветствия.

Приложение использует STORAGE=redis и REDIS_URL=redis://redis:6379/0.

Redis доступен внутри Docker Compose по имени redis. Его порт не публикуется на хост.

## Хранение данных

Redis использует AOF (appendonly yes). Данные хранятся в /data, подключённом к именованному тому redis_data.

Команда остановки:

    docker compose down

Том сохраняется. Не использовать docker compose down -v, если нужно сохранить данные.

## HTTP endpoints

- GET / — приветствие, счётчик, hostname и тип хранилища.
- POST /increment — увеличение счётчика.
- GET /healthz — проверка доступности HTTP-сервера.
- GET /readyz — проверка доступности хранилища.

При недоступности Redis /healthz возвращает 200, а /readyz и POST /increment возвращают 503.

## Результаты тестирования

### 1. Работа приложения

Приложение успешно запустилось в Docker. Переменная GREETING передала пользовательское приветствие. Счётчик увеличился с 0 до 1.

### 2. Сохранение данных

Выполнены команды:

    docker compose down
    docker compose up -d
    curl http://localhost:8000

Результат: счётчик сохранил значение 3 после пересоздания контейнеров.

### 3. Отключение Redis

Выполнена команда:

    docker compose stop redis

Результаты проверок:

- GET /healthz — 200 OK.
- GET /readyz — 503 Service Unavailable.
- POST /increment — 503 Service Unavailable.

### 4. Восстановление Redis

Выполнены команды:

    docker compose start redis
    curl http://localhost:8000
    curl -X POST http://localhost:8000/increment

Результат: приложение восстановило доступ к Redis без перезапуска. Счётчик сохранил значение 3 и после POST увеличился до 4.

## Логи

Просмотр логов приложения и Redis:

    docker compose logs app
    docker compose logs redis

## Остановка

    docker compose down
