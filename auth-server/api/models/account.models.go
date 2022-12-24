package models

import (
	"errors"
	"fmt"
	"strings"

	"database/sql"

	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/database"
)

type Account struct {
	ID        int    `json:"id"`
	Email     string `json:"email"`
	Username  string `json:"username"`
	Password  string `json:"password"`
	CreatedAt string `json:"created_at"`
}

func GetAccountFromID(id int) (*Account, error) {
	conn := database.GetConnection()
	if conn == nil {
		fmt.Println("Failed to get database connection")
		return nil, errors.New("failed to get database connection")
	}

	queryStmt := "SELECT id, email, username, created_at FROM account WHERE id = $1"
	account := new(Account)
	if err := conn.QueryRow(queryStmt, id).Scan(&account.ID, &account.Email, &account.Username, &account.CreatedAt); err != nil {
		account = nil // Remove the reference
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	return account, nil
}

func CreateNewAccount(account Account) (int, error) {
	account.Email = strings.ToLower(account.Email)
	account.Username = strings.ToLower(account.Username)
	conn := database.GetConnection()
	if conn == nil {
		fmt.Println("Failed to get database connection")
		return 0, errors.New("failed to get database connection")
	}
	var id int
	queryStmt := "INSERT INTO account (email, username, password) VALUES ($1, $2, $3) RETURNING id"
	err := conn.QueryRow(queryStmt, account.Email, account.Username, account.Password).Scan(&id)
	// Get the ID of the newly created account
	if err != nil {
		fmt.Println("Failed to create a new account")
		return 0, err
	}
	return id, nil
}

func ValidateCredentials(userIdentifier string, password string) (int, error) {
	userIdentifier = strings.ToLower(userIdentifier)
	conn := database.GetConnection()
	if conn == nil {
		fmt.Println("Failed to get database connection")
		return 0, errors.New("failed to get database connection")
	}
	queryStmt := "SELECT id FROM account WHERE %s = $1 AND password = $2"
	if strings.Contains(userIdentifier, "@") {
		queryStmt = fmt.Sprintf(queryStmt, "email")
	} else {
		queryStmt = fmt.Sprintf(queryStmt, "username")
	}
	// Make the query
	var accountID int
	if err := conn.QueryRow(queryStmt, userIdentifier, password).Scan(&accountID); err != nil {
		if err == sql.ErrNoRows {
			return 0, nil
		}
		return 0, err
	}
	return accountID, nil
}

func UsernameExists(username string) (bool, error) {
	username = strings.ToLower(username)
	conn := database.GetConnection()
	if conn == nil {
		fmt.Println("Failed to get database connection")
		return false, errors.New("failed to get database connection")
	}
	queryStmt := "SELECT id FROM account WHERE username = $1"
	var accountID int
	if err := conn.QueryRow(queryStmt, username).Scan(&accountID); err != nil {
		if err == sql.ErrNoRows {
			return false, nil
		}
		return false, err
	}
	return true, nil
}

func EmailExists(email string) (bool, error) {
	email = strings.ToLower(email)
	conn := database.GetConnection()
	if conn == nil {
		fmt.Println("Failed to get database connection")
		return false, errors.New("failed to get database connection")
	}
	queryStmt := "SELECT id FROM account WHERE email = $1"
	var accountID int
	if err := conn.QueryRow(queryStmt, email).Scan(&accountID); err != nil {
		if err == sql.ErrNoRows {
			return false, nil
		}
		return false, err
	}
	return true, nil
}

func DeleteAccount(accountID int) error {
	conn := database.GetConnection()
	if conn == nil {
		fmt.Println("Failed to get database connection")
		return errors.New("failed to get database connection")
	}
	queryStmt := "DELETE FROM account WHERE id = $1"
	if _, err := conn.Exec(queryStmt, accountID); err != nil {
		return err
	}
	return nil
}
