# AviTost - Монорепозиторий

[![GitHub](https://img.shields.io/badge/GitHub-zhukovvlad%2Favitost-blue?logo=github)](https://github.com/zhukovvlad/avitost)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Полнофункциональная микросервисная платформа для работы с объявлениями и биллингом.

## 🏗 Архитектура

- 🔥 **Python Backend** (FastAPI) - OAuth авторизация через Yandex
- 🏃 **Go Backend** (Gin) - Avito API, система биллинга, высокая производительность
- ⚛️ **Frontend** (React + Vite) - Современный пользовательский интерфейс
- 🤖 **Telegram Bot** (aiogram) - Бот для загрузки фото в Яндекс.Диск
- 🗄️ **PostgreSQL 16** - Основная база данных
- 🔄 **Redis 7** - Кеширование и сессии
- 📦 **MinIO** - S3-совместимое объектное хранилище

## 🚀 Быстрый старт

### Вариант 1: Full Docker (Production-like)

```bash
git clone https://github.com/zhukovvlad/avitost.git
cd avitost

# Настройка переменных окружения
cp .env.example .env
nano .env  # Заполните токены

# Запуск ВСЕХ сервисов в Docker
cd infra/compose
docker-compose up -d

# Проверка статуса
docker-compose ps
```

Сервисы будут доступны:

- **FastAPI Backend**: http://localhost:8000
- **Go Backend**: http://localhost:8080
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379
- **MinIO**: http://localhost:9000 (Console: 9001)

### Вариант 2: Hybrid Development ⭐ **Рекомендуется для разработки**

```bash
git clone https://github.com/zhukovvlad/avitost.git
cd avitost

# Настройка переменных окружения
cp .env.example .env
nano .env  # Заполните токены

# 1. Запуск инфраструктуры в Docker
cd infra/compose
docker-compose up -d postgres redis minio

# 2. Запуск приложений локально (из корня проекта)
cd ../../
make install  # Установка зависимостей
make dev      # Запуск с hot reload
```

Сервисы будут доступны:

- **FastAPI Backend**: http://localhost:8000 (локально)
- **Go Backend**: http://localhost:8001 (локально, другой порт!)
- **PostgreSQL**: localhost:5432 (Docker)
- **Redis**: localhost:6379 (Docker)
- **MinIO**: http://localhost:9000 (Docker)

### Вариант 3: Полностью локально

```bash
git clone https://github.com/zhukovvlad/avitost.git
cd avitost

# Требует установленных PostgreSQL и Redis локально
cp .env.example .env
nano .env  # Заполните токены
make install
make dev
```

Сервисы будут доступны:

- **Python Backend**: http://localhost:8000
- **Go Backend**: http://localhost:8001
- **Frontend**: http://localhost:5173
- **API Docs**: http://localhost:8000/docs

## 🌐 API Endpoints

### FastAPI Backend (8000 / 8000 в Docker):

- `GET /` - Главная страница
- `GET /api/login` - OAuth Yandex авторизация
- `GET /docs` - Swagger документация
- `GET /redoc` - ReDoc документация

### Go Backend (8001 локально / 8080 в Docker):

- `GET /health` - Health check
- `GET /api/health` - Альтернативный health check
- `GET /api/v1/status` - Статус сервисов
- `GET /api/v1/avito/categories` - Категории Avito
- `GET /api/v1/avito/search?query=...` - Поиск объявлений
- `GET /api/v1/billing/users/:id/balance` - Баланс пользователя
- `POST /api/v1/billing/users/:id/payments` - Создать платеж

### Инфраструктурные сервисы:

- **PostgreSQL**: localhost:5432 (app:app)
- **Redis**: localhost:6379
- **MinIO**: http://localhost:9000 (minio:minio123)

## 🛠 Доступные команды

### Docker команды:

```bash
# Full Docker (все сервисы в контейнерах)
cd infra/compose
docker-compose up -d          # Запуск всех сервисов
docker-compose ps             # Просмотр статуса
docker-compose logs [service] # Просмотр логов
docker-compose down           # Остановка всех сервисов

# Hybrid (только инфраструктура в Docker)
cd infra/compose
docker-compose up -d postgres redis minio  # Только БД + кеш + storage
cd ../../
make dev                      # Приложения локально

# Пересборка контейнера после изменений
docker-compose build fastapi && docker-compose up -d fastapi
```

### Make команды (локальная разработка):

```bash
make help              # Показать все доступные команды
make install           # Установить все зависимости
make dev              # Запустить все сервисы локально
make backend-dev      # Запустить Python backend
make backend-go-dev   # Запустить Go backend
make frontend-dev     # Запустить frontend
make bot-dev          # Запустить telegram bot
make stop             # Остановить все сервисы
make clean            # Очистить кеши
```

### Быстрые команды для разработки:

```bash
# Hybrid режим одной командой (рекомендуется)
cd infra/compose && docker-compose up -d postgres redis minio && cd ../../ && make dev

# Остановить все
cd infra/compose && docker-compose down
```

## 📁 Структура проекта

```
avitost/
├── apps/
│   ├── backend/           # FastAPI приложение (Python)
│   │   ├── app/
│   │   │   └── main.py   # OAuth, интеграции
│   │   ├── requirements.txt
│   │   ├── Dockerfile    # Docker конфигурация
│   │   └── .venv/        # Виртуальное окружение
│   ├── backend-go/       # Gin приложение (Go)
│   │   ├── cmd/api/      # Точка входа
│   │   ├── internal/     # Бизнес-логика
│   │   │   ├── avito/    # Avito API клиент
│   │   │   ├── billing/  # Система биллинга
│   │   │   ├── config/   # Конфигурация
│   │   │   └── http/     # HTTP обработчики
│   │   ├── go.mod
│   │   └── Dockerfile    # Docker конфигурация
│   ├── frontend/         # React приложение
│   │   ├── src/
│   │   ├── package.json
│   │   └── node_modules/
│   └── tg-bot/          # Telegram бот
│       ├── app/
│       │   └── main.py  # Основной файл бота
│       ├── requirements.txt
│       └── .venv/       # Виртуальное окружение
├── infra/               # Docker и инфраструктура
│   └── compose/
│       └── docker-compose.yml  # Полный стек сервисов
├── packages/            # Общие пакеты/схемы
├── .env                 # Переменные окружения
├── .env.example         # Пример переменных
├── Makefile             # Команды для разработки
└── README.md           # Эта документация
```

## 🔧 Разработка

### Python Backend

```bash
cd apps/backend
source .venv/bin/activate
uvicorn app.main:app --reload --port 8000
```

### Go Backend

```bash
cd apps/backend-go
go run main.go
# или в daemon режиме:
make backend-go-daemon
```

### Frontend

```bash
cd apps/frontend
pnpm dev
```

### Telegram Bot

```bash
cd apps/tg-bot
source .venv/bin/activate
python app/main.py
```

## 📝 Переменные окружения

Создайте файл `.env` в корне проекта:

```bash
# Backend (Python)
YANDEX_CLIENT_ID=ваш_yandex_client_id
YANDEX_CLIENT_SECRET=ваш_yandex_client_secret
OAUTH_REDIRECT_URI=http://localhost:8000/oauth/callback
OAUTH_SCOPE=login:info

# Backend (Go)
GO_PORT=8001
GO_HOST=localhost
GIN_MODE=debug
AVITO_API_KEY=ваш_avito_api_key
AVITO_BASE_URL=https://api.avito.ru
AVITO_USER_AGENT=AviTost/1.0

# Database
POSTGRES_DB=app
POSTGRES_USER=app
POSTGRES_PASSWORD=app
DB_HOST=localhost
DB_PORT=5432
DB_NAME=avitost
DB_SSLMODE=disable

# MinIO
MINIO_ROOT_USER=minio
MINIO_ROOT_PASSWORD=minio123

# Telegram Bot
TG_BOT_TOKEN=ваш_telegram_bot_token
YANDEX_TOKEN=ваш_yandex_oauth_token

# Frontend
VITE_API_BASE=http://localhost:8000/api
```

## 🚨 Troubleshooting

### Проблема: "ModuleNotFoundError"

```bash
cd apps/backend  # или apps/tg-bot
source .venv/bin/activate
pip install -r requirements.txt
```

### Проблема: "Command not found: pnpm"

```bash
npm install -g pnpm
```

### Проблема: Порт занят

```bash
make stop  # Остановить все сервисы
```

## 📚 API Documentation

После запуска сервисов, документация доступна по адресам:

- **Python Backend Swagger**: http://localhost:8000/docs
- **Python Backend ReDoc**: http://localhost:8000/redoc
- **Go Backend Health**: http://localhost:8001/health

### Тестирование API

```bash
# Docker версия (рекомендуется)
# FastAPI backend
curl http://localhost:8000/
curl http://localhost:8000/docs

# Go backend
curl http://localhost:8080/health
curl http://localhost:8080/api/v1/status

# Локальная версия
# Python backend
curl http://localhost:8000/

# Go backend
curl http://localhost:8001/health
curl http://localhost:8001/api/v1/avito/categories
curl "http://localhost:8001/api/v1/avito/search?query=iPhone"
```

## 🐳 Docker

Проект включает полную Docker конфигурацию:

- **PostgreSQL 16** - Современная версия БД
- **Redis 7-alpine** - Кеширование
- **MinIO** - S3-совместимое хранилище
- **FastAPI** - Python backend
- **Go API** - Go backend (версия 1.23)

Все сервисы имеют healthchecks и правильные зависимости запуска.

### Производственный деплой

```bash
cd infra/compose
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

📖 **Подробная документация по Docker**: [DOCKER.md](DOCKER.md)
