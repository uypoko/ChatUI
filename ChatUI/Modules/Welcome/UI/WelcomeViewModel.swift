//
//  WelcomeViewModel.swift
//  ChatUI
//
//  Created by Ryan on 11/10/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift

class WelcomeViewModel {
    var logoData: Single<Data> {
        return loadWelcomeLogo.load()
    }
    
    private let disposeBag = DisposeBag()
    private let loadWelcomeLogo: LoadWelcomeLogo
    private let welcomeNavigator: WelcomeNavigator
    
    init(loadWelcomeLogo: LoadWelcomeLogo, welcomeNavigator: WelcomeNavigator) {
        self.loadWelcomeLogo = loadWelcomeLogo
        self.welcomeNavigator = welcomeNavigator
    }
    
    @objc func showSignInView() {
        welcomeNavigator.goToSignIn()
    }
    
    @objc func showSignUpView() {
        welcomeNavigator.goToSignUp()
    }
}
