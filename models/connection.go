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

func (c *Connection) SaveConnection() (*Connection, error) {

	var err error = DB.Debug().Create(&c).Error

	if err != nil {
		return &Connection{}, err
	}

	return c, nil
}

func FindAllConnections() ([]Connection, error) {

	var err error
	connections := []Connection{}
	err = DB.Debug().Model(&Connection{}).Limit(100).Find(&connections).Error
	if err != nil {
		return connections, err
	}
	return connections, err
}

func GetConnectionByID(con_id uint) (Connection, error) {

	c := Connection{}

	if err := DB.First(&c, con_id).Error; err != nil {
		return c, errors.New("not found")
	}

	return c, nil
}

func (c *Connection) UpdateConnection() (*Connection, error) {

	var err error = DB.Debug().Save(&c).Error

	if err != nil {
		return &Connection{}, err
	}

	return c, nil
}

func (c *Connection) DeleteConnection() (*Connection, error) {

	var err error = DB.Debug().Delete(&c).Error

	if err != nil {
		return &Connection{}, err
	}

	return c, nil
}
