//
//  UserManagementRepository.swift
//  ChatUI
//
//  Created by Ryan on 11/22/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//
import PromiseKit

protocol UserManagementRepository {
    func signOut() -> Promise<UserSession?>
}
