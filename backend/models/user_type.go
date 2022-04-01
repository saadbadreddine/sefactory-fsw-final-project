package models

import (
	"gorm.io/gorm"
)

type UserType struct {
	gorm.Model
	Role string `json:"role" gorm:"size:not null "`
}

func (ut *UserType) SaveUserType() (*UserType, error) {

	var err error = DB.Debug().Create(&ut).Error

	if err != nil {
		return &UserType{}, err
	}

	return ut, nil
}