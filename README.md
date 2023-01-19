# iOS Go User Authentication
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg" height="150" align="right" />
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/go/go-original.svg" height="150" align="right" />
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/swift/swift-original.svg" height="150" align="right" />

          

User authentication full stack application created in Swift and Go (Golang) using JSON Web Tokens (JWTs)

## Table of Contents:
- [Video](#video)
- [Technology Stack](#tech-stack)
- [Installation/Configuration](#installationconfigration)
  - [Database](#setting-up-the-database)
  - [REST API](#rest-api-setup--configuration)
  - [iOS App](#ios-app-setup)
- [REST API Documentation](#rest-api-documentation)
- [Features](#features-🔥)
- [Missing Features](#missing-features-🫠)

## Video
https://user-images.githubusercontent.com/73256760/209417784-0bb07f94-495a-4c5e-be82-87fd9233bba8.mov



## Tech Stack
### Frontend (iOS Application)
- **Language:** Swift
- **Frameworks**: SwiftUI
- **Architecture:** Model-View-ViewModel (MVVM)

### Backend (REST API)
- **Language:** Go (Golang)
- **Frameworks/Libraries:** Gorilla/MUX, JSON Web Tokens (JWTs), database/sql
- **Architecture:** Model-View-Controller (MVC)

### Database
- PostgreSQL

## Installation/Configration:
Make sure you have all dependencies: XCode, Go, PostgreSQL (Preferrably version 15+)

### Database Setup:
- Create a PostgreSQL instance using Postgres.app
- An SQL Script was provided that inserts two essential tables: `account` and `token_blacklist`
  - To run this script, navigate into the `./database-setup` directory and use `psql -p {port_number} -f tables.sql`
    - Example: `psql -p 5432 -f tables.sql`

### REST API Setup & Configuration
After completing database set up and configuration: running `tables.sql` and activating the server instance. You will need to modify  `./auth-server/api/database/connection.go`
- In this file is a connection string. You will most likely have to change this if your PostgreSQL instance have a different name, host, password, etc

- After completing the steps above, you can run main.go, example: `go run main.go`. Or, build it into an executable and then run it, example: `go build main.go && ./main`

### iOS App Setup:
- Simply open the top-level iOSApp folder in XCode

## REST API Documentation:
- [Postman Documentation](https://documenter.getpostman.com/view/21072555/2s8Z6vYEMF)


## Directory Structure
```
.
├── auth-server
│   └── api
│       ├── auth
│       ├── controllers
│       ├── database
│       ├── middlewares
│       ├── models
│       ├── routes
│       └── utils
├── database-setup
└── iOSApp
    ├── iOSApp
    │   ├── Assets.xcassets
    │   │   ├── AccentColor.colorset
    │   │   └── AppIcon.appiconset
    │   ├── Components
    │   ├── Extensions
    │   ├── Models
    │   ├── Preview Content
    │   │   └── Preview Assets.xcassets
    │   ├── Services
    │   ├── ViewModels
    │   └── Views
    └── iOSApp.xcodeproj
        ├── project.xcworkspace
            └── xcshareddata
                └── swiftpm
                    └── configuration
```

## Features 🔥
- Login / Register 
- Authorization middleware for secured endpoints
- JWT validation
- Username, email, and password sanitzation and validation using regular expressions
- Token blacklisting after logout
- Clean and responsive user interface
- iOS app error propagation for 400/500 status codes

## Missing features 🫠:
- No JWT refresh endpoints
- PUT method to update account data was not implemented
- Storing token for persistent login w/ CoreData/UserDefaults
- HTTPs server (HTTP was chosen for development purposes)
