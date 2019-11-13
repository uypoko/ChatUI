//
//  LoadWelcomeLogo.swift
//  ChatUI
//
//  Created by Ryan on 11/10/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RxSwift

struct LoadWelcomeLogo {
    private let welcomeRemoteRepository: WelcomeRemoteRepository
    
    init(welcomeRemoteRepository: WelcomeRemoteRepository) {
        self.welcomeRemoteRepository = welcomeRemoteRepository
    }
    
    func load() -> Single<Data> {
        return welcomeRemoteRepository.loadLogo()
    }
}
