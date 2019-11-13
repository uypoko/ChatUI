//
//  Validator.swift
//  ChatUI
//
//  Created by Ryan on 11/12/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation

struct ValidationError: Error, LocalizedError {
    var message: String
    
    var errorDescription: String? {
        return message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws
}

enum ValidationType {
    case email
    case password
    case phone
    case requiredField(field: String)
}

class Validator {
    lazy var emailValidator = {
        return validatorFor(type: .email)
    }()
    lazy var passwordValidator = {
        return validatorFor(type: .password)
    }()
    lazy var phoneValidator = {
        return validatorFor(type: .phone)
    }()
    
    func requiredFieldValidator(fieldName: String) -> ValidatorConvertible {
        return validatorFor(type: .requiredField(field: fieldName))
    }
    
    private func validatorFor(type: ValidationType) -> ValidatorConvertible {
        switch type {
        case .email:
            return EmailValidator()
        case .password:
            return PasswordValidator()
        case .phone:
            return PhoneValidator()
        case .requiredField(let field):
            return RequiredFieldValidator(field)
        }
    }
}

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

struct PhoneValidator: ValidatorConvertible {
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

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String) throws {
        guard !value.isEmpty else {
            throw ValidationError(message: "\(fieldName) must not be empty.")
        }
    }
}
