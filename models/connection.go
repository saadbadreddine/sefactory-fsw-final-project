package models

import (
	"errors"

	"gorm.io/gorm"
)

type Connection struct {
	gorm.Model
	SenderID   uint
	Sender     User `json:"-" gorm:"foreignKey:SenderID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	ReceiverID uint
	Receiver   User `json:"-" gorm:"foreignKey:ReceiverID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	IsAccepted bool `json:"is_accepted" gorm:"size:not null;default:false"`
}
