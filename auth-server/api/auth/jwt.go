package auth

import (
	"errors"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v4"
	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/database"
)

func CreateToken(accountID int) string {
	claims := jwt.MapClaims{}
	claims["id"] = accountID
	claims["iat"] = jwt.NewNumericDate(time.Now())
	claims["exp"] = jwt.NewNumericDate(time.Now().Add(time.Hour * 24 * 3)) // Expore after 3 days
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, _ := token.SignedString([]byte("secret"))
	return tokenString
}

func ValidateToken(tokenString string) bool {
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte("secret"), nil
	})
	if err != nil {
		return false
	}
	if !token.Valid {
		return false
	}
	conn := database.GetConnection()
	if conn == nil {
		fmt.Println("Failed to check if token is blacklisted")
		return false
	}
	var count int
	queryStmt := "SELECT COUNT(*) FROM token_blacklist WHERE token = $1"
	if err := conn.QueryRow(queryStmt, tokenString).Scan(&count); err != nil {
		fmt.Println("Failed to check if token is blacklisted")
		return false
	}
	return count == 0
}

func GetAccountID(tokenString string) int {
	token, _ := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		return []byte("secret"), nil
	})
	claims := token.Claims.(jwt.MapClaims)
	accountID := int(claims["id"].(float64))
	return accountID
}

func AddToBlacklist(tokenString string) error {
	conn := database.GetConnection()
	if conn == nil {
		fmt.Println("Failed to get database connection")
		return errors.New("failed to get database connection")
	}
	queryStmt := "INSERT INTO token_blacklist (token) VALUES ($1)"
	if _, err := conn.Exec(queryStmt, tokenString); err != nil {
		fmt.Println("Failed to add token to blacklist")
		return err
	}
	return nil
}
