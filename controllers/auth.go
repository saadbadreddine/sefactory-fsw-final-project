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

type RegisterInput struct {
	FirstName string `json:"first_name" binding:"required"`
	LastName  string `json:"last_name" binding:"required"`
	Email     string `json:"email" binding:"required,email"`
	Password  string `json:"password" binding:"required,max=16,min=6"`
	Age       uint8  `json:"age"`
	Gender    string `json:"gender" validate:"oneof=female male"`
}

func Register(c *gin.Context) {

	var input RegisterInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	u := models.User{}
	u.FirstName = input.FirstName
	u.LastName = input.LastName
	u.Email = input.Email
	u.Password = input.Password

	_, err := u.SaveUser()

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Registered successfully!"})
}

func CurrentUser(c *gin.Context) {

	user_id, err := token.ExtractTokenID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	u, err := models.GetUserByID(user_id)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Success", "data": u})
}

func Refresh(c *gin.Context) {

	user_id, err := token.ExtractTokenID(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user_type, err := token.ExtractTokenUserType(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, err := token.GenerateToken(uint(user_id), uint(user_type))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}
