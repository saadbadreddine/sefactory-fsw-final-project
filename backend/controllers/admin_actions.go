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

func CreateUserType(c *gin.Context) {

	var input models.UserType

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	ut := models.UserType{}
	ut.Role = input.Role

	if _, err := ut.SaveUserType(); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK,
		gin.H{"message": "Noice you did it! Nuevo User Type Created!!"})
}

func GetPost(c *gin.Context) {

	post := models.Post{}

	if err := c.ShouldBindJSON(&post); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	post, err := models.GetPostByID(post.ID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Success", "data": post})
}

func GetSportCategories(c *gin.Context) {

	sports, err := models.FindAllSports()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Success", "data": sports})
}
