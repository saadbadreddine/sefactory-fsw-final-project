package models

import (
	"errors"

	"gorm.io/gorm"
)

type Post struct {
	gorm.Model
	UserID    uint
	User      User          `json:"-" gorm:"foreignKey:UserID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL"`
	SportID   uint          `json:"sport_id"`
	Sport     SportCategory `json:"-" gorm:"foreignKey:SportID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL"`
	Time      string        `json:"time" gorm:"not null;default:null"`
	Message   string        `json:"message" gorm:"size:255;not null;default:null"`
	Latitude  string        `json:"latitude" gorm:"not null;default:null"`
	Longitude string        `json:"longitude" gorm:"not null;default:null"`
}

func (p *Post) SavePost() (*Post, error) {

	var err error = DB.Debug().Create(&p).Error

	if err != nil {
		return &Post{}, err
	}

	return p, nil
}
