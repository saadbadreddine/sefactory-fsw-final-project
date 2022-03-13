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

func (p *Post) UpdatePost() (*Post, error) {

	result := DB.Model(&Post{}).
		Where("id = ?", p.ID).
		Where("user_id = ?", p.UserID).
		First(&p)

	if result.Error == gorm.ErrRecordNotFound {
		return &Post{}, errors.New("invalid request")
	} else if result.Error != nil {
		return &Post{}, result.Error
	}

	err := DB.Model(&Post{}).
		Where("id = ?", p.ID).
		Where("user_id = ?", p.UserID).
		Omit("user_id, created_at").
		Save(&p).Error

	if err != nil {
		return &Post{}, err
	}

	return p, nil
}

func DeletePost(post_id uint, user_id uint) error {

	result := DB.Debug().Where("id = ?", post_id).
		Where("user_id = ?", user_id).
		Delete(&Post{})

	if result.RowsAffected == 0 {
		return errors.New("no rows affected")
	}

	return nil
}

func FindAllPosts() ([]Post, error) {

	var err error
	posts := []Post{}

	err = DB.Debug().Model(&Post{}).Limit(100).Find(&posts).Error
	if err != nil {
		return posts, err
	}

	return posts, err
}

func GetPostsByUserID(user_id uint) ([]Post, error) {

	p := []Post{}

	if err := DB.Where("user_id", user_id).Find(&p).Error; err != nil {
		return p, errors.New("post not found")
	}

	return p, nil
}
