//
//  MainLocalRepositoryImp.swift
//  ChatUI
//
//  Created by Ryan on 11/8/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift

struct MainLocalRepositoryImp: MainLocalRepository {
    
    var docsURL: URL? {
      return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
        in: FileManager.SearchPathDomainMask.allDomainsMask).first?.appendingPathComponent("user_session.json")
    }
    
    func readUserSession() -> Single<UserSession> {
        return Single.create(subscribe: { single in
            let disposables = Disposables.create()
            
            guard let url = self.docsURL else {
                single(.error(ReadUserSessionError.urlNotFound))
                return disposables
            }
            
            let jsonDecoder = JSONDecoder()
            guard let sessionData = try? Data(contentsOf: url) else {
                single(.error(ReadUserSessionError.fileNotFound))
                return disposables
            }
            
            if let userSession = try? jsonDecoder.decode(UserSession.self, from: sessionData)  {
                single(.success(userSession))
            } else {
                 single(.error(ReadUserSessionError.failToDecode))
            }
            
            return disposables
        })
    }
    
}
