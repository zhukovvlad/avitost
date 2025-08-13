#!/bin/bash

echo "🧪 Тестируем все сервисы..."
echo

# Тест Python Backend API
echo "🔥 Тестируем Python Backend API..."
response=$(curl -s -w "%{http_code}" http://localhost:8000/api/health)
http_code="${response: -3}"
if [ "$http_code" = "200" ]; then
    echo "  ✅ Python Backend API работает (http://localhost:8000)"
    echo "  📄 Swagger UI: http://localhost:8000/docs"
else
    echo "  ❌ Python Backend API недоступен"
fi

echo

# Тест Go Backend API  
echo "🏃 Тестируем Go Backend API..."
response=$(curl -s -w "%{http_code}" http://localhost:8001/health)
http_code="${response: -3}"
if [ "$http_code" = "200" ]; then
    echo "  ✅ Go Backend API работает (http://localhost:8001)"
    echo "  🏪 Avito API: http://localhost:8001/api/v1/avito/categories"
    echo "  💳 Billing API: http://localhost:8001/api/v1/billing/users/1/balance"
else
    echo "  ❌ Go Backend API недоступен"
fi

echo

# Тест Frontend
echo "⚛️ Тестируем Frontend..."
response=$(curl -s -w "%{http_code}" http://localhost:5173)
http_code="${response: -3}"
if [ "$http_code" = "200" ]; then
    echo "  ✅ Frontend работает (http://localhost:5173)"
else
    echo "  ❌ Frontend недоступен"
fi

echo

# Проверка процессов
echo "🔍 Проверяем запущенные процессы..."
if pgrep -f "uvicorn app.main:app" > /dev/null; then
    echo "  ✅ Python Backend процесс запущен"
else
    echo "  ❌ Python Backend процесс не найден"
fi

if pgrep -f "go run cmd/api/main.go" > /dev/null; then
    echo "  ✅ Go Backend процесс запущен"
else
    echo "  ❌ Go Backend процесс не найден"
fi

if pgrep -f "vite" > /dev/null; then
    echo "  ✅ Frontend процесс запущен"
else
    echo "  ❌ Frontend процесс не найден"
fi

if pgrep -f "python app/main.py" > /dev/null; then
    echo "  ✅ Telegram Bot процесс запущен"
else
    echo "  ⚠️  Telegram Bot процесс не запущен (нормально, если не настроены токены)"
fi

echo
echo "🎉 Проверка завершена!"
echo "📚 Для просмотра логов Go backend: tail -f apps/backend-go/backend-go.log"
