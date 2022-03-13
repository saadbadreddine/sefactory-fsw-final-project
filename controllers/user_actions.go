package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/saadbadreddine/fsw-final-project-backend/models"
	"github.com/saadbadreddine/fsw-final-project-backend/utils/token"
)

type PostInput struct {
	SportID   uint   `json:"sport_id" binding:"required"`
	Time      string `json:"time" binding:"required"`
	Message   string `json:"message" binding:"required"`
	Latitude  string `json:"latitude" binding:"required"`
	Longitude string `json:"longitude" binding:"required"`
}

func Post(c *gin.Context) {

	var input PostInput

	user_id, err := token.ExtractTokenID(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	p := models.Post{}
	p.UserID = user_id
	p.SportID = input.SportID
	p.Message = input.Message
	p.Time = input.Time
	p.Latitude = input.Latitude
	p.Longitude = input.Longitude

	if _, err := p.SavePost(); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Posted successfully!"})
}
