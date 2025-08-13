# Frontend для AviTost

## 🚀 Описание

React frontend приложение с современным стеком технологий:

- **React 18** - UI библиотека
- **TypeScript** - Типизированный JavaScript
- **Vite** - Сборщик и dev сервер
- **Tailwind CSS** - Utility-first CSS фреймворк
- **Shadcn/ui** - Компоненты UI

## 🏗 Архитектура

```
apps/frontend/
├── src/
│   ├── components/      # React компоненты
│   │   └── ui/         # Переиспользуемые UI компоненты
│   ├── lib/            # Утилиты и хелперы
│   ├── assets/         # Статические файлы
│   ├── App.tsx         # Основной компонент
│   ├── main.tsx        # Точка входа
│   └── index.css       # Стили
├── public/             # Публичные файлы
├── package.json        # Node.js зависимости
└── vite.config.ts      # Конфигурация Vite
```

## 🛠 Установка и запуск

### Требования

- Node.js 18+
- pnpm (или npm/yarn)

### Быстрый старт

```bash
# Установка зависимостей
cd apps/frontend
pnpm install

# Запуск dev сервера
pnpm dev

# Или из корня проекта
make frontend-dev
```

Приложение будет доступно на `http://localhost:5173`

## 🌐 Переменные окружения

Создайте файл `.env.local`:

```bash
# API endpoints
VITE_API_BASE=http://localhost:8000/api
VITE_GO_API_BASE=http://localhost:8001/api/v1

# Режим разработки
VITE_NODE_ENV=development
```

## 🔧 Разработка

### Структура компонентов

```
src/components/
├── ui/                 # Базовые UI компоненты (Button, Input, etc.)
└── feature/           # Компоненты фич (планируется)
```

### Добавление нового компонента

```bash
# Используя shadcn/ui CLI
npx shadcn-ui@latest add [component-name]
```

### Стилизация

Проект использует Tailwind CSS. Основные классы:

- `bg-primary` - основной цвет фона
- `text-primary` - основной цвет текста
- `border-primary` - основной цвет границ

## 📦 Сборка

```bash
# Production сборка
pnpm build

# Предпросмотр сборки
pnpm preview
```

## 🧪 Тестирование

```bash
# Линтер
pnpm lint

# Проверка типов
pnpm type-check
```

## 🔗 Интеграция с Backend

Frontend интегрируется с двумя backend сервисами:

### Python Backend (8000)

- OAuth авторизация
- Пользовательские данные

### Go Backend (8001)

- Avito API
- Система биллинга
- Высокопроизводительные операции

## 📚 Полезные ссылки

- [React Documentation](https://react.dev/)
- [Vite Documentation](https://vitejs.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Shadcn/ui](https://ui.shadcn.com/)
