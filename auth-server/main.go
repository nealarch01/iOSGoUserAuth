package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/database"
	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/middlewares"
	"github.com/nealarch01/iOSGoUserAuth/auth-server/api/routes"
)

func initAndCheckDatabase() {
	fmt.Println("Checking database...")
	if err := database.InitConnectionPool(); err != nil {
		os.Exit(2)
	}
	fmt.Println("Successfully initialized database connection pool")
	if conn := database.GetConnection(); conn != nil {
		if err := conn.Ping(); err != nil {
			fmt.Println("Failed to ping database")
			os.Exit(1)
		}
	}
	fmt.Println("Check complete. Database is up and running")
}

func entry(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"message": "Hello World"}`))
}

func main() {
	initAndCheckDatabase()

	publicRouter := mux.NewRouter()
	publicRouter.HandleFunc("/", entry).Methods("GET")

	// Set the logging middleware
	publicRouter.Use(middlewares.ServerLogging)

	// Auth routes
	authRouter := publicRouter.PathPrefix("/auth").Subrouter()
	routes.AuthRoutes(authRouter)

	// Secured routes
	securedAccountRouter := publicRouter.PathPrefix("/account").Subrouter()
	securedAccountRouter.Use(middlewares.CheckAuthorization)
	routes.AccountRoutes(securedAccountRouter)

	fmt.Println("Listening on port 8004")
	http.ListenAndServe(":8004", publicRouter)
}
