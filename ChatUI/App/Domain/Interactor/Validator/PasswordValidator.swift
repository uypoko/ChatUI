//
//  PasswordValidator.swift
//  ChatUI
//
//  Created by Ryan on 11/14/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) throws {
        guard value != "" else {throw ValidationError(message: "Password is Required")}
        guard value.count >= 6 else { throw ValidationError(message: "Password must have at least 6 characters") }
        
        do {
            if try NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(message: "Password must have at least 6 characters, with at least one character and one numeric character")
            }
        } catch {
            throw ValidationError(message: "Password must have at least 6 characters, with at least one character and one numeric character")
        }
    }
}
