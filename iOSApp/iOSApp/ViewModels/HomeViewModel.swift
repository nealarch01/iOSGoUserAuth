//
//  HomeViewModel.swift
//  iOSApp
//
//  Created by Neal Archival on 12/23/22.
//

import Foundation

extension HomeView {
    @MainActor class ViewModel: ObservableObject {
        @Published var account: Account
        @Published var errorMessage: String = ""
        
        init() {
            account = Account()
            errorMessage = ""
        }
        
        public func getAccountData(token: String) async -> Void {
            let getAccountResponse = await GetAccountData(tokenString: token)
            if getAccountResponse.account == nil {
                errorMessage = getAccountResponse.serverMessage
                return
            }
            account = getAccountResponse.account!
        }
    }
}
