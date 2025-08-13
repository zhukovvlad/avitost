FROM golang:1.23-alpine AS builder

WORKDIR /app

# Установка зависимостей для сборки
RUN apk add --no-cache git

# Копирование go.mod и go.sum
COPY go.mod go.sum ./
RUN go mod download

# Копирование исходного кода
COPY . .

# Сборка приложения
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./cmd/api

# Финальный образ
FROM alpine:latest

WORKDIR /root/

# Установка curl для healthcheck
RUN apk --no-cache add curl

# Копирование бинарника
COPY --from=builder /app/main .

# Создание пользователя для безопасности
RUN adduser -D -s /bin/sh appuser
USER appuser

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8001/health || exit 1

EXPOSE 8001

CMD ["./main"]
