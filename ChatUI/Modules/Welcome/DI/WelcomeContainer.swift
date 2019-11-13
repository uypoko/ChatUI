//
//  WelcomeContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/10/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import Firebase

class WelcomeContainer {
    private let appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func makeWelcomeViewController() -> WelcomeViewController {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        guard let welcomeVC = storyboard.instantiateInitialViewController() as? WelcomeViewController else {
            fatalError("Failed to initialize WelcomeViewController from storyboard")
        }
        
        let repository = WelcomeRemoteRepositoryImp(remoteStorage: appDependencyContainer.remoteStorage)
        let loadWelcomeLogo = LoadWelcomeLogo(welcomeRemoteRepository: repository)
        let welcomeViewModel = WelcomeViewModel(
            loadWelcomeLogo: loadWelcomeLogo,
            welcomeNavigator: self)
        welcomeVC.viewModel = welcomeViewModel
        
        return welcomeVC
    }
}

extension WelcomeContainer: WelcomeNavigator {
    func goToSignIn() {
        
    }
    
    func goToSignUp() {
        let signUpContainer = SignUpContainer(appDependencyContainer: appDependencyContainer)
        let signUpVC = signUpContainer.makeSignUpViewController()
        appDependencyContainer.navigationController.pushViewController(signUpVC, animated: true)
    }
    
}
