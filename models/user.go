package models

import (
	"errors"
	"html"
	"strings"

	"github.com/saadbadreddine/fsw-final-project-backend/utils/token"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	UserTypeID uint     `gorm:"default:2"`
	UserType   UserType `json:"-" gorm:"foreignKey:UserTypeID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	Email      string   `json:"email" gorm:"size:100;not null;unique"`
	Password   string   `json:"-" gorm:"size:255;not null;"`
	FirstName  string   `json:"first_name" gorm:"size:100;not null"`
	LastName   string   `json:"last_name" gorm:"size:100;not null"`
	Age        uint8    `json:"age"`
	Gender     string   `json:"gender" gorm:"size:100"`
	AboutMe    string   `json:"about_me" gorm:"size:255"`
}