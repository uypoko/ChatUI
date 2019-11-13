//
//  SignUpInteractor.swift
//  ChatUI
//
//  Created by Ryan on 11/11/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RxSwift

struct SignUpInteractor {
    private let signUpRepository: SignUpRepository
    
    init(signUpRepository: SignUpRepository) {
        self.signUpRepository = signUpRepository
    }
    
    func signUp(email: String, password: String, name: String, mobileNumber: String) -> Completable {
        let registerInfo = RegisterInfo(
            email: email,
            password: password,
            name: name,
            mobileNumber: mobileNumber)
        return signUpRepository.signUp(registerInfo: registerInfo)
    }
}
