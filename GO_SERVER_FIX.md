# 🔧 Решение проблемы с остановкой Go сервера

## ❓ Проблема

При выполнении `curl` команд Go сервер автоматически останавливался с сигналом `interrupt`.

## 🔍 Причина

**VS Code терминал** завершает предыдущую команду (Go сервер) когда запускается новая команда в том же терминале. Это нормальное поведение - один терминал может выполнять только одну команду одновременно.

```bash
# Когда запускаем это:
go run cmd/api/main.go    # ← Запускается сервер

# А потом это в том же терминале:
curl http://localhost:8001/health  # ← Сервер автоматически останавливается
```

## ✅ Решения

### 1. Фоновый запуск с nohup

```bash
# Запуск в фоне с логированием
cd apps/backend-go
nohup go run cmd/api/main.go > backend-go.log 2>&1 &

# Проверка логов
tail -f backend-go.log
```

### 2. Новая команда Makefile

```bash
# Запуск в фоне через Makefile
make backend-go-daemon

# Обычный запуск (блокирует терминал)
make backend-go-dev
```

### 3. Отдельные терминалы

- Запустить сервер в одном терминале
- Тестировать API в другом терминале
- Использовать VS Code Tasks (Ctrl+Shift+P → "Tasks: Run Task")

## 🧪 Тестирование всех сервисов

```bash
# Запуск Go backend в фоне
make backend-go-daemon

# Тестирование API
curl http://localhost:8001/health
curl http://localhost:8001/api/v1/status
curl http://localhost:8001/api/v1/avito/categories

# Полный тест всех сервисов
./test-services.sh
```

## 🎯 Результат

```json
// ✅ Go Backend работает
{
  "service": "avitost-go-backend",
  "status": "ok",
  "version": "1.0.0"
}

// ✅ Avito API работает
{
  "categories": [
    "Автомобили",
    "Недвижимость",
    "Работа",
    "Услуги"
  ]
}

// ✅ Billing API работает
{
  "user_id": 123,
  "amount": 0,
  "currency": "RUB"
}
```

## 💡 Рекомендации

1. **Для разработки**: используйте `make backend-go-dev` в отдельном терминале
2. **Для тестирования**: используйте `make backend-go-daemon`
3. **Для продакшена**: используйте Docker или systemd сервисы
4. **Для отладки**: используйте VS Code debug конфигурацию

Проблема решена! Go backend теперь работает стабильно. 🎉
