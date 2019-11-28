//
//  SignInRepository.swift
//  ChatUI
//
//  Created by Ryan on 11/13/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//
import PromiseKit

protocol SignInRepository {
    func signIn(email: String, password: String) -> Promise<UserSession>
}
