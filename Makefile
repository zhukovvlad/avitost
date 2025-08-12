.PHONY: help install dev stop clean backend-dev frontend-dev bot-dev

# Показать справку
help:
	@echo "Доступные команды:"
	@echo "  install      - Установить все зависимости"
	@echo "  dev          - Запустить все сервисы для разработки"
	@echo "  backend-dev  - Запустить только backend"
	@echo "  frontend-dev - Запустить только frontend"
	@echo "  bot-dev      - Запустить только telegram bot"
	@echo "  stop         - Остановить все сервисы"
	@echo "  clean        - Очистить кеши и временные файлы"

# Установить все зависимости
install:
	@echo "🔧 Устанавливаем зависимости..."
	cd apps/backend && python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
	cd apps/tg-bot && python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
	cd apps/frontend && pnpm install
	@echo "✅ Все зависимости установлены!"

# Запустить все сервисы
dev:
	@echo "🚀 Запускаем все сервисы..."
	@echo "Backend будет доступен на http://localhost:8000"
	@echo "Frontend будет доступен на http://localhost:5173"
	@echo "Нажмите Ctrl+C для остановки всех сервисов"
	make -j3 backend-dev frontend-dev bot-dev

# Запустить только backend
backend-dev:
	@echo "🔥 Запускаем Backend..."
	cd apps/backend && source .venv/bin/activate && uvicorn app.main:app --reload --port 8000

# Запустить только frontend
frontend-dev:
	@echo "⚛️  Запускаем Frontend..."
	cd apps/frontend && pnpm dev

# Запустить только telegram bot
bot-dev:
	@echo "🤖 Запускаем Telegram Bot..."
	cd apps/tg-bot && source .venv/bin/activate && python app/main.py

# Остановить все сервисы
stop:
	@echo "🛑 Останавливаем сервисы..."
	pkill -f "uvicorn app.main:app"
	pkill -f "vite"
	pkill -f "python app/main.py"

# Очистить кеши
clean:
	@echo "🧹 Очищаем кеши..."
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "node_modules/.vite" -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Кеши очищены!"
