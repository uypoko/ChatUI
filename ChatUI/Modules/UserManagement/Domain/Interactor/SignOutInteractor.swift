//
//  SignOutInteractor.swift
//  ChatUI
//
//  Created by Ryan on 11/22/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift

struct SignOutInteractor {
    
    private let userManagementRepo: UserManagementRepository
    private let localRepo: LocalRepository
    
    init(userManagementRepo: UserManagementRepository, localRepo: LocalRepository) {
        self.userManagementRepo = userManagementRepo
        self.localRepo = localRepo
    }
    
    func SignOut() -> Completable {
        return Completable.create(subscribe: { completable in
            self.userManagementRepo.signOut()
                .done {
                    self.localRepo.persistUserSession(userSession: $0)
                    completable(.completed)
                }
                .catch{ completable(.error($0)) }
            
            return Disposables.create()
        })
    }
}
