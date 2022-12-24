package middlewares

import (
	"net/http"

	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/auth"
)

func CheckAuthorization(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if r.Header.Get("Authorization") == "" {
			w.WriteHeader(http.StatusUnauthorized)
			w.Write([]byte(`{"message": "Missing token"}`))
			return
		}
		tokenIsValid := auth.ValidateToken(r.Header.Get("Authorization"))
		if !tokenIsValid {
			w.WriteHeader(http.StatusUnauthorized)
			w.Write([]byte(`{"message": "Invalid token"}`))
			return
		}
		next.ServeHTTP(w, r)
	})
}
