package models

import (
	"errors"

	"gorm.io/gorm"
)

type SportCategory struct {
	gorm.Model
	Sport string `json:"sport" gorm:"size:not null"`
}

func (s *SportCategory) SaveSport() (*SportCategory, error) {

	var err error = DB.Debug().Create(&s).Error

	if err != nil {
		return &SportCategory{}, err
	}

	return s, nil
}
