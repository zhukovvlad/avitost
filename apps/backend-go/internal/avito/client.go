package avito

import (
	"fmt"
	"net/http"
)

type Client struct {
	apiKey     string
	baseURL    string
	userAgent  string
	httpClient *http.Client
}

type ListingResponse struct {
	Status string    `json:"status"`
	Result []Listing `json:"result"`
}

type Listing struct {
	ID          int64    `json:"id"`
	Title       string   `json:"title"`
	Price       int64    `json:"price"`
	Currency    string   `json:"currency"`
	Category    string   `json:"category"`
	Location    string   `json:"location"`
	Description string   `json:"description"`
	Images      []string `json:"images"`
	URL         string   `json:"url"`
	Date        string   `json:"date"`
}

func NewClient(apiKey, baseURL, userAgent string) *Client {
	return &Client{
		apiKey:     apiKey,
		baseURL:    baseURL,
		userAgent:  userAgent,
		httpClient: &http.Client{},
	}
}

func (c *Client) SearchListings(query string, limit int) ([]Listing, error) {
	// TODO: Реализовать поиск объявлений через Avito API
	// Пока возвращаем моковые данные
	mockListings := []Listing{
		{
			ID:          12345,
			Title:       "Тестовое объявление",
			Price:       50000,
			Currency:    "RUB",
			Category:    "Автомобили",
			Location:    "Москва",
			Description: "Тестовое описание",
			Images:      []string{"https://example.com/image1.jpg"},
			URL:         "https://avito.ru/moskva/avtomobili/test-12345",
			Date:        "2025-08-13",
		},
	}

	return mockListings, nil
}

func (c *Client) GetListing(id int64) (*Listing, error) {
	// TODO: Реализовать получение конкретного объявления
	return nil, fmt.Errorf("не реализовано")
}

func (c *Client) GetCategories() ([]string, error) {
	// TODO: Реализовать получение списка категорий
	categories := []string{
		"Автомобили",
		"Недвижимость",
		"Работа",
		"Услуги",
		"Личные вещи",
		"Для дома и дачи",
		"Бытовая электроника",
	}

	return categories, nil
}
