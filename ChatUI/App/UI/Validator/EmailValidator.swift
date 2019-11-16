//
//  EmailValidator.swift
//  ChatUI
//
//  Created by Ryan on 11/14/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//
import Foundation

struct EmailValidator: ValidatorConvertible {
    func validated(_ value: String) throws {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(message: "Invalid e-mail Address")
            }
        } catch {
            throw ValidationError(message: "Invalid e-mail Address")
        }
    }
}
