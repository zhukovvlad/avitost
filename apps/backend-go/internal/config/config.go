package config

import (
	"os"
	"strconv"
)

type Config struct {
	Server   ServerConfig
	Database DatabaseConfig
	Avito    AvitoConfig
	Yandex   YandexConfig
}

type ServerConfig struct {
	Port string
	Host string
	Mode string
}

type DatabaseConfig struct {
	Host     string
	Port     int
	User     string
	Password string
	DBName   string
	SSLMode  string
}

type AvitoConfig struct {
	APIKey    string
	BaseURL   string
	UserAgent string
}

type YandexConfig struct {
	ClientID     string
	ClientSecret string
	RedirectURI  string
	Token        string
}

func Load() *Config {
	return &Config{
		Server: ServerConfig{
			Port: getEnv("GO_PORT", "8001"),
			Host: getEnv("GO_HOST", "localhost"),
			Mode: getEnv("GIN_MODE", "debug"),
		},
		Database: DatabaseConfig{
			Host:     getEnv("DB_HOST", "localhost"),
			Port:     getEnvAsInt("DB_PORT", 5432),
			User:     getEnv("DB_USER", "postgres"),
			Password: getEnv("DB_PASSWORD", ""),
			DBName:   getEnv("DB_NAME", "avitost"),
			SSLMode:  getEnv("DB_SSLMODE", "disable"),
		},
		Avito: AvitoConfig{
			APIKey:    getEnv("AVITO_API_KEY", ""),
			BaseURL:   getEnv("AVITO_BASE_URL", "https://api.avito.ru"),
			UserAgent: getEnv("AVITO_USER_AGENT", "AviTost/1.0"),
		},
		Yandex: YandexConfig{
			ClientID:     getEnv("YANDEX_CLIENT_ID", ""),
			ClientSecret: getEnv("YANDEX_CLIENT_SECRET", ""),
			RedirectURI:  getEnv("OAUTH_REDIRECT_URI", ""),
			Token:        getEnv("YANDEX_TOKEN", ""),
		},
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func getEnvAsInt(key string, defaultValue int) int {
	if value := os.Getenv(key); value != "" {
		if intValue, err := strconv.Atoi(value); err == nil {
			return intValue
		}
	}
	return defaultValue
}
