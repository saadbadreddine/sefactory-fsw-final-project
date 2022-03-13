package main

import (
	"github.com/saadbadreddine/fsw-final-project-backend/models"
	"github.com/saadbadreddine/fsw-final-project-backend/router"
)

func main() {

	models.ConnectDatabase()

	r := router.NewRouter()
	r.Run()
}