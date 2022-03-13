package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/saadbadreddine/fsw-final-project-backend/models"
)

func CreateSportCategory(c *gin.Context) {

	var input models.SportCategory

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	s := models.SportCategory{}
	s.Sport = input.Sport

	if _, err := s.SaveSport(); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK,
		gin.H{"message": "Noice you did it! Nuevo Sport Category Created!!"})
}
