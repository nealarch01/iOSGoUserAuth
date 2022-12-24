package database

import (
	"database/sql"
	"fmt"
)

var psqlDB *sql.DB = nil

func InitConnectionPool() error {
	connectionString := "user=postgres dbname=appdb port=5445 sslmode=disable"
	db, err := sql.Open("postgres", connectionString)
	if err != nil {
		psqlDB = nil
		return err
	}
	psqlDB = db
	psqlDB.SetMaxOpenConns(10)
	psqlDB.SetMaxIdleConns(2)
	return nil
}

func GetConnection() *sql.DB {
	if psqlDB == nil {
		InitConnectionPool()
		fmt.Println("connection pool failed to initialized")
	}
	return psqlDB
}
