//
//  SignInRepository.swift
//  ChatUI
//
//  Created by Ryan on 11/13/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//
import RxSwift

protocol SignInRepository {
    func signIn(email: String, password: String) -> Single<UserSession>
}
