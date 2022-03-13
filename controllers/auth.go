package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/saadbadreddine/fsw-final-project-backend/models"
	"github.com/saadbadreddine/fsw-final-project-backend/utils/token"
)

type LoginCredentials struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

func Login(c *gin.Context) {

	var creds LoginCredentials

	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	u := models.User{}

	u.Email = creds.Email
	u.Password = creds.Password

	token, err := models.LoginCheck(u.Email, u.Password)

	if token == "Email not registered" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email not registered"})
		return
	}

	if err != nil {
		c.JSON(http.StatusBadRequest,
			gin.H{"error": "Incorrect email address and password combination"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}
