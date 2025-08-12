#!/bin/bash

echo "🔍 Проверка конфигурации монорепозитория AviTost..."
echo

# Проверка Python виртуальных окружений
echo "📦 Проверка Python окружений:"
for app in backend tg-bot; do
    if [ -d "apps/$app/.venv" ]; then
        echo "  ✅ apps/$app/.venv - существует"
        cd "apps/$app"
        if source .venv/bin/activate 2>/dev/null; then
            python_version=$(python --version 2>&1)
            echo "     Python: $python_version"
            pip_packages=$(pip list --format=freeze | wc -l)
            echo "     Пакетов установлено: $pip_packages"
        fi
        cd - > /dev/null
    else
        echo "  ❌ apps/$app/.venv - отсутствует"
    fi
done

echo

# Проверка Node.js зависимостей
echo "📦 Проверка Node.js зависимостей:"
if [ -d "apps/frontend/node_modules" ]; then
    echo "  ✅ apps/frontend/node_modules - существует"
    cd apps/frontend
    if command -v pnpm &> /dev/null; then
        echo "     pnpm: $(pnpm --version)"
    else
        echo "     ❌ pnpm не установлен"
    fi
    cd - > /dev/null
else
    echo "  ❌ apps/frontend/node_modules - отсутствует"
fi

echo

# Проверка конфигурационных файлов
echo "📄 Проверка конфигурационных файлов:"
files=(".env" "Makefile" "README.md" "apps/frontend/.env")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file - существует"
    else
        echo "  ❌ $file - отсутствует"
    fi
done

echo

# Проверка портов
echo "🌐 Проверка портов:"
for port in 8000 5173; do
    if lsof -i :$port > /dev/null 2>&1; then
        echo "  ⚠️  Порт $port занят"
    else
        echo "  ✅ Порт $port свободен"
    fi
done

echo
echo "🚀 Для запуска всех сервисов выполните: make dev"
echo "📚 Для просмотра всех команд: make help"
