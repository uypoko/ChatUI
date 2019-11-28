//
//  SignInInteractor.swift
//  ChatUI
//
//  Created by Ryan on 11/13/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import PromiseKit
import RxSwift

struct SignInInteractor {
    private let signInRepository: SignInRepository
    private let userSessionRepository: UserSessionRepository
    
    private let disposeBag = DisposeBag()
    
    init(signInRepository: SignInRepository, userSessionRepository: UserSessionRepository) {
        self.signInRepository = signInRepository
        self.userSessionRepository = userSessionRepository
    }
    
    func signIn(email: String, password: String) -> Completable {
        return Completable.create { completable in
            let disposables = Disposables.create()
            
            self.signInRepository
                .signIn(email: email, password: password)
                .done {
                    self.userSessionRepository.persistUserSession(userSession: $0)
                    completable(.completed)
                }
                .catch { completable(.error($0)) }
            
            return disposables
        }
    }
}
