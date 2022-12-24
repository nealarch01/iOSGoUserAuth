package middlewares

import (
	"fmt"
	"net/http"
)

func ServerLogging(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("Client Address: %s \n %s %s %s \nHeaders:%s\n", r.RemoteAddr, r.Method, r.URL, r.Proto, r.Header)
		next.ServeHTTP(w, r)
	})
}
