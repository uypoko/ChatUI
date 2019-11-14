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

class ValidatorProvider {
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
            return MobileNumberValidator()
        case .requiredField(let field):
            return RequiredFieldValidator(field)
        }
    }
}
