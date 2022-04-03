package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
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

	token, firebase_token, err := models.LoginCheck(u.Email, u.Password)

	if token == "Email not registered" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email not registered"})
		return
	}

	if err != nil {
		c.JSON(http.StatusBadRequest,
			gin.H{"error": "Incorrect email address and password combination"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token, "firebase_token": firebase_token})
}

type RegisterInput struct {
	FirstName   string `json:"first_name" binding:"required"`
	LastName    string `json:"last_name" binding:"required"`
	Email       string `json:"email" binding:"required,email" validate:"email"`
	Password    string `json:"password" binding:"required,max=50,min=8" validate:"max=50,min=6"`
	DOB         string `json:"dob" binding:"required"`
	Gender      string `json:"gender" binding:"required" validate:"oneof=female male other"`
	PhoneNumber string `json:"phone_number" binding:"required"`
}

func Register(c *gin.Context) {

	validate := validator.New()

	var input RegisterInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	validation_err := validate.Struct(input)
	if validation_err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": validation_err.Error()})
		return
	}

	u := models.User{}
	u.FirstName = input.FirstName
	u.LastName = input.LastName
	u.Email = input.Email
	u.Password = input.Password
	u.DOB = input.DOB
	u.Gender = input.Gender
	u.PhoneNumber = input.PhoneNumber

	_, err := u.SaveUser()

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Registered successfully!"})
}

type EditProfileInput struct {
	FirstName     string `json:"first_name"`
	LastName      string `json:"last_name"`
	Email         string `json:"email"`
	Password      string `json:"password"`
	AboutMe       string `json:"about_me"`
	AvatarURL     string `json:"avatar_url"`
	FirebaseToken string `json:"firebase_token"`
}

func EditProfile(c *gin.Context) {

	var input EditProfileInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user_id, err := token.ExtractTokenID(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	u := models.User{}

	u.FirstName = input.FirstName
	u.LastName = input.LastName
	u.Email = input.Email
	u.Password = input.Password
	u.AvatarURL = input.AvatarURL
	u.AboutMe = input.AboutMe
	u.FirebaseToken = input.FirebaseToken

	if _, err := u.UpdateUser(user_id); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Profile updated!"})
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
