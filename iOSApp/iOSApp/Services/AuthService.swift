//
//  AuthService.swift
//  iOSApp
//
//  Created by Neal Archival on 12/22/22.
//

import Foundation

func Login(userIdentifier: String, password: String) async -> (token: String?, serverMessage: String) { // Returns an authentication token
    let apiEndpoint = URL(string: "http://localhost:8004/auth/login")!
    var httpRequest = URLRequest(url: apiEndpoint)
    httpRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    httpRequest.httpMethod = "POST"
    var requestBody = URLComponents()
    requestBody.queryItems = []
    requestBody.queryItems!.append(URLQueryItem(name: "user_identifier", value: userIdentifier))
    requestBody.queryItems!.append(URLQueryItem(name: "password", value: password))
    httpRequest.httpBody = requestBody.query!.data(using: .utf8)
    do {
        let (responseData, urlResponse) = try await URLSession.shared.data(for: httpRequest)
        guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
            return (nil, "No response received from server. Please try again.")
        }
        if httpUrlResponse.statusCode != 200 {
            let decodedData = try JSONDecoder().decode(APIErrorResponse.self, from: responseData)
            return (nil, decodedData.message)
        }
        let decodedData = try JSONDecoder().decode(AuthenticationResponse.self, from: responseData)
        return (decodedData.token, "Successfully logged in!")
    } catch let error {
        print(error.localizedDescription)
        return (nil, "An unexpected error occured. Please try again.")
    }
}

func Register(username: String, email: String, password: String) async -> (token: String?, serverMessage: String) {
    let apiEndpoint = URL(string: "http://localhost:8004/auth/register")!
    var httpRequest = URLRequest(url: apiEndpoint)
    httpRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    httpRequest.httpMethod = "POST"
    var requestBody = URLComponents()
    requestBody.queryItems = []
    requestBody.queryItems!.append(URLQueryItem(name: "username", value: username))
    requestBody.queryItems!.append(URLQueryItem(name: "password", value: password))
    requestBody.queryItems!.append(URLQueryItem(name: "email", value: email))
    httpRequest.httpBody = requestBody.query!.data(using: .utf8)
    do {
        let (responseData, urlResponse) = try await URLSession.shared.data(for: httpRequest)
        guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
            return (nil, "No response received from the server. Please try again.")
        }
        if httpUrlResponse.statusCode != 201 {
            let decodedData = try JSONDecoder().decode(APIErrorResponse.self, from: responseData)
            return (nil, decodedData.message)
        }
        let decodedData = try JSONDecoder().decode(AuthenticationResponse.self, from: responseData)
        return (decodedData.token, "Successfully logged in!")
    } catch let error {
        print(error.localizedDescription)
        return (nil, "An unexpected error occured. Please try again.")
    }
}

func Logout(token: String) async -> Void {
    let apiEndpoint = URL(string: "http://localhost:8004/auth/logout")!
    var httpRequest = URLRequest(url: apiEndpoint)
    httpRequest.httpMethod = "POST"
    httpRequest.addValue(token, forHTTPHeaderField: "Authorization")
    do {
        let (_, _) = try await URLSession.shared.data(for: httpRequest)
        print("Logged out")
    } catch let error {
        print(error.localizedDescription)
        print("There was an error blocking token")
    }
}

