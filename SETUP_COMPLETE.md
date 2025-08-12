# 🎉 Монорепозиторий AviTost настроен и работает!

## ✅ Что было настроено:

### 📁 Структура проекта

- Настроен VS Code workspace с удобной навигацией
- Созданы задачи для быстрого запуска сервисов
- Настроена отладка Python приложений

### 🚀 Backend (FastAPI)

- ✅ Виртуальное окружение: `apps/backend/.venv`
- ✅ Зависимости установлены
- ✅ CORS настроен для работы с frontend
- ✅ Запущен на: http://localhost:8000
- ✅ API документация: http://localhost:8000/docs

### ⚛️ Frontend (React + Vite)

- ✅ Node.js зависимости установлены (pnpm)
- ✅ Переменные окружения настроены
- ✅ Интеграция с backend API
- ✅ Запущен на: http://localhost:5173

### 🤖 Telegram Bot (aiogram)

- ✅ Виртуальное окружение: `apps/tg-bot/.venv`
- ✅ Зависимости установлены
- ⚠️ Требует настройки токенов в .env

### 🛠 Инструменты разработки

- ✅ Makefile с командами для управления
- ✅ Скрипты проверки конфигурации
- ✅ Скрипты тестирования сервисов
- ✅ .gitignore настроен
- ✅ Документация создана

## 🚀 Команды для работы:

```bash
# Показать все команды
make help

# Запустить все сервисы
make dev

# Запустить отдельные сервисы
make backend-dev   # Только backend
make frontend-dev  # Только frontend
make bot-dev       # Только telegram bot

# Остановить все сервисы
make stop

# Проверить конфигурацию
./check-setup.sh

# Тестировать сервисы
./test-services.sh
```

## 🔧 Настройка токенов:

Отредактируйте файл `.env` в корне проекта:

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

## 🌐 Доступные URL:

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/api/health

## 🎯 Следующие шаги:

1. **Заполните токены** в файле `.env`
2. **Запустите telegram bot**: `make bot-dev`
3. **Протестируйте OAuth** через frontend
4. **Настройте продакшен** через `infra/` папку

## 💡 Полезные советы:

- Используйте VS Code задачи (Ctrl+Shift+P → "Tasks: Run Task")
- Логи сервисов видны в терминалах VS Code
- Для отладки используйте конфигурации из `.vscode/launch.json`
- Frontend автоматически перезагружается при изменениях
- Backend автоматически перезагружается при изменениях

Монорепозиторий полностью настроен и готов к разработке! 🎉
