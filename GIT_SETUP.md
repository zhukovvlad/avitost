# 🔧 Git настроен для AviTost монорепозитория!

## ✅ Что настроено:

### 🛠 Git конфигурация

- **Пользователь**: Zhukovvlad
- **Email**: (пустой)
- **Основная ветка**: main
- **Редактор**: VS Code
- **Merge/Diff tool**: VS Code

### 📝 Шаблон коммитов

Настроен шаблон для [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Типы коммитов:**

- `feat`: новая функциональность
- `fix`: исправление ошибки
- `docs`: изменения в документации
- `style`: форматирование кода
- `refactor`: рефакторинг
- `perf`: оптимизация производительности
- `test`: тесты
- `chore`: обслуживание

**Области (scope):**

- `backend`: изменения в FastAPI
- `frontend`: изменения в React
- `bot`: изменения в Telegram боте
- `docs`: документация
- `config`: конфигурация

### 🎣 Git хуки

- **pre-commit**: автоматические проверки перед коммитом
  - Проверка синтаксиса Python
  - Запуск ESLint для TypeScript
  - Проверка размера файлов
  - Блокировка запрещенных файлов

### 🚀 Полезные алиасы

```bash
# Основные команды
git st          # git status
git co          # git checkout
git br          # git branch
git ci          # git commit

# Логи и история
git lg          # красивый лог с графом
git lol         # лог одной строкой
git last        # последний коммит
git changes     # изменения с именами файлов

# Работа с изменениями
git unstage     # убрать из stage
git undo        # отменить последний коммит (soft)
git amend       # изменить последний коммит

# Информация
git s           # короткий статус
git branches    # все ветки
git remotes     # все удаленные репозитории
```

## 🔄 Рабочий процесс:

### 1. Создание новой ветки

```bash
git co -b feature/новая-функция
```

### 2. Внесение изменений

```bash
git add .
git ci  # откроется шаблон коммита
```

### 3. Отправка изменений

```bash
git push origin feature/новая-функция
```

### 4. Слияние в main

```bash
git co main
git merge feature/новая-функция
git push origin main
```

## 📋 Примеры коммитов:

```bash
# Новая функция
git commit -m "feat(backend): add user authentication endpoint"

# Исправление ошибки
git commit -m "fix(frontend): resolve CORS issue with API calls"

# Документация
git commit -m "docs: update README with installation instructions"

# Рефакторинг
git commit -m "refactor(bot): improve error handling in photo upload"
```

## 🛡 Автоматические проверки:

При каждом коммите автоматически запускаются:

- ✅ Проверка синтаксиса Python файлов
- ✅ ESLint для TypeScript/JavaScript
- ✅ Проверка размера файлов (макс 5MB)
- ✅ Блокировка .env и других приватных файлов

## 🔧 Настройка удаленного репозитория:

```bash
# Добавление GitHub/GitLab репозитория
git remote add origin https://github.com/username/avitost.git
git push -u origin main

# Клонирование для других разработчиков
git clone https://github.com/username/avitost.git
cd avitost
make install  # установка зависимостей
```

Git готов к продуктивной работе! 🎉
