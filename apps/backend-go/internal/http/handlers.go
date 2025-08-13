package http

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/zhukovvlad/avitost/apps/backend-go/internal/avito"
	"github.com/zhukovvlad/avitost/apps/backend-go/internal/billing"
)

type Handler struct {
	avitoClient    *avito.Client
	billingService *billing.Service
}

func NewHandler(avitoClient *avito.Client, billingService *billing.Service) *Handler {
	return &Handler{
		avitoClient:    avitoClient,
		billingService: billingService,
	}
}

// Avito endpoints
func (h *Handler) SearchListings(c *gin.Context) {
	query := c.Query("q")
	limitStr := c.DefaultQuery("limit", "10")

	limit, err := strconv.Atoi(limitStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid limit parameter"})
		return
	}

	listings, err := h.avitoClient.SearchListings(query, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"query":    query,
		"limit":    limit,
		"results":  len(listings),
		"listings": listings,
	})
}

func (h *Handler) GetCategories(c *gin.Context) {
	categories, err := h.avitoClient.GetCategories()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"categories": categories,
	})
}

// Billing endpoints
func (h *Handler) GetBalance(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	balance, err := h.billingService.GetBalance(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, balance)
}

func (h *Handler) GetTransactions(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	limitStr := c.DefaultQuery("limit", "50")
	offsetStr := c.DefaultQuery("offset", "0")

	limit, _ := strconv.Atoi(limitStr)
	offset, _ := strconv.Atoi(offsetStr)

	transactions, err := h.billingService.GetTransactions(userID, limit, offset)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"user_id":      userID,
		"limit":        limit,
		"offset":       offset,
		"transactions": transactions,
	})
}

func (h *Handler) CreatePayment(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	var req struct {
		Amount      int64  `json:"amount" binding:"required"`
		Description string `json:"description"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	transaction, err := h.billingService.ProcessPayment(userID, req.Amount, req.Description)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, transaction)
}
