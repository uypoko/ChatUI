//
//  UserManagementRepositoryImp.swift
//  ChatUI
//
//  Created by Ryan on 11/22/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import PromiseKit

struct UserManagementRepositoryImp: UserManagementRepository {
    
    private let auth: Auth
    private let disposeBag = DisposeBag()
    
    init(auth: Auth) {
        self.auth = auth
    }
    
    func signOut() -> Promise<UserSession?> {
        return Promise { seal in
            do {
                try auth.signOut()
                seal.fulfill(nil)
            } catch {
                seal.reject(error)
            }
        }
    }
}
