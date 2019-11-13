//
//  WelcomeRemoteRepositoryImp.swift
//  ChatUI
//
//  Created by Ryan on 11/10/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Firebase
import RxSwift

struct WelcomeRemoteRepositoryImp: WelcomeRemoteRepository {
    private let remoteStorage: StorageReference
    
    init(remoteStorage: StorageReference) {
        self.remoteStorage = remoteStorage
    }
    
    func loadLogo() -> Single<Data> {
        return Single.create(subscribe: { single in
            let disposables = Disposables.create()
            
            let imgRef = self.remoteStorage.child("Library/Logo/Logo.png")
            imgRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let data = data {
                    single(.success(data))
                } else if let error = error {
                    single(.error(error))
                }
            }
            return disposables
        })
    }
}
