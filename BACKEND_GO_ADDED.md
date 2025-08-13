# 🎉 Обновленная структура проекта с Go Backend!

## 📁 Новая архитектура монорепозитория

```
avitost/
├── apps/
│   ├── backend/          # 🐍 Python Backend (FastAPI)
│   │   ├── app/main.py   # OAuth авторизация Yandex
│   │   └── requirements.txt
│   ├── backend-go/       # 🏃 Go Backend (Gin) - НОВЫЙ!
│   │   ├── cmd/api/      # Точка входа
│   │   ├── internal/     # Бизнес-логика
│   │   │   ├── avito/    # Avito API клиент
│   │   │   ├── billing/  # Система биллинга
│   │   │   ├── config/   # Конфигурация
│   │   │   ├── http/     # HTTP обработчики
│   │   │   ├── jobs/     # Фоновые задачи
│   │   │   └── repository/ # Работа с БД
│   │   ├── go.mod
│   │   └── README.md
│   ├── frontend/         # ⚛️ React Frontend
│   └── tg-bot/          # 🤖 Telegram Bot
├── db/                   # 🗄️ База данных - НОВАЯ!
│   └── migrations/       # SQL миграции
└── ...
```

## 🚀 Новые возможности

### Go Backend (порт 8001)

- **Avito API** - поиск объявлений и категории
- **Billing System** - управление балансом и транзакциями
- **Microservices Architecture** - модульная структура
- **High Performance** - быстрый Go сервер

### Обновленная инфраструктура

- **База данных** - поддержка PostgreSQL
- **Два backend'а** - Python для OAuth, Go для бизнес-логики
- **Расширенная конфигурация** - больше переменных окружения

## 📡 API Endpoints

### Python Backend (8000)

- `GET /api/health` - Health check
- `GET /api/login` - OAuth Yandex

### Go Backend (8001)

- `GET /health` - Health check
- `GET /api/v1/status` - Статус сервисов
- `GET /api/v1/avito/categories` - Категории Avito
- `GET /api/v1/avito/search` - Поиск объявлений
- `GET /api/v1/billing/users/:id/balance` - Баланс пользователя
- `POST /api/v1/billing/users/:id/payments` - Создать платеж

## 🛠 Обновленные команды

```bash
# Установка всех зависимостей (включая Go)
make install

# Запуск всех сервисов
make dev  # Python + Go + Frontend + Bot

# Отдельные сервисы
make backend-dev      # Python backend (8000)
make backend-go-dev   # Go backend (8001)
make frontend-dev     # React frontend (5173)
make bot-dev         # Telegram bot

# Остановка всех сервисов
make stop
```

## ⚙️ Новые переменные окружения

```bash
# Backend (Go)
GO_PORT=8001
GO_HOST=localhost
GIN_MODE=debug
AVITO_API_KEY=your_api_key
AVITO_BASE_URL=https://api.avito.ru

# Database
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=password
DB_NAME=avitost
```

## 🎯 VS Code Tasks

Обновлены задачи в workspace:

- **🚀 Start All Services** - все сервисы
- **🔥 Python Backend Dev** - только Python
- **🏃 Go Backend Dev** - только Go
- **⚛️ Frontend Dev** - только React
- **🤖 Bot Dev** - только бот

## 🧪 Тестирование

```bash
# Тест Python backend
curl http://localhost:8000/api/health

# Тест Go backend
curl http://localhost:8001/api/v1/status

# Тест Avito API
curl "http://localhost:8001/api/v1/avito/categories"

# Тест поиска
curl "http://localhost:8001/api/v1/avito/search?q=автомобиль&limit=5"
```

## 🏗 Архитектурные решения

### Разделение ответственности

- **Python Backend** - OAuth, интеграции с внешними API
- **Go Backend** - высокопроизводительная бизнес-логика
- **Frontend** - пользовательский интерфейс
- **Bot** - Telegram интеграция

### Микросервисная архитектура

- Каждый сервис на своем порту
- Независимое развертывание
- Горизонтальное масштабирование

### Базы данных

- PostgreSQL для основных данных
- Миграции в `db/migrations/`
- Поддержка connection pooling

## 🚀 Готово к продакшену!

Монорепозиторий теперь включает:

- ✅ 4 микросервиса
- ✅ Современная архитектура
- ✅ Высокая производительность
- ✅ Полная документация
- ✅ Готовые инструменты разработки

Проект готов к масштабированию и командной разработке! 🎯
