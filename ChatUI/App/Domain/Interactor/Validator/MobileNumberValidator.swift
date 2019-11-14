//
//  MobileNumberValidator.swift
//  ChatUI
//
//  Created by Ryan on 11/14/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation

struct MobileNumberValidator: ValidatorConvertible {
    func validated(_ value: String) throws {
        guard value.count >= 6 else {
            throw ValidationError(message: "Phone number must contain more than 6 digits" )
        }
        guard value.count < 18 else {
            throw ValidationError(message: "Phone number shoudn't conain more than 40 digits" )
        }
        
        do {
            if try NSRegularExpression(pattern: "^[0-9]{6,18}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(message: "Invalid phone number, phone number should not contain whitespaces or characters.")
            }
        } catch {
            throw ValidationError(message: "Invalid phone number, phone number should not contain whitespaces or characters.")
        }
    }
}
