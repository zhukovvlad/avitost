package billing

import (
	"time"
)

type Service struct {
	// TODO: добавить подключение к базе данных
}

type Transaction struct {
	ID          int64     `json:"id"`
	UserID      int64     `json:"user_id"`
	Amount      int64     `json:"amount"` // в копейках
	Currency    string    `json:"currency"`
	Type        string    `json:"type"`   // "payment", "refund", "fee"
	Status      string    `json:"status"` // "pending", "completed", "failed"
	Description string    `json:"description"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type Balance struct {
	UserID    int64     `json:"user_id"`
	Amount    int64     `json:"amount"`
	Currency  string    `json:"currency"`
	UpdatedAt time.Time `json:"updated_at"`
}

func NewService() *Service {
	return &Service{}
}

func (s *Service) GetBalance(userID int64) (*Balance, error) {
	// TODO: получение баланса из базы данных
	return &Balance{
		UserID:    userID,
		Amount:    0,
		Currency:  "RUB",
		UpdatedAt: time.Now(),
	}, nil
}

func (s *Service) CreateTransaction(userID int64, amount int64, transactionType, description string) (*Transaction, error) {
	// TODO: создание транзакции в базе данных
	transaction := &Transaction{
		ID:          time.Now().Unix(), // временно используем timestamp как ID
		UserID:      userID,
		Amount:      amount,
		Currency:    "RUB",
		Type:        transactionType,
		Status:      "pending",
		Description: description,
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
	}

	return transaction, nil
}

func (s *Service) GetTransactions(userID int64, limit, offset int) ([]Transaction, error) {
	// TODO: получение списка транзакций из базы данных
	return []Transaction{}, nil
}

func (s *Service) ProcessPayment(userID int64, amount int64, description string) (*Transaction, error) {
	// TODO: обработка платежа
	return s.CreateTransaction(userID, amount, "payment", description)
}
