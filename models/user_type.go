package models

import (
	"gorm.io/gorm"
)

type UserType struct {
	gorm.Model
	Role string `json:"role" gorm:"size:not null "`
}
