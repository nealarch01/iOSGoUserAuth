package controllers

import (
	"fmt"
	"net/http"

	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/auth"
	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/models"
	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/utils"
)

func Login(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	if r.Header.Get("Content-Type") != "application/x-www-form-urlencoded" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Invalid content type. Must be 'application/x-www-form-urlencoded'"}`))
		return
	}
	if err := r.ParseForm(); err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Failed to parse form"}`))
		return
	}
	userIdentifier := r.Form.Get("user_identifier")
	if userIdentifier == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Missing field: 'user_identifier'"}`))
		return
	}
	password := r.Form.Get("password")
	if password == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Missing field: 'password'"}`))
		return
	}
	accountID, err := models.ValidateCredentials(userIdentifier, password)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"message": "Failed to validate credentials"}`))
		return
	}
	if accountID == 0 {
		w.WriteHeader(http.StatusUnauthorized)
		w.Write([]byte(`{"message": "Invalid credentials"}`))
		return
	}
	// Generate a JWT
	tokenString := auth.CreateToken(accountID)
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, `{"token": "%s"}`, tokenString)
}

func Register(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	if r.Header.Get("Content-Type") != "application/x-www-form-urlencoded" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Invalid content type. Must be 'application/x-www-form-urlencoded'"}`))
		return
	}
	r.ParseForm()
	var account models.Account
	account.Username = r.Form.Get("username")
	account.Password = r.Form.Get("password")
	account.Email = r.Form.Get("email")
	if account.Username == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Missing field: 'username'"}`))
		return
	}
	if account.Password == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Missing field: 'password'"}`))
		return
	}
	if account.Email == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Missing field: 'email'"}`))
		return
	}
	// Check if the username or email already exists
	if exists, err := models.UsernameExists(account.Username); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"message": "Internal server error"}`))
		return
	} else {
		if exists {
			w.WriteHeader(http.StatusConflict)
			w.Write([]byte(`{"message": "Username taken"}`))
			return
		}
	}
	if exists, err := models.EmailExists(account.Email); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"message": "Internal server error"}`))
		return
	} else {
		if exists {
			w.WriteHeader(http.StatusConflict)
			w.Write([]byte(`{"message": "Email taken"}`))
			return
		}
	}
	// Do regular expression matching and ensure that the fields are valid
	if !utils.IsValidUsername(account.Username) {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Invalid username. Username must be between 3 and 32 characters and can only contain letters, numbers, underscores"}`))
		return
	}
	if !utils.IsValidPassword(account.Password) {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Invalid password. Password must be between 6 and 32 characters and can only contain letters, numbers, and special characters"}`))
		return
	}
	if !utils.IsValidEmail(account.Email) {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Invalid email"}`))
		return
	}
	// Create the account
	newAccountID, err := models.CreateNewAccount(account)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"message": "Failed to create account"}`))
		return
	}
	tokenString := auth.CreateToken(newAccountID)
	w.WriteHeader(http.StatusCreated)
	fmt.Fprintf(w, `{"token": "%s"}`, tokenString)
}

func Logout(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	tokenString := r.Header.Get("Authorization")
	if tokenString == "" {
		w.Write([]byte(`{"message": "Successfully logged out but no token was provided"}`))
		return
	}
	if err := auth.AddToBlacklist(tokenString); err != nil {
		w.Write([]byte(`{"message": "Successfully logged out but failed to add token to blacklist"}`))
		return
	}
	w.Write([]byte(`{"message": "Successfully logged out"}`))
}
