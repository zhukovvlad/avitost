# AviTost - Монорепозиторий

Проект включает в себя:

- 🚀 **Backend** (FastAPI) - API сервер для OAuth авторизации через Yandex
- ⚛️ **Frontend** (React + Vite) - Пользовательский интерфейс
- 🤖 **Telegram Bot** (aiogram) - Бот для загрузки фото в Яндекс.Диск

## 🚀 Быстрый старт

### 1. Клонирование и настройка

```bash
git clone <your-repo>
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

- **Backend API**: http://localhost:8000
- **Frontend**: http://localhost:5173
- **API Docs**: http://localhost:8000/docs

## 🛠 Доступные команды

```bash
make help          # Показать все доступные команды
make install        # Установить зависимости
make dev           # Запустить все сервисы
make backend-dev   # Запустить только backend
make frontend-dev  # Запустить только frontend
make bot-dev       # Запустить только telegram bot
make stop          # Остановить все сервисы
make clean         # Очистить кеши
```

## 📁 Структура проекта

```
avitost/
├── apps/
│   ├── backend/           # FastAPI приложение
│   │   ├── app/
│   │   │   └── main.py   # Основной файл API
│   │   ├── requirements.txt
│   │   └── .venv/        # Виртуальное окружение
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

### Backend

```bash
cd apps/backend
source .venv/bin/activate
uvicorn app.main:app --reload --port 8000
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
# Backend
YANDEX_CLIENT_ID=ваш_yandex_client_id
YANDEX_CLIENT_SECRET=ваш_yandex_client_secret
OAUTH_REDIRECT_URI=http://localhost:8000/oauth/callback
OAUTH_SCOPE=login:info

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

После запуска backend'а, документация доступна по адресу:

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
