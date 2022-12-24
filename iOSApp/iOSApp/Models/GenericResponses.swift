//
//  GenericResponses.swift
//  iOSApp
//
//  Created by Neal Archival on 12/22/22.
//

import Foundation

class APIErrorResponse: Decodable {
    var message: String
}

class AuthenticationResponse: Decodable {
    var token: String
}
