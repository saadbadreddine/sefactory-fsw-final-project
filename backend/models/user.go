package models

import (
	"errors"
	"html"
	"strings"

	"github.com/google/uuid"
	"github.com/saadbadreddine/fsw-final-project-backend/utils/token"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	UserTypeID uint      `gorm:"default:2"`
	UserType   UserType  `json:"-" gorm:"foreignKey:UserTypeID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	Email      string    `json:"email" gorm:"size:100;not null;unique"`
	Password   string    `json:"-" gorm:"size:255;not null;"`
	FirstName  string    `json:"first_name" gorm:"size:100;not null"`
	LastName   string    `json:"last_name" gorm:"size:100;not null"`
	DOB        string    `json:"dob"`
	Gender     string    `json:"gender" gorm:"size:100"`
	AboutMe    string    `json:"about_me" gorm:"size:255"`
	FirebaseID uuid.UUID `json:"firebase_id"`
	AvatarURL  string    `json:"avatar_url" gorm:"size:255;default:https://ca.slack-edge.com/T0NC4C7NK-U039444J2UR-g1e75ab176a1-512"`
}

func (u *User) SaveUser() (*User, error) {

	var err error = DB.Debug().Create(&u).Error

	if err != nil {
		return &User{}, err
	}

	return u, nil
}

func (u *User) BeforeSave(*gorm.DB) error {

	// turn password into hash
	hashedPassword, err := bcrypt.
		GenerateFromPassword([]byte(u.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	u.Password = string(hashedPassword)

	u.FirebaseID, _ = uuid.NewRandom()

	// remove spaces
	u.Email = html.EscapeString(strings.TrimSpace(u.Email))

	return nil
}

func (u *User) UpdateUser(user_id uint) (*User, error) {

	if u.Password != "" {
		hashedPassword, _ := bcrypt.
			GenerateFromPassword([]byte(u.Password), bcrypt.DefaultCost)

		u.Password = string(hashedPassword)
	}

	err := DB.Debug().Model(&User{}).
		Where("id = ?", user_id).
		Updates(User{FirstName: u.FirstName, LastName: u.LastName, Email: u.Email, Password: u.Password,
			AboutMe: u.AboutMe, AvatarURL: u.AvatarURL}).Error

	if err != nil {
		return &User{}, err
	}

	return u, nil
}

func VerifyPassword(password, hashedPassword string) error {

	return bcrypt.
		CompareHashAndPassword([]byte(hashedPassword), []byte(password))
}

func LoginCheck(email string, password string) (string, uuid.UUID, error) {

	var err error
	u := User{}

	err = DB.Model(User{}).Where("email = ?", email).Take(&u).Error
	if err != nil {
		return "Email not registered", uuid.UUID{}, err
	}

	err = VerifyPassword(password, u.Password)
	if err != nil && err == bcrypt.ErrMismatchedHashAndPassword {
		return "", uuid.UUID{}, err
	}

	firebase_id := u.FirebaseID
	token, err := token.GenerateToken(uint(u.ID), uint(u.UserTypeID))
	if err != nil {
		return "", uuid.UUID{}, err
	}

	return token, firebase_id, nil
}

func GetUserByID(uid uint) (User, error) {

	var u User

	if err := DB.First(&u, uid).Error; err != nil {
		return u, errors.New("User not found")
	}

	return u, nil
}
