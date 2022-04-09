package router

import (
	"github.com/gin-gonic/gin"
	"github.com/saadbadreddine/fsw-final-project-backend/controllers"
	"github.com/saadbadreddine/fsw-final-project-backend/middlewares"
)

func NewRouter() *gin.Engine {
	r := gin.Default()

	public := r.Group("/api")
	public.POST("/register", controllers.Register)
	public.POST("/login", controllers.Login)

	protected := r.Group("/api/auth")
	protected.Use(middlewares.JwtAuthMiddleware())
	protected.GET("/user", controllers.CurrentUser)
	protected.GET("/refresh", controllers.Refresh)
	protected.POST("/update-profile", controllers.EditProfile)
	protected.POST("/post", controllers.Post)
	protected.POST("/remove-post", controllers.RemovePost)
	protected.GET("/get-posts", controllers.GetAllPosts)
	protected.GET("/get-my-posts", controllers.GetMyPosts)
	protected.POST("/update-post", controllers.EditPost)
	protected.POST("/notify", controllers.SendNotification)

	protected_admin := r.Group("/api/auth/admin")
	protected_admin.Use(middlewares.JwtAdminMiddleware())
	protected_admin.POST("/create-sport", controllers.CreateSportCategory)
	protected_admin.POST("/create-utype", controllers.CreateUserType)
	protected_admin.GET("/get-post", controllers.GetPost)
	protected_admin.GET("/get-all-sports", controllers.GetSportCategories)

	return r
}
