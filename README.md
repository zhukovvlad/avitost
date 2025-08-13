# AviTost - Монорепозиторий

[![GitHub](https://img.shields.io/badge/GitHub-zhukovvlad%2Favitost-blue?logo=github)](https://github.com/zhukovvlad/avitost)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Полнофункциональная микросервисная платформа для работы с объявлениями и биллингом.

## 🏗 Архитектура

- � **Python Backend** (FastAPI) - OAuth авторизация через Yandex
- 🏃 **Go Backend** (Gin) - Avito API, система биллинга, высокая производительность
- ⚛️ **Frontend** (React + Vite) - Современный пользовательский интерфейс
- 🤖 **Telegram Bot** (aiogram) - Бот для загрузки фото в Яндекс.Диск
- 🗄️ **PostgreSQL** - Основная база данных

## 🚀 Быстрый старт

### 1. Клонирование и настройка

```bash
git clone https://github.com/zhukovvlad/avitost.git
cd avitost
```

### 2. Настройка переменных окружения

Скопируйте `.env.example` в `.env` и заполните необходимые токены:

```bash
cp .env.example .env
nano .env  # Заполните токены
```

### 3. Установка зависимостей

```bash
make install
```

### 4. Запуск всех сервисов

```bash
make dev
```

Сервисы будут доступны по адресам:

- **Python Backend**: http://localhost:8000
- **Go Backend**: http://localhost:8001
- **Frontend**: http://localhost:5173
- **API Docs**: http://localhost:8000/docs

## 🌐 API Endpoints

### Python Backend (8000):

- `GET /api/health` - Health check
- `GET /api/login` - OAuth Yandex
- `GET /docs` - Swagger документация

### Go Backend (8001):

- `GET /health` - Health check
- `GET /api/v1/status` - Статус сервисов
- `GET /api/v1/avito/categories` - Категории Avito
- `GET /api/v1/avito/search?query=...` - Поиск объявлений
- `GET /api/v1/billing/users/:id/balance` - Баланс пользователя
- `POST /api/v1/billing/users/:id/payments` - Создать платеж

## 🛠 Доступные команды

```bash
make help              # Показать все доступные команды
make install           # Установить все зависимости
make dev              # Запустить все сервисы
make backend-dev      # Запустить Python backend
make backend-go-dev   # Запустить Go backend
make frontend-dev     # Запустить frontend
make bot-dev          # Запустить telegram bot
make stop             # Остановить все сервисы
make clean            # Очистить кеши
```

## 📁 Структура проекта

```
avitost/
├── apps/
│   ├── backend/           # FastAPI приложение (Python)
│   │   ├── app/
│   │   │   └── main.py   # OAuth, интеграции
│   │   ├── requirements.txt
│   │   └── .venv/        # Виртуальное окружение
│   ├── backend-go/       # Gin приложение (Go)
│   │   ├── internal/     # Бизнес-логика
│   │   │   ├── avito/    # Avito API клиент
│   │   │   ├── billing/  # Система биллинга
│   │   │   ├── config/   # Конфигурация
│   │   │   └── http/     # HTTP обработчики
│   │   ├── go.mod
│   │   └── main.go       # Точка входа
│   ├── frontend/         # React приложение
│   │   ├── src/
│   │   ├── package.json
│   │   └── node_modules/
│   └── tg-bot/          # Telegram бот
│       ├── app/
│       │   └── main.py  # Основной файл бота
│       ├── requirements.txt
│       └── .venv/       # Виртуальное окружение
├── infra/               # Docker, Caddy конфиги
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
# Python Backend
YANDEX_CLIENT_ID=ваш_yandex_client_id
YANDEX_CLIENT_SECRET=ваш_yandex_client_secret
OAUTH_REDIRECT_URI=http://localhost:8000/oauth/callback
OAUTH_SCOPE=login:info

# Go Backend
AVITO_API_URL=https://api.avito.ru
DATABASE_URL=postgres://user:password@localhost:5432/avitost

# Telegram Bot
TG_BOT_TOKEN=ваш_telegram_bot_token
YANDEX_TOKEN=ваш_yandex_oauth_token

# Frontend
VITE_API_BASE=http://localhost:8000/api
VITE_GO_API_BASE=http://localhost:8001/api/v1
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
# Python backend
curl http://localhost:8000/api/health

# Go backend
curl http://localhost:8001/health
curl http://localhost:8001/api/v1/avito/categories
curl "http://localhost:8001/api/v1/avito/search?query=iPhone"
```
