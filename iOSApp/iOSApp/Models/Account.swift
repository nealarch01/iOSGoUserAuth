//
//  Account.swift
//  iOSApp
//
//  Created by Neal Archival on 12/22/22.
//

import Foundation

class Account: Decodable {
    var id: Int
    var email: String
    var username: String
    var created_at: String
    
    init() {
        id = 0
        email = ""
        username = ""
        created_at = ""
    }
}
