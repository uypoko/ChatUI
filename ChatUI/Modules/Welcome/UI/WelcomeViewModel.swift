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
        return logoRepository.loadLogo()
    }
    
    private let disposeBag = DisposeBag()
    private let logoRepository: LogoRepository
    private let welcomeNavigator: WelcomeNavigator
    
    init(logoRepository: LogoRepository, welcomeNavigator: WelcomeNavigator) {
        self.logoRepository = logoRepository
        self.welcomeNavigator = welcomeNavigator
    }
    
    @objc func showSignInView() {
        welcomeNavigator.goToSignIn()
    }
    
    @objc func showSignUpView() {
        welcomeNavigator.goToSignUp()
    }
}
