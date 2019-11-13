//
//  UserSession.swift
//  ChatUI
//
//  Created by Ryan on 11/8/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation

class UserSession: Codable {

    let name: String
    let email: String
    let mobileNumber: String
    let token: String

    init(name: String, email: String, mobileNumber: String, token: String) {
        self.name = name
        self.email = email
        self.mobileNumber = mobileNumber
        self.token = token
    }
}

