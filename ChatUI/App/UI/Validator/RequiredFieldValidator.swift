//
//  RequiredFieldValidator.swift
//  ChatUI
//
//  Created by Ryan on 11/14/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation

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
