package utils

import(
	"strings"
	"regexp"
)

func IsValidEmail(email string) bool {
	if len(email) < 3 && len(email) > 254 {
		return false
	}
	regexp := regexp.MustCompile(`^[a-zA-Z0-9.!#$%&'*+/=?^_` + "`" + `{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$`)
	return regexp.MatchString(email)
}

func IsValidUsername(username string) bool {
	if len(username) < 3 && len(username) > 32 {
		return false
	}
	regexp := regexp.MustCompile(`^[a-zA-Z0-9_]+$`) // Only allow alphanumeric characters and underscores
	return regexp.MatchString(username)
}

func IsValidPassword(password string) bool {
	if len(password) < 8 && len(password) > 64 {
		return false
	}
	// Password must be > 6 but < 32 characters. Can only contain letters, number, and special characters
	regexp := regexp.MustCompile(`^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+$`)
	return regexp.MatchString(password)
}

func IsEmail(email string) bool {
	return strings.Contains(email, "@")	
}