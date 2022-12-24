//
//  User.swift
//  iOSApp
//
//  Created by Neal Archival on 12/22/22.
//

import Foundation

class Session: ObservableObject {
    @Published private(set) var token: String
    
    init() {
        token = ""
    }
    
    init(token: String) {
        self.token = token
    }
    
    public func setToken(_ token: String) {
        self.token = token
    }
    
    public func resetToken() {
        self.token = ""
    }
    
}
