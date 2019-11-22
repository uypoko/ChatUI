//
//  MainLocalRepositoryImp.swift
//  ChatUI
//
//  Created by Ryan on 11/8/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift

class LocalRepositoryImp: LocalRepository {
    
    private var docsURL: URL? {
      return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
        in: FileManager.SearchPathDomainMask.allDomainsMask).first?.appendingPathComponent("user_session.json")
    }
    
    func fetchUserSession() -> Single<UserSession?> {
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
                 single(.success(nil))
            }
            
            return disposables
        })
    }
    
    func persistUserSession(userSession: UserSession?) {
        guard let url = self.docsURL else { return }
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userSession) {
            try? data.write(to: url)
        }
    }
    
}
