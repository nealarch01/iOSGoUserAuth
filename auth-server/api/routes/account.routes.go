package routes

import (
	"github.com/gorilla/mux"
	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/controllers"
)

func AccountRoutes(router *mux.Router) {
	router.HandleFunc("/", controllers.GetAccountData).Methods("GET")
	router.HandleFunc("/", controllers.UpdateAccount).Methods("PUT")
	router.HandleFunc("/", controllers.DeleteAccount).Methods("DELETE")
}
