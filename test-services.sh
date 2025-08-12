#!/bin/bash

echo "🧪 Тестируем все сервисы..."
echo

# Тест Backend API
echo "🔥 Тестируем Backend API..."
response=$(curl -s -w "%{http_code}" http://localhost:8000/api/health)
http_code="${response: -3}"
if [ "$http_code" = "200" ]; then
    echo "  ✅ Backend API работает (http://localhost:8000)"
    echo "  📄 Swagger UI: http://localhost:8000/docs"
else
    echo "  ❌ Backend API недоступен"
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
    echo "  ✅ Backend процесс запущен"
else
    echo "  ❌ Backend процесс не найден"
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
echo "📚 Для просмотра логов используйте: docker logs <container> или просто смотрите терминалы"
