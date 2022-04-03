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

	var pid uint

	_, pid, errr := p.SavePost()
	if errr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Posted successfully!", "data": pid})
}

type EditPostInput struct {
	ID        uint   `json:"id" binding:"required"`
	SportID   uint   `json:"sport_id"`
	Time      string `json:"time"`
	Message   string `json:"message"`
	Latitude  string `json:"latitude"`
	Longitude string `json:"longitude"`
}

func EditPost(c *gin.Context) {

	var input EditPostInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user_id, err := token.ExtractTokenID(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	p := models.Post{}
	p.ID = input.ID
	p.UserID = user_id
	p.SportID = input.SportID
	p.Message = input.Message
	p.Time = input.Time
	p.Latitude = input.Latitude
	p.Longitude = input.Longitude

	if _, err := p.UpdatePost(); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Post updated!"})
}

type DeletePostRequest struct {
	PostID uint `json:"post_id"`
}

func RemovePost(c *gin.Context) {

	var input DeletePostRequest

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user_id, err := token.ExtractTokenID(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := models.DeletePost(input.PostID, user_id); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Deleted!"})
}

func GetAllPosts(c *gin.Context) {

	posts, err := models.FindAllPosts()

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Success", "data": posts})
}

func GetMyPosts(c *gin.Context) {

	user_id, err := token.ExtractTokenID(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	posts, err := models.GetPostsByUserID(user_id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Success", "data": posts})
}

func FindUserByEmail(c *gin.Context) {

	var input FindByEmail

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	user := models.User{}

	user.Email = input.Email

	u, err := models.GetUserByEmail(input.Email)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": u})
}