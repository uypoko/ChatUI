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
    private let localRepository: LocalRepository
    
    private let disposeBag = DisposeBag()
    
    init(signInRepository: SignInRepository, localRepository: LocalRepository) {
        self.signInRepository = signInRepository
        self.localRepository = localRepository
    }
    
    func signIn(email: String, password: String) -> Completable {
        return Completable.create { completable in
            let disposables = Disposables.create()
            
            self.signInRepository
                .signIn(email: email, password: password)
                .subscribe(
                    onSuccess: { userSession in
                        self.localRepository.persistUserSession(userSession: userSession)
                        completable(.completed)
                    },
                    onError: { completable(.error($0)) })
                .disposed(by: self.disposeBag)
            
            return disposables
        }
    }
}
