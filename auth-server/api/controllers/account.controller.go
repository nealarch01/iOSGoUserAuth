package controllers

import (
	"fmt"
	"net/http"
	"encoding/json"

	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/auth"
	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/models"
)

func GetAccountData(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	tokenString := r.Header.Get("Authorization")
	accountID := auth.GetAccountID(tokenString)
	accountData, err := models.GetAccountFromID(accountID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"message": "Internal server error"}`))
		return
	}
	dataMap := make(map[string]interface{})
	dataMap["id"] = accountData.ID
	dataMap["username"] = accountData.Username
	dataMap["email"] = accountData.Email
	dataMap["created_at"] = accountData.CreatedAt
	w.WriteHeader(http.StatusOK)
	jsonData, _ := json.Marshal(dataMap)
	fmt.Fprintf(w, "%s", jsonData)
}

func UpdateAccount(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	if r.Header.Get("Content-Type") != "application/x-www-form-urlencoded" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message": "Invalid content type. Must be 'application/x-www-form-urlencoded'"}`))
		return
	}
	// Not implemented yet
	w.WriteHeader(http.StatusNotImplemented)
	w.Write([]byte(`{"message": "Not implemented"}`))
}

func DeleteAccount(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	tokenString := r.Header.Get("Authorization")
	accountID := auth.GetAccountID(tokenString)
	if err := models.DeleteAccount(accountID); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"message": "Internal server error"}`))
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"message": "Account deleted"}`))
}
