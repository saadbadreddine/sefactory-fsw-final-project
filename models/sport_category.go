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

func FindAllSports() ([]SportCategory, error) {

	var err error
	sports := []SportCategory{}
	err = DB.Debug().Model(&SportCategory{}).Limit(100).Find(&sports).Error
	if err != nil {
		return sports, err
	}
	return sports, err
}
