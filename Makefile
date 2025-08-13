.PHONY: help install dev stop clean backend-dev backend-go-dev frontend-dev bot-dev docker-up docker-down docker-infra docker-logs dev-hybrid

# Показать справку
help:
	@echo "Доступные команды:"
	@echo ""
	@echo "📦 Установка:"
	@echo "  install        - Установить все зависимости"
	@echo ""
	@echo "🚀 Локальная разработка:"
	@echo "  dev            - Запустить все сервисы локально"
	@echo "  backend-dev    - Запустить только Python backend"
	@echo "  backend-go-dev - Запустить только Go backend"
	@echo "  frontend-dev   - Запустить только frontend"
	@echo "  bot-dev        - Запустить только telegram bot"
	@echo ""
	@echo "🐳 Docker команды:"
	@echo "  docker-up      - Запустить все сервисы в Docker"
	@echo "  docker-down    - Остановить все Docker сервисы"
	@echo "  docker-infra   - Запустить только инфраструктуру (БД, Redis, MinIO)"
	@echo "  docker-logs    - Показать логи Docker сервисов"
	@echo ""
	@echo "🔀 Hybrid режим (рекомендуется):"
	@echo "  dev-hybrid     - Инфраструктура в Docker + приложения локально"
	@echo ""
	@echo "🛠️ Утилиты:"
	@echo "  stop           - Остановить все локальные сервисы"
	@echo "  clean          - Очистить кеши и временные файлы"

# Установить все зависимости
install:
	@echo "🔧 Устанавливаем зависимости..."
	cd apps/backend && python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
	cd apps/tg-bot && python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
	cd apps/frontend && pnpm install
	cd apps/backend-go && go mod tidy
	@echo "✅ Все зависимости установлены!"

# Запустить все сервисы
dev:
	@echo "🚀 Запускаем все сервисы..."
	@echo "Python Backend будет доступен на http://localhost:8000"
	@echo "Go Backend будет доступен на http://localhost:8001"
	@echo "Frontend будет доступен на http://localhost:5173"
	@echo "Нажмите Ctrl+C для остановки всех сервисов"
	make -j4 backend-dev backend-go-dev frontend-dev bot-dev

# Запустить только Python backend
backend-dev:
	@echo "🔥 Запускаем Python Backend..."
	cd apps/backend && source .venv/bin/activate && uvicorn app.main:app --reload --port 8000

# Запустить только Go backend
backend-go-dev:
	@echo "🚀 Запускаем Go Backend..."
	cd apps/backend-go && go run cmd/api/main.go

# Запустить Go backend в фоне  
backend-go-daemon:
	@echo "🚀 Запускаем Go Backend в фоне..."
	cd apps/backend-go && nohup go run cmd/api/main.go > backend-go.log 2>&1 &
	@echo "📄 Логи: tail -f apps/backend-go/backend-go.log"

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
	pkill -f "uvicorn app.main:app" || true
	pkill -f "go run cmd/api/main.go" || true
	pkill -f "vite" || true
	pkill -f "python app/main.py" || true

# Очистить кеши
clean:
	@echo "🧹 Очищаем кеши..."
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "node_modules/.vite" -exec rm -rf {} + 2>/dev/null || true
	cd apps/backend-go && go clean -cache 2>/dev/null || true
	@echo "✅ Кеши очищены!"

# Docker команды
.PHONY: docker-up docker-down docker-infra docker-logs dev-hybrid

# Запустить все сервисы в Docker
docker-up:
	@echo "🐳 Запускаем все сервисы в Docker..."
	cd infra/compose && docker-compose up -d
	@echo "✅ Все сервисы запущены!"
	@echo "FastAPI: http://localhost:8000"
	@echo "Go API: http://localhost:8080"
	@echo "MinIO Console: http://localhost:9001"

# Остановить все Docker сервисы
docker-down:
	@echo "🛑 Останавливаем Docker сервисы..."
	cd infra/compose && docker-compose down
	@echo "✅ Docker сервисы остановлены!"

# Запустить только инфраструктуру в Docker
docker-infra:
	@echo "🏗️ Запускаем инфраструктуру в Docker..."
	cd infra/compose && docker-compose up -d postgres redis minio
	@echo "✅ Инфраструктура запущена!"
	@echo "PostgreSQL: localhost:5432"
	@echo "Redis: localhost:6379"
	@echo "MinIO: http://localhost:9000"

# Показать логи Docker сервисов
docker-logs:
	cd infra/compose && docker-compose logs -f

# Hybrid режим: инфраструктура в Docker + приложения локально
dev-hybrid: docker-infra
	@echo "🔀 Запускаем приложения локально..."
	@sleep 3
	$(MAKE) dev
