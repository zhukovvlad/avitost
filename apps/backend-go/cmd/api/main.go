package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/zhukovvlad/avitost/apps/backend-go/internal/avito"
	"github.com/zhukovvlad/avitost/apps/backend-go/internal/billing"
	"github.com/zhukovvlad/avitost/apps/backend-go/internal/config"
	httpHandlers "github.com/zhukovvlad/avitost/apps/backend-go/internal/http"
)

func main() {
	// Загружаем переменные окружения
	if err := godotenv.Load("../../.env"); err != nil {
		log.Println("Warning: .env file not found")
	}

	// Загружаем конфигурацию
	cfg := config.Load()

	// Настраиваем режим работы
	gin.SetMode(cfg.Server.Mode)

	// Инициализируем сервисы
	avitoClient := avito.NewClient(cfg.Avito.APIKey, cfg.Avito.BaseURL, cfg.Avito.UserAgent)
	billingService := billing.NewService()
	handlers := httpHandlers.NewHandler(avitoClient, billingService)

	// Создаем роутер
	r := gin.Default()

	// Настраиваем CORS
	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(http.StatusNoContent)
			return
		}

		c.Next()
	})

	// Базовые роуты
	r.GET("/health", healthCheck)
	r.GET("/api/health", healthCheck)

	// API группа v1
	v1 := r.Group("/api/v1")
	{
		v1.GET("/status", getStatus)

		// Avito API
		avito := v1.Group("/avito")
		{
			avito.GET("/search", handlers.SearchListings)
			avito.GET("/categories", handlers.GetCategories)
		}

		// Billing API
		billing := v1.Group("/billing")
		{
			billing.GET("/users/:userId/balance", handlers.GetBalance)
			billing.GET("/users/:userId/transactions", handlers.GetTransactions)
			billing.POST("/users/:userId/payments", handlers.CreatePayment)
		}
	}

	// Запускаем сервер
	log.Printf("🚀 Go Backend запущен на порту %s", cfg.Server.Port)
	log.Printf("📄 Health check: http://localhost:%s/health", cfg.Server.Port)
	log.Printf("🔗 API: http://localhost:%s/api/v1/status", cfg.Server.Port)
	log.Printf("🏪 Avito API: http://localhost:%s/api/v1/avito/categories", cfg.Server.Port)
	log.Printf("💳 Billing API: http://localhost:%s/api/v1/billing/users/1/balance", cfg.Server.Port)

	if err := r.Run(":" + cfg.Server.Port); err != nil {
		log.Fatal("Ошибка запуска сервера:", err)
	}
}

func healthCheck(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status":  "ok",
		"service": "avitost-go-backend",
		"version": "1.0.0",
	})
}

func getStatus(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"backend":  "go",
		"services": []string{"avito", "billing", "jobs"},
		"database": "postgresql",
		"status":   "ready",
	})
}
