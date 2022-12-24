//
//  AuthView.swift
//  iOSApp
//
//  Created by Neal Archival on 12/22/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Login")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Color.white)
                    .padding([.leading, .bottom])
                Spacer()
            }
            .background(Color(hex: 0x6A5ACD))
            VStack {
                InputField(topLabel: "Username", placeholder: "Enter username or email", text: $viewModel.loginForm.userIdentifier)
                    .padding([.top], 10)
                SecuredInputField(topLabel: "Password", placeholder: "Enter password", text: $viewModel.loginForm.password)
                if viewModel.loginErrorMessage != "" {
                    Text("\(viewModel.loginErrorMessage)")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.red)
                }
                SubmitButton(text: "Login", action: viewModel.submitLoginForm)
                    .padding([.top], 10)
                HStack(spacing: 0) {
                    Text("Don't have an account? ")
                        .font(.system(size: 20, weight: .medium))
                    Button(action: { viewModel.toggleAuthView() }) {
                        Text("Register")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(hex: 0x6A5ACD))
                    } // Button
                } // HStack
                .padding([.top], 20)
            } // VStack
            .padding([.leading, .trailing])
            Spacer()
        } // VStack
    }
}

struct RegisterView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Register")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Color.white)
                    .padding([.leading, .bottom])
                Spacer()
            } // HStack
            .background(Color(hex: 0x6A5ACD))
            VStack(spacing: 5) {
                InputField(topLabel: "Username", placeholder: "Enter username", text: $viewModel.registerForm.username)
                InputField(topLabel: "Email", placeholder: "Enter email", text: $viewModel.registerForm.email)
                SecuredInputField(topLabel: "Password", placeholder: "Enter password", text: $viewModel.registerForm.password)
                SecuredInputField(topLabel: "Confirm Password", placeholder: "Confirm password", text: $viewModel.registerForm.passwordConfirmation)
                if viewModel.registerErrorMessage != "" {
                    Text("\(viewModel.registerErrorMessage)")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.red)
                }
                SubmitButton(text: "Register", action: viewModel.submitRegisterForm)
                    .padding([.top], 10)
                HStack(spacing: 0) {
                    Text("Already have an account? ")
                        .font(.system(size: 20, weight: .medium))
                    Button(action: { viewModel.toggleAuthView() }) {
                        Text("Login")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(hex: 0x6A5ACD))
                    } // Button
                } // HStack
                .padding([.top], 20)
            } // VStack
            .padding([.leading, .trailing])
            Spacer()
        } // VStack
    }
}

struct AuthView: View {
    @EnvironmentObject var session: Session
    @StateObject private var viewModel = AuthViewModel()
    var body: some View {
        ZStack {
            if viewModel.activeScreen == .login {
                LoginView()
                    .environmentObject(viewModel)
            } else {
                RegisterView()
                    .environmentObject(viewModel)
            }
        } // ZStack
        .onChange(of: viewModel.sessionToken.count) { _ in
            session.setToken(viewModel.sessionToken)
        }
    }
}



struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(Session())
    }
}
