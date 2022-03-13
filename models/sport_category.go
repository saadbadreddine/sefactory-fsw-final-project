package models

import (
	"errors"

	"gorm.io/gorm"
)

type SportCategory struct {
	gorm.Model
	Sport string `json:"sport" gorm:"size:not null"`
}
