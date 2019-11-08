//
//  MainViewModel.swift
//  ChatUI
//
//  Created by Ryan on 11/8/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {
    private let readUserSession: ReadUserSession
    private weak var mainNavigator: MainNavigator?
    
    private let disposeBag = DisposeBag()
    
    init(readUserSession: ReadUserSession, mainNavigator: MainNavigator) {
        self.readUserSession = readUserSession
        self.mainNavigator = mainNavigator
    }
    
    func checkUserSession() {
        readUserSession.hasUserSession()
            .subscribe(
                onSuccess: { [weak self] hasUserSession in
                    guard let self = self else { return }
                    if hasUserSession {
                        self.mainNavigator?.navigateToListMessages()
                    } else {
                        self.mainNavigator?.navigateToWelcome()
                    }
                })
            .disposed(by: disposeBag)
    }
}
