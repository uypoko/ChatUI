//
//  SignUpRepository.swift
//  ChatUI
//
//  Created by Ryan on 11/11/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RxSwift

protocol SignUpRepository {
    func signUp(registerInfo: RegisterInfo) -> Completable
}
