//
//  AuthViewModel.swift
//  iOSApp
//
//  Created by Neal Archival on 12/22/22.
//

import Foundation

class LoginForm: ObservableObject {
    @Published var userIdentifier: String
    @Published var password: String
    
    init() {
        userIdentifier = ""
        password = ""
    }
}

class RegisterForm: ObservableObject {
    @Published var username: String
    @Published var password: String
    @Published var passwordConfirmation: String
    @Published var email: String
    
    init() {
        username = ""
        password = ""
        passwordConfirmation = ""
        email = ""
    }
}

enum AuthScreen {
    case login
    case register
}

@MainActor class AuthViewModel: ObservableObject {
    @Published var loginForm: LoginForm
    @Published var registerForm: RegisterForm
    @Published var activeScreen: AuthScreen
    @Published var loginErrorMessage: String
    @Published var registerErrorMessage: String
    @Published var sessionToken: String
    
    init() {
        loginForm = LoginForm()
        registerForm = RegisterForm()
        activeScreen = .login
        loginErrorMessage = ""
        registerErrorMessage = ""
        sessionToken = ""
    }
    
    public func submitLoginForm() async -> Void {
        if loginForm.userIdentifier == "" {
            loginErrorMessage = "Error: Username cannot be empty"
            return
        }
        if loginForm.password == "" {
            loginErrorMessage = "Error: Password cannot be empty"
            return
        }
        let loginResponse = await Login(userIdentifier: loginForm.userIdentifier, password: loginForm.password)
        if loginResponse.token == nil {
            loginErrorMessage = loginResponse.serverMessage
            print(loginErrorMessage)
            return
        }
        sessionToken = loginResponse.token!
    }
    
    public func submitRegisterForm() async -> Void {
        if registerForm.username == "" {
            registerErrorMessage = "Error: Username cannot be empty"
            return
        }
        if registerForm.password == "" {
            registerErrorMessage = "Error: Password cannot be empty"
            return
        }
        if registerForm.password != registerForm.passwordConfirmation {
            registerErrorMessage = "Error: Passwords do not match"
            return
        }
        if registerForm.email == "" {
            registerErrorMessage = "Error: Email cannot be empty"
            return
        }
        let registerResponse = await Register(username: registerForm.username, email: registerForm.email, password: registerForm.password)
        if registerResponse.token == nil {
            registerErrorMessage = registerResponse.serverMessage
            return
        }
        sessionToken = registerResponse.token!
    }
    
    public func toggleAuthView() {
        resetErrorMessages()
        if activeScreen == .login {
            activeScreen = .register
            return
        }
        activeScreen = .login
    }
    
    private func resetErrorMessages() {
        registerErrorMessage = ""
        loginErrorMessage = ""
    }
    
}
