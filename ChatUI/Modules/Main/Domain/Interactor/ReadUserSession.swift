//
//  ReadUserSession.swift
//  ChatUI
//
//  Created by Ryan on 11/8/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift

struct ReadUserSession {
    let mainLocalRepository: MainLocalRepository
    let disposeBag = DisposeBag()
    
    func hasUserSession() -> Single<Bool> {
        return Single.create(subscribe: { single in
            self.mainLocalRepository.readUserSession()
                .subscribe(
                    onSuccess: { userSession in
                        single(.success(true))
                    }, onError: { error in
                        print(error.localizedDescription)
                        single(.success(false))
                    })
                    .disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
        
    }
}
