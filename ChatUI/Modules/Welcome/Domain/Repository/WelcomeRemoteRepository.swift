//
//  WelcomeRemoteRepository.swift
//  ChatUI
//
//  Created by Ryan on 11/10/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RxSwift

protocol WelcomeRemoteRepository {
    func loadLogo() -> Single<Data>
}
