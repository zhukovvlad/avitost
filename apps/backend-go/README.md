# Go Backend для AviTost

## 🚀 Описание

Высокопроизводительный Go backend для работы с:

- **Avito API** - поиск объявлений, получение категорий
- **Billing System** - управление балансом и платежами пользователей
- **HTTP API** - RESTful API с JSON responses

## 🏗 Архитектура

```
apps/backend-go/
├── main.go              # Точка входа приложения
├── internal/            # Внутренняя бизнес-логика
│   ├── avito/          # Клиент для Avito API
│   ├── billing/        # Сервис биллинга
│   ├── config/         # Управление конфигурацией
│   └── http/           # HTTP обработчики и роутинг
├── go.mod              # Go модуль и зависимости
├── go.sum              # Хеши зависимостей
└── README.md          # Эта документация
```

## 🛠 Установка и запуск

### Требования

- Go 1.21+
- PostgreSQL (для продакшена)

### Быстрый старт

```bash
# Установка зависимостей
cd apps/backend-go
go mod tidy

# Запуск сервера
go run main.go

# Или из корня проекта
make backend-go-dev
```

## 🌐 Переменные окружения

```bash
# Go Backend
GO_PORT=8001
GO_HOST=localhost
GIN_MODE=debug

# Database (опционально для будущего развития)
DATABASE_URL=postgres://user:password@localhost:5432/avitost

# Avito API (для будущей интеграции)
AVITO_API_URL=https://api.avito.ru
```

## 📡 API Endpoints

Сервер запускается на `http://localhost:8001`

### Health Check

- `GET /health` - Проверка работоспособности

### API v1

- `GET /api/v1/status` - Статус всех сервисов
- `GET /api/v1/avito/categories` - Категории товаров Avito
- `GET /api/v1/avito/search?query=...` - Поиск объявлений
- `GET /api/v1/billing/users/:id/balance` - Баланс пользователя
- `POST /api/v1/billing/users/:id/payments` - Создать платеж

## 📝 Примеры использования

```bash
# Health check
curl http://localhost:8001/health

# Статус сервисов
curl http://localhost:8001/api/v1/status

# Категории
curl http://localhost:8001/api/v1/avito/categories

# Поиск объявлений
curl "http://localhost:8001/api/v1/avito/search?query=iPhone"

# Баланс пользователя
curl http://localhost:8001/api/v1/billing/users/123/balance

# Создание платежа
curl -X POST http://localhost:8001/api/v1/billing/users/123/payments \
  -H "Content-Type: application/json" \
  -d '{"amount": 1000, "description": "Пополнение баланса"}'
```

## � Разработка

### Добавление нового endpoint

1. Создайте обработчик в `internal/http/`
2. Добавьте роут в `main.go`
3. Обновите документацию

### Структура пакетов

- `internal/avito/` - Работа с Avito API
- `internal/billing/` - Система биллинга
- `internal/config/` - Конфигурация приложения
- `internal/http/` - HTTP обработчики и middleware

## 🚀 Деплой

```bash
# Сборка бинарника
go build -o avitost-backend main.go

# Запуск
./avitost-backend
```
