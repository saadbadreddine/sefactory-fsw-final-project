package models

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDatabase() {

	err := godotenv.Load(".env")

	if err != nil {
		log.Fatalf("Error loading .env file")
	}

	DB_URL := fmt.
		Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8&parseTime=True&loc=Local",
			os.Getenv("DB_USER"),
			os.Getenv("DB_PASSWORD"),
			os.Getenv("DB_HOST"),
			os.Getenv("DB_PORT"),
			os.Getenv("DB_NAME"))

	DB, err = gorm.Open(mysql.Open(DB_URL))

	if err != nil {
		fmt.Println("Cannot connect to the database")
		log.Fatal("Connection error:", err)
	} else {
		fmt.Println("Connected successfully to the database")
	}

	DB.AutoMigrate(&User{}, &Post{}, &SportCategory{},
		&Connection{}, &UserType{})
}
