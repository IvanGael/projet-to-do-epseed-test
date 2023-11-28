// models.go

package main

import (
	"time"
	// "gorm.io/gorm"
)

type Note struct {
	ID        string `gorm:"primaryKey;type:uuid;default:gen_random_uuid()"`
	CreatedAt time.Time
	UpdatedAt time.Time
	Title     string `gorm:"unique;not null"`
	Content   string `gorm:"not null"`
	Color     string
	Priority  bool
	Status    string `gorm:"not null"`
}
