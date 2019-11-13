//
//  SignInRepositoryImp.swift
//  ChatUI
//
//  Created by Ryan on 11/13/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import PromiseKit
import Firebase
import RxSwift

struct SignInRepositoryImp: SignInRepository {
    private let auth: Auth
    private let remoteDatabase: Firestore
    private let disposeBag = DisposeBag()
    
    init(auth: Auth, remoteDatabase: Firestore) {
        self.auth = auth
        self.remoteDatabase = remoteDatabase
    }
    
    func signIn(email: String, password: String) -> Promise<UserSession> {
        return Promise { seal in
            auth.signIn(withEmail: email, password: password) { authData, error in
                if let user = authData?.user {
                    
                    Observable.combineLatest(
                        self.getToken(user: user).asObservable(),
                        self.getUserInfo(uid: user.uid).asObservable())
                        .subscribe(
                            onNext: { token, userInfo in
                                let userSession = UserSession(
                                    name: userInfo.name,
                                    email: email,
                                    mobileNumber: userInfo.mobileNumber,
                                    token: token)
                                
                                seal.fulfill(userSession)
                            },
                            onError: { seal.reject($0) })
                        .disposed(by: self.disposeBag)
                } else if let error = error {
                    seal.reject(error)
                }
            }
        }
    }
    
    private func getToken(user: User) -> Single<String> {
        return Single.create(subscribe: { single in
            user.getIDToken(completion: { token, error in
                if let token = token {
                    single(.success(token))
                } else if let error = error {
                    single(.error(error))
                }
            })
            
            return Disposables.create()
        })
    }
    
    private func getUserInfo(uid: String) -> Single<(name: String, mobileNumber: String)> {
        return Single.create(subscribe: { single in
            let docRef = self.remoteDatabase.collection("Users").document(uid)
            docRef.getDocument { document, error in
                if let document = document,
                    document.exists,
                    let data = document.data(),
                    let name = data["name"] as? String,
                    let mobileNumber = data["mobileNumber"] as? String {
                    single(.success((name, mobileNumber)))
                } else if let error = error {
                    single(.error(error))
                }
            }
            
            return Disposables.create()
        })
    }

}
