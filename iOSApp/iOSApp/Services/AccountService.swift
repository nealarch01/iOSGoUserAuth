//
//  AccountService.swift
//  iOSApp
//
//  Created by Neal Archival on 12/23/22.
//

import Foundation

func GetAccountData(tokenString: String) async -> (account: Account?, serverMessage: String) {
    let apiEndpoint = URL(string: "http://localhost:8004/account/")!
    var httpRequest = URLRequest(url: apiEndpoint)
    httpRequest.httpMethod = "GET"
    httpRequest.setValue(tokenString, forHTTPHeaderField: "Authorization")
    do {
        let (responseData, urlResponse) = try await URLSession.shared.data(for: httpRequest)
        guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
            return (nil, "No response received from server")
        }
        if httpUrlResponse.statusCode != 200 {
            // Might want to log out user here if an unauthorized response was provided
            let decodedData = try JSONDecoder().decode(APIErrorResponse.self, from: responseData)
            return (nil, "\(decodedData.message)")
        }
        let decodedData = try? JSONDecoder().decode(Account.self, from: responseData)
        return (decodedData, "")
    } catch let error {
        print(error.localizedDescription)
        return (nil, "An unexpected error occured. Could not fetch account data.")
    }
}
