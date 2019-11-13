//
//  SignUpRepositoryImp.swift
//  ChatUI
//
//  Created by Ryan on 11/11/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RxSwift
import Firebase

struct SignUpRepositoryImp: SignUpRepository {
    private let auth: Auth
    private let remoteDatabase: Firestore
    
    init(auth: Auth, remoteDatabase: Firestore) {
        self.auth = auth
        self.remoteDatabase = remoteDatabase
    }
    
    func signUp(registerInfo: RegisterInfo) -> Completable {
        return Completable.create(subscribe: { completable in
            let disposables = Disposables.create()
            
            self.auth
                .createUser(
                    withEmail: registerInfo.email,
                    password: registerInfo.password,
                    completion: { authDataResult, authError in
                        if let user = authDataResult?.user {
                            let userData: [String: Any] = [
                                "email": registerInfo.email,
                                "name": registerInfo.name,
                                "mobileNumber": registerInfo.mobileNumber
                            ]
                            self.remoteDatabase
                                .collection("Users")
                                .document(user.uid)
                                .setData(userData, completion: { dbError in
                                    if let dbError = dbError {
                                        completable(.error(dbError))
                                    } else {
                                        completable(.completed)
                                    }
                                })
                        } else if let authError = authError {
                            completable(.error(authError))
                        }
            })
            
            return disposables
        })
    }
    
}
