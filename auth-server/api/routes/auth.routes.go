package routes

import (
	"github.com/gorilla/mux"
	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/controllers"
)

func AuthRoutes(router *mux.Router) {
	router.HandleFunc("/login", controllers.Login).Methods("POST")
	router.HandleFunc("/register", controllers.Register).Methods("POST")
	router.HandleFunc("/logout", controllers.Logout).Methods("POST")
}
