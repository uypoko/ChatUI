//
//  MainLocalRepository.swift
//  ChatUI
//
//  Created by Ryan on 11/8/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift

protocol LocalRepository {
    func fetchUserSession() -> Single<UserSession?>
    func persistUserSession(userSession: UserSession?)
}
